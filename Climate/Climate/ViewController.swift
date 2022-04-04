//
//  ViewController.swift
//  Climate
//
//  Created by Avani Patel on 2022-04-02.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var WeatherImage: UIImageView!
    @IBOutlet weak var temperatureLable: UILabel!
    @IBOutlet weak var locationLable: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var WeatherCondition: UILabel!
    //private let locationManager = CLLocationManager()
    //private let locationDelegate = MyLocationDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
        //location
        //displayLocation(location: "Tap Get Location")
        
        locationManager.delegate = self

        
        
       // let config = UIImage.SymbolConfiguration(paletteColors: [.systemBlue, .systemYellow, .systemTeal])
    
       // WeatherImage.preferredSymbolConfiguration = config
       // WeatherImage.image = UIImage(systemName: "cloud.moon")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print(textField.text ?? "")
        textField.endEditing(true)
        print(textField.text ?? "")
        getWeather(search: textField.text)
        return true
    }
    
    private let locationManager = CLLocationManager()
    
    //code for location button
    @IBAction func onGetLocationTapped(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        //locationManager.startUpdatingLocation()
    }
    
   // private func displayLocation(location: String) {
        //locationLable.text = location
    //}
    
   
    
    
    @IBAction func onSearchTapped(_ sender: UIButton) {
        searchTextField.endEditing(true)
        getWeather(search: searchTextField.text)
    }
    
    
   // class MyLocationDelegate: NSObject, CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                print("Got location")
            
            if let location = locations.last {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                print("LatLng: (\(latitude),\(longitude))")
                let latlngString = "\(latitude),\(longitude)"
                self.onLocationHandle(latlngString: latlngString)
                //self.displayLocation("(\(latitude),\(longitude))")
                //getWeather(search: "\(latitude),\(longitude)")
                //getWeather(search: "(\(latitude),\(longitude))")
                //print(getWeather(search: "(\(latitude),\(longitude))"))
            }
        }

            func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                print("error")
            }
        
        
   
    
    private func getWeather(search: String?) {
        guard let search = search else {
            return
        }
        
        //step 1: Get URL
        let url = getUrl(search: search)
        
        guard let url = url else {
            print("Could not get URL")
            return
        }
        
        //step 2: Create URLSession
        let session = URLSession.shared
        
        //step 3: Create task for session
        let dataTask = session.dataTask(with: url) { data, response, error in
            print("network call complete")
            //network call finished
            
            guard error == nil else {
                print("received error")
                return
            }
            
            guard let data = data else {
                print("No data found")
                return
            }
            if let weather = self.parseJson(data: data) {
                print(weather.location.name)
                print(weather.current.temp_c)
                
                DispatchQueue.main.async {
                    self.locationLable.text = weather.location.name
                    self.temperatureLable.text = "\(weather.current.temp_c)C"
                    
                    if (weather.current.condition.code) == 1000 {
                                            self.WeatherImage.image = UIImage(systemName: "sun.max.circle")
                                            self.WeatherCondition.text = "\(weather.current.condition.text)"
                                            
                                          
                                        }else if (weather.current.condition.code) == 1114  {
                                            self.WeatherImage.image = UIImage(systemName: "snowflake")
                                            self.WeatherCondition.text = "\(weather.current.condition.text)"
                                            
                                        }else if (weather.current.condition.code) == 1195  {
                                            self.WeatherImage.image = UIImage(systemName: "cloud.heavyrain")
                                            self.WeatherCondition.text = "\(weather.current.condition.text)"
                                            
                                        }else if (weather.current.condition.code) == 1225 {
                                            self.WeatherImage.image = UIImage(systemName: "snowflake.circle")
                                            self.WeatherCondition.text = "\(weather.current.condition.text)"
                                            
                                        }else if (weather.current.condition.code) == 1006  {
                                            self.WeatherImage.image = UIImage(systemName: "cloud")
                                            self.WeatherCondition.text = "\(weather.current.condition.text)"
                                            
                                        }else if (weather.current.condition.code) == 1183 {
                                            self.WeatherImage.image = UIImage(systemName: "cloud.rain")
                                            self.WeatherCondition.text = "\(weather.current.condition.text)"
                                        }else if (weather.current.condition.code) == 1030 {
                                                self.WeatherImage.image = UIImage(systemName: "cloud.fog")
                                                self.WeatherCondition.text = "\(weather.current.condition.text)"
                                        }else if (weather.current.condition.code) == 1135 {
                                                self.WeatherImage.image = UIImage(systemName: "cloud.fog.fill")
                                                self.WeatherCondition.text = "\(weather.current.condition.text)"

                                        }else if (weather.current.condition.code) == 1009 {
                                                self.WeatherImage.image = UIImage(systemName: "cloud.sun.rain.fill")
                                                self.WeatherCondition.text = "\(weather.current.condition.text)"

                                        }
                }
                
                
            }
        }
        //step 4: Start the task
        dataTask.resume()
    }
    
    private func parseJson(data: Data) -> WeatherResponse? {
        let decoder = JSONDecoder()
        var weatherResponse: WeatherResponse?
        
        do {
            weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
        } catch{
            print("Error parsing weather")
            print(error)
        }
        
        return weatherResponse
    }
    
    private func onLocationHandle(latlngString: String) {
        getWeather(search: latlngString)
    }
    
    private func getUrl(search: String) -> URL? {
        let baseUrl = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "current.json"
        let apiKey = "f9e1a6c224e14d8cb7d221149220204"
        
        /*let query = "q=London"
         let url = "http://api.weatherapi.com/v1/current.json?key=f9e1a6c224e14d8cb7d221149220204&q=London&aqi=no"*/
        
        let url = "\(baseUrl)\(currentEndpoint)?key=\(apiKey)&q=\(search)&aqi=no".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let Url = url else {
            return nil
        }
        return URL(string: Url)
    }
    
}

struct WeatherResponse: Decodable{
    let location: Location
    let current: Weather
}

struct Location: Decodable{
    let name: String
}

struct Weather: Decodable{
    let temp_c: Float
    let condition: WeatherCondition
}
struct WeatherCondition: Decodable {
    let text: String
    let code: Int
}




/*
 {
 "location": {
 "name": "London",
 "region": "City of London, Greater London",
 "country": "United Kingdom",
 "lat": 51.52,
 "lon": -0.11,
 "tz_id": "Europe/London",
 "localtime_epoch": 1648937803,
 "localtime": "2022-04-02 23:16"
 },
 "current": {
 "last_updated_epoch": 1648933200,
 "last_updated": "2022-04-02 22:00",
 "temp_c": 4.0,
 "temp_f": 39.2,
 "is_day": 0,
 "condition": {
 "text": "Clear",
 "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
 "code": 1000
 },
 "wind_mph": 2.5,
 "wind_kph": 4.0,
 "wind_degree": 360,
 "wind_dir": "N",
 "pressure_mb": 1026.0,
 "pressure_in": 30.3,
 "precip_mm": 0.0,
 "precip_in": 0.0,
 "humidity": 65,
 "cloud": 0,
 "feelslike_c": 2.3,
 "feelslike_f": 36.1,
 "vis_km": 10.0,
 "vis_miles": 6.0,
 "uv": 1.0,
 "gust_mph": 6.0,
 "gust_kph": 9.7
 }
 }
 */
