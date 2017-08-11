//: Playground - noun: a place where people can play

import UIKit

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "899e5b56739377b8763e35fa3cec88d0"

typealias DownloadComplete = () -> () //İndirme işleminin bitişini söyler

let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)\(LONGITUDE)\(APP_ID)\(API_KEY)"
