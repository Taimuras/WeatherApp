
import UIKit

struct FutureWeatherModel{
    var cityName: String
    var countryInic: String
    var weather: [WeatherInfo]
    
    
}

struct WeatherInfo {
    var dateText: String
    var temperature: Double
    var clearSky: Int
    var windSpeed: Double
    var windDegree: Int
    init(dateText: String, temperature: Double, clearSky: Int, windSpeed: Double, windDegree: Int) {
        self.dateText = dateText
        self.temperature = temperature
        self.clearSky = clearSky
        self.windSpeed = windSpeed
        self.windDegree = windDegree
    }
    
    var conditionName: String {
            switch clearSky {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 801...804:
                return "cloud.bolt"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            default:
                return "cloud"
            }
    
        }
}


//
//import UIKit
//
//
//struct FutureWeatherData: Decodable {
//    let city: CityInfo
//    let list: [WeatherList]
//}
//
//struct CityInfo: Decodable {
//    let name: String
//    let country: String
//}
//
//struct WeatherList: Decodable {
//    let main: MainInfo
//    let weather: [ClearSkyInfo]
//    let wind: Wind
//    let dt_txt: String
//}
//
//struct MainInfo: Decodable {
//    let temp: Double
//}
//
//struct ClearSkyInfo: Decodable {
//    let id: Int
//}
//
//struct Wind: Decodable {
//    let speed: Double
//    let deg: Int
//}




