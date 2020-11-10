
import UIKit

class FutureWeatherViewController: UIViewController, FutureWeatherManagerDelegate {
    
    var futureWeatherManager = FuturetWeatherManager()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    var filteredWeather: FilteredWeather = FilteredWeather(dayTime: [], nightTime: [])
    var items = [1, 2, 3, 4, 5]
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    var city: String = ""
    
    var delegate:  FutureWeatherManagerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        futureWeatherManager.delegate = self
        futureWeatherManager.fetchFutureWeather(cityName: city)
        
        
        
        
    }
    
    
    func didUpdateFutureWeather(weather: FutureWeatherModel) {
        DispatchQueue.main.async {
            
            self.cityLabel.text = "\(weather.cityName), \(weather.countryInic)"
            
            for i in 0 ..< weather.weather.count{
                let mySubString2 = weather.weather[i].dateText.suffix(8)
                let mySubString3 = mySubString2.prefix(2)
                if mySubString3 == "15" {
                    self.filteredWeather.dayTime.append(weather.weather[i])
                } else if mySubString3 == "03" {
                    self.filteredWeather.nightTime.append(weather.weather[i])
                }
            }
            
            self.collectionView.reloadData()
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func didFailWithError(error: Error) {
        print(error)
    }
   
    

}

extension FutureWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        filteredWeather.dayTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MyCollectionViewCell
        
        let index = indexPath.row
        cell.dateLabel.text = self.date(date: self.filteredWeather.dayTime[index].dateText)
        cell.dayTimeLabel.text = String(self.filteredWeather.dayTime[index].temperature)
        cell.nightTimeLabel.text = String(self.filteredWeather.nightTime[index].temperature)
        
        
        
        
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    
    
    func date(date: String) -> String {
        let s1 = date.prefix(10)
        let s2 = s1.suffix(5)
        let day = s2.suffix(2)
        let month = s2.prefix(2)
        
        return "\(day).\(month)"
    }
    
}


struct FilteredWeather {
    var dayTime: [WeatherInfo]
    var nightTime: [WeatherInfo]
}



