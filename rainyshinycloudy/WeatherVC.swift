//
//  WeatherVC.swift
//  rainyshinycloudy
//
//  Created by Caleb Stultz on 7/26/16.
//  Copyright © 2016 Caleb Stultz. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather = CurrentWeather()
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //Ne kadar doğruluk istediğin
        locationManager.requestWhenInUseAuthorization() //Sadece kullanırken konum algılaması için
        locationManager.startMonitoringSignificantLocationChanges() //GPS değişikliğimi takip eder
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) { //Uygulamanın arka planı yüklenmeden konum izinin soracak
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {         //lokasyonu kullanıp kullanmadığını kontrol etmek maksatlı
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
           currentLocation = locationManager.location       //info plist içinde privacy location when in use seçeneğinde popup da ne çıkacağını yazarsın.
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails{
                self.downloadForecastData {
                    self.updateMainUI()
                }
            }
        } else {
           locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()        //Eğer izin vermeyip şimdi vermişse tekrar çalışır.
        }
    }
    
    
    
    func downloadForecastData(completed : @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        
       // let forecastURL = URL(string:FORECAST_URL)!
        Alamofire.request(FORECAST_URL).responseJSON { response in   //JSON formatında dönsün istiyoruz
            let result = response.result                            //Sonucun raw halini yani ham halini alıp içinde lazım olanları seçeceğiz
            
            if let dict = result.value as? Dictionary<String,AnyObject> {   //İlk nesne string ikinci array olur double olur farketmez
                
                if let list = dict["list"] as? [Dictionary<String,AnyObject>] {
                   
                    for obj in list {
                        let forecast = Forecast(weatherDict : obj)  //her bir dictionary objesini Forecast classına geçiyoruz.
                        self.forecasts.append(forecast) //her bir dictionaryi arrayin içine atıyor
                        print(obj)
                    }
                   self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            completed()
    }
    
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 6  bu haliyle hata verir çünkü 16 günlük raporu çekerkeb 6 yer veriyorsun
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell{
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
        

    }
    
    

    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
}

