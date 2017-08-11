//
//  Location.swift
//  rainyshinycloudy
//
//  Created by Caleb Stultz on 7/28/16.
//  Copyright © 2016 Caleb Stultz. All rights reserved.
//

import CoreLocation

class Location {                    //Singleton classdır konuma diğer sınıflardan erişebilmeyi sağlayaacağız
    static var sharedInstance = Location()
    private init() {}
    
    var latitude:Double!
    var longitude:Double!           //Konum datasını buraya kaydedip her yerden erişebileceğiz singleton kullanarak
}
