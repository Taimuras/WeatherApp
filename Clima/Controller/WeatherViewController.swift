
import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate,  CurrentWeatherManagerDelegate {
    
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var currentWeatherManager = CurrentWeatherManager()
    var futureWeatherManager = FuturetWeatherManager()
    let locationManager = CLLocationManager()
//    var weatherModel: FutureWeatherModel?
    
    var city: String = ""
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
       
        
        currentWeatherManager.delegate = self
        searchTextField.delegate = self
        
        
    }

    @IBAction func currentLocationTriggered(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    
    @IBAction func fiveDaysDescriptionTapped(_ sender: UIButton) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
            textField.placeholder = "Type Something Here"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            currentWeatherManager.fetchWeather(cityName: city)
            futureWeatherManager.fetchFutureWeather(cityName: city)
            
        }
        textField.placeholder = "Search"
        searchTextField.text = ""
    }
    
    func didUpdateWeather(weather: CurrentWeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.city = weather.cityName
        }
    }
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fiveDaysSegue" {
            let destinationController = segue.destination as! FutureWeatherViewController
            destinationController.city = city
        }
    }
    
}
//MARK: CL Location manager Delegate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            currentWeatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
