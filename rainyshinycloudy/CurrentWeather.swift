//
//  CurrentWeather.swift
//  rainyshinycloudy
//
//  Created by Caleb Stultz on 7/27/16.
//  Copyright © 2016 Caleb Stultz. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = NSLocale(localeIdentifier: "tr_TR") as Locale!
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Bugün, \(currentDate)"
        return _date
     
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) { //İndirme işleminin bittiğini bize bildirir //typealias DownloadComplete = () -> () sayesinde diğer classta
        //Alamofire Download
        
        
        //let currentWeatherURL = URL(string: CURRENT_WEATHER_URL) //Bilgiyi nereden indireceği
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in      //Cevabı JSON tipinde gelecek bize bir cevap döndükten sonra response vereceğiz
            let result = response.result    //Every response has a result and every result has a response
            
            
            if let dict = result.value as? Dictionary<String,AnyObject> { //Gelen data ilki String ikinicisi double integer olabilir
                
                if let name = dict["name"] as? String {  //Şehir ismi 1 key stringi bir de value "name":"Ankara" bundan keyini alıyoruz valuesini çekiyoruz
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                
                if let weather = dict["weather"] as? [Dictionary<String,AnyObject>] {        //Weather yapısı arraylerden oluşan bir dictionary olduğu için ilk olarak Arraya cast edip ardından o arrayın 0. elemanının keyi main olanını çektik.
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                }
               
                if let main = dict["main"] as? Dictionary<String,AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        
                        
                        let kelvinToCelsius = Double(round(currentTemperature - 273.15))
                        self._currentTemp = kelvinToCelsius
                        print(self._currentTemp)
                    }
                }
                
            }
            completed()
            
        }
        
    }
}












