

// API key - 887423efb2e91bf0b8ce30df56f2ebd0
import UIKit
import CoreLocation

protocol  FutureWeatherManagerDelegate {
    func didUpdateFutureWeather(weather: FutureWeatherModel)
    func didFailWithError(error: Error)
}

struct FuturetWeatherManager {
    var weatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=887423efb2e91bf0b8ce30df56f2ebd0&units=metric"
    
    var delegate:  FutureWeatherManagerDelegate?
    
    
    func fetchFutureWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequset(urlString: urlString)
    }
    
    func fetchFutureWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequset(urlString: urlString)
    }
    
    // 1. Create url
    // 2. Create a URL Session
    // 3. Give the session a task
    // 4. Start the task
    
    
    func performRequset (urlString: String) {
        // 1. Create url
        
        if let url = URL(string: urlString){
            // 2. Create a URL Session
            
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(weatherData: safeData){
                        delegate?.didUpdateFutureWeather(weather: weather)
                       
                    }
                    
                    
                }
            }
            // 4. Start the task
            task.resume()
            
        }
        
    }
    
    func parseJSON(weatherData: Data) -> FutureWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(FutureWeatherData.self, from: weatherData)
            
            let cityName = decodedData.city.name
            let cityCountry = decodedData.city.country
            var weatherForecast: [WeatherInfo] = []
            for i in 0 ..< decodedData.list.count {
                let wf: WeatherInfo = WeatherInfo(dateText: decodedData.list[i].dt_txt, temperature: decodedData.list[i].main.temp, clearSky: decodedData.list[i].weather[0].id, windSpeed: decodedData.list[i].wind.speed, windDegree: decodedData.list[i].wind.deg)
              
                weatherForecast.append(wf)


            }
            
        
            let weather = FutureWeatherModel(cityName: cityName, countryInic: cityCountry, weather: weatherForecast)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    

    
    
}
