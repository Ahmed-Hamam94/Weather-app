//
//  WeatherService.swift
//  WeatherDemo
//
//  Created by Ahmed Hamam on 24/01/2023.
//

import Foundation
import CoreLocation

protocol WeatherServiceDelegate{
    func setWeather(weather : MyResult)
}
protocol ChangeCityDelegate {
    func userEnteredNewCityName(city : String)
}
protocol WeatherErrorDelegate{
    func setWeatherError(weatherError : WeatherError)
}



class WeatherService{
    
    static let shared = WeatherService()
    
    private init() {
        
    }
    
    var delegateWeather : WeatherServiceDelegate?
    
    var delegateError : WeatherErrorDelegate?
    let apiKey = ""  // use your appid
    
    // MARK: -  GET WEATHER FROM API USING CITY NAME
    func getWeather(city : String){
        let cityEscaped = city.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        guard let cityEscaped = cityEscaped else {return}
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped)&appid=\(apiKey)") else{return}
        
        let request = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                
                print("Empty Response")
                return
            }
            
            print("Response status code: \(response.statusCode)")
            guard let data = data else{
                print("Empty Data")
                return}
            print(data)
            
            if response.statusCode == 200 {
                do{
                    let result = try JSONDecoder().decode(MyResult.self, from: data)
                    print(result)
                    
                    let Cod = result.cod
                    let name = result.name
                    let lon = result.coord?.lon
                    let lat = result.coord?.lat
                    let temp = result.main?.temp
                    let descr = result.weather?[0].description
                    let icon = result.weather?[0].icon
                    
                    
                    DispatchQueue.main.async {
                        guard self.delegateWeather != nil else {return}
                        self.delegateWeather?.setWeather(weather: result)
                    }
                    
                    
                    print("temp: \(temp ?? 0.0)  lon: \(lon ?? 0.0) lat: \(lat ?? 0.0) Decr: \(descr ?? "..") Icon:\(icon ?? "icon?") Cod: \(Cod ?? 1)")
                    
                    
                    print(name ?? "city")
                    
                    
                }catch{
                    print(error)
                }
                // IF USER ENTER WRONG CITY NAME
            }else if response.statusCode == 404{
                do{
                    let result = try JSONDecoder().decode(WeatherError.self, from: data)
                    print(result)
                    
                    let Cod = result.cod
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        guard self.delegateError != nil else {return}
                        self.delegateError?.setWeatherError(weatherError: result)
                    }
                    
                    
                    print(Cod)
                    
                    
                    
                    
                    
                }catch{
                    print(error)
                }
                
            }
            
            
        }
        task.resume()
        
    }
    // MARK: - GET WEATHER FROM API USING LON & LAT
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees, completionHandler: @escaping (MyResult?) -> Void){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") else{return}
        
        let request = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                print("Empty Response")
                return
            }
            
            print("Response status code: \(response.statusCode)")
            guard let data = data else{
                print("Empty Data")
                return}
            print(data)
            
            do{
                let result = try JSONDecoder().decode(MyResult.self, from: data)
                print(result)
                completionHandler(result)
                
                
                
            }catch{
                print(error)
            }
            
            
            
        }
        task.resume()
        
    }
    
    
    
}
