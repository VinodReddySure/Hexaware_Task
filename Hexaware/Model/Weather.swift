//
//  Weather.swift
//  Hexaware
//
//  Created by Vinod Reddy Sure on 07/01/21.
//  Copyright © 2021 Vinod Reddy Sure. All rights reserved.
//

import UIKit
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Float
    let humidity: Float
}

struct Sys: Codable {
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}

struct WeatherModel: Codable {
    let weather: [Weather]
    let main: Main
    let sys: Sys
    let name: String?
    let dt: Int
    let timezone: Int?
    let dt_txt: String?
}

struct ForecastModel: Codable {
    var list: [WeatherModel]
    let city: City
}

struct City: Codable {
    let name: String?
    let country: String?
    
}
