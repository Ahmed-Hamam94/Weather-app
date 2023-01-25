//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Ahmed Hamam on 23/01/2023.
//

import UIKit
import CoreLocation
class HomeViewController: UIViewController, ChangeCityDelegate,WeatherServiceDelegate,WeatherErrorDelegate{
    // MARK: - IBOUTLETS
    @IBOutlet weak var homeView: UIView!{
        didSet{
            homeView.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var weatherLabel: UILabel!{
        didSet{
            weatherLabel.layer.cornerRadius = 25
            weatherLabel.clipsToBounds = true
            weatherLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            weatherLabel.layer.borderColor = UIColor.orange.cgColor
            weatherLabel.layer.borderWidth = 2
        }
    }
    
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var TemperatureLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    // MARK: - VARIABLES
    var resultData : MyResult?
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    let indicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpIndicator()
        
        WeatherService.shared.delegateWeather = self
        WeatherService.shared.delegateError = self
        
        
        setUpLocation()
        requestWeatherForLocation()
        
    }
    // MARK: - IBACTIONS
    @IBAction func nextBtn(_ sender: Any) {
        guard let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeViewController") as? ChangeViewController else{return}
        secondVC.delegateCity = self
        present(secondVC, animated: true)
    }
    // MARK: - INICATOR
    func setUpIndicator(){
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    // MARK: - PASS CITY NAME TO APISERVICE
    func userEnteredNewCityName(city: String) {
        indicator.startAnimating()
        WeatherService.shared.getWeather(city: city)
    }
    
    
    // MARK: - SET WEATHER IN UI
    func setWeather(weather: MyResult) {
        print("ViewController set Weather")
        indicator.stopAnimating()
        var temp = weather.main?.temp
        temp = (temp ?? 0.0) - 272.15
        temp = Double(round(1000 * (temp ?? 0.0))/1000)
        let tempInt = Int(temp ?? 0)
        guard let icon = weather.weather?[0].icon else{return}
        cityNameLabel.text = "\(weather.name ?? "city name")"
        TemperatureLabel.text = "\(tempInt )°C"
        pressureLabel.text = "\(weather.main?.pressure ?? 0)"
        humidityLabel.text =  "\(weather.main?.humidity ?? 0)"
        descriptionLabel.text = "\(weather.weather?[0].description ?? "")"
        let url = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        iconImageView.downloadImage(for: url)
    }
    //
    func setWeatherError(weatherError : WeatherError){
        print("ViewController set Weather Error")
        indicator.stopAnimating()
        showAlert(msg: weatherError.message)
        cityNameLabel.text = ""
        TemperatureLabel.text = ""
        pressureLabel.text = ""
        humidityLabel.text =  ""
        descriptionLabel.text = ""
        iconImageView.image = UIImage(named: "404")
        
    }
    
    // MARK: - ALERT MESSAGE
    func showAlert(msg: String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present (alert, animated: true, completion: nil)
        
    }
    
}
// MARK: - EXTENTION TO USE MY LOCATION
extension HomeViewController : CLLocationManagerDelegate {
    
    func setUpLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    // MARK: - ACCESS MY LOCATION
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil{
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    // MARK: - PASS longitude & latitude OF MYLOCATION TO APISERVICE AND GET WEATHER
    func requestWeatherForLocation(){
        guard let currentLocation = currentLocation else{return}
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        print("**\(lat)**\(lon)")
        WeatherService.shared.fetchWeather(lat: lat, lon: lon) {[weak self] MyResultData in
            
            guard let self = self else { return }
            DispatchQueue.main.async {
                
                self.indicator.stopAnimating()
                self.updateUIWithData(result: MyResultData)
                
            }
        }
    }
    // MARK: - SET WERATHER IN UI
    func updateUIWithData(result: MyResult?) {
        resultData = result
        guard let icon = resultData?.weather?[0].icon else{return}
        let url = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        var temp = resultData?.main?.temp
        temp = (temp ?? 0.0) - 272.15
        temp = Double(round(1000 * (temp ?? 0.0))/1000)
        let tempInt = Int(temp ?? 0)
        cityNameLabel.text = resultData?.name
        TemperatureLabel.text = "\(tempInt )°C"
        pressureLabel.text = "\(resultData?.main?.pressure ?? 0)"
        humidityLabel.text = " \(resultData?.main?.humidity ?? 0)"
        descriptionLabel.text = "\(resultData?.weather?[0].description ?? "")"
        iconImageView.downloadImage(for: url)
        print(resultData?.name ?? "city???")
    }
    
    
    
}




extension UIImageView {
    func downloadImage(for url: String) {
        DispatchQueue.global(qos: .default).async {
            if let url = URL(string: url), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    
                }
            }
        }
    }
}




