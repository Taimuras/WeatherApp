
import UIKit


struct FutureWeatherData: Decodable {
    let city: CityInfo
    let list: [WeatherList]
}

struct CityInfo: Decodable {
    let name: String
    let country: String
}

struct WeatherList: Decodable {
    let main: MainInfo
    let weather: [ClearSkyInfo]
    let wind: Wind
    let dt_txt: String
}

struct MainInfo: Decodable {
    let temp: Double
}

struct ClearSkyInfo: Decodable {
    let id: Int
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
}

