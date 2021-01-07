//
//  NetworkProtocols.swift
//  Hexaware
//
//  Created by Vinod Reddy Sure on 07/01/21.
//  Copyright © 2021 Vinod Reddy Sure. All rights reserved.
//

import UIKit

protocol NetworkProtocol {
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ())
    func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping (WeatherModel) -> ())
    func fetchFiveDaysWeatherForecast(city: String, completion: @escaping ([ForecastTemperature]) -> ())
}
