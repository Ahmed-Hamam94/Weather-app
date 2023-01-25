//
//  ChangeViewController.swift
//  WeatherDemo
//
//  Created by Ahmed Hamam on 24/01/2023.
//

import UIKit
import CoreLocation
class ChangeViewController: UIViewController {
    // MARK: - IBOUTLETS
    @IBOutlet weak var cityTextField: UITextField!{
        didSet{
            cityTextField.layer.cornerRadius = cityTextField.frame.size.height / 2
            cityTextField.layer.borderColor = UIColor.darkGray.cgColor
            cityTextField.layer.borderWidth = 2
            cityTextField.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var changeCityView: UIView!{
        didSet{
            changeCityView.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var changeCityBtn: UIButton!{
        didSet{
            changeCityBtn.layer.cornerRadius = 20
            changeCityBtn.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            //backBtn.backgroundColor = #colorLiteral(red: 0.5517860651, green: 0.3727029562, blue: 0.2742487788, alpha: 1)
            backBtn.layer.cornerRadius = backBtn.frame.size.height / 2
        }
    }
    
    // MARK: -  VARIABLES
    var delegateCity : ChangeCityDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconImageView.image = UIImage(named: "sun")
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func changeCityBtn(_ sender: Any) {
        let txte = cityTextField.text
        guard let txte = txte else {return}
        if cityTextField.text != ""{
            locationOfCity(destination: txte)
            
            delegateCity?.userEnteredNewCityName(city: txte)
            
            dismiss(animated: true)
            
        }else{
            showSearchAlert(msg: "Please enter City name")
        }
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - ALERT MESSAGE
    func showSearchAlert(msg: String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present (alert, animated: true, completion: nil)
        
    }
    
}

// MARK: - LOCATION OF CITY USING CORELOCATION
extension ChangeViewController{
    func locationOfCity(destination: String) {
        let geoCoder = CLGeocoder ()
        geoCoder.geocodeAddressString(destination) { places, error in
            guard let place = places?.first, error == nil else {
                self.showSearchAlert(msg: "no data to display")
                return
            }
            print ("place detaild ..")
            print ("place name \(place.name ?? "no name to display")")
            print("place country \(place.country ?? "no country to display")")
            print ("place country code \(place.isoCountryCode ?? "no isoCountryCode todisplay")")
            print("place administrativeArea \(place.administrativeArea ?? "no administrativeArea to display")")
            print("place Locality \(place.locality ?? "no Locality to display")")
            print("place PostalCode \(place.postalCode ?? "no PostalCode to display")")
            
            self.cityTextField.text = ""
            
        }
    }
}
