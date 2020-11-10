
import UIKit
import CoreLocation

protocol  CurrentWeatherManagerDelegate {
    func didUpdateWeather(weather: CurrentWeatherModel)
    func didFailWithError(error: Error)
}

struct CurrentWeatherManager {
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=887423efb2e91bf0b8ce30df56f2ebd0&units=metric"
    
    var delegate:  CurrentWeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequset(urlString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
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
                        delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            // 4. Start the task
            task.resume()
            
        }
        
    }
    
    func parseJSON(weatherData: Data) -> CurrentWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrentWeatherData.self, from: weatherData)
        
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = CurrentWeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    

    
    
}
