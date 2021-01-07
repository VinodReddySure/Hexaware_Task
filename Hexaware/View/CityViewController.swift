//
//  CityViewController.swift
//  Hexaware
//
//  Created by Vinod Reddy Sure on 07/01/21.
//  Copyright © 2021 Vinod Reddy Sure. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var symbolImage: UIImageView!
    @IBOutlet weak var forecastButton: UIButton!
    
    var selectedCity = KnownCities()
    let networkManager = WeatherNetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

}

extension CityViewController {
    
    func initialLoads() {
        print(selectedCity)
        self.fetchData(city: self.selectedCity.cityName ?? "")
        self.forecastButton.addTarget(self, action: #selector(forecast), for: .touchUpInside)
    }
    
    func loadData(data:WeatherModel) {
        print("Current Temperature", data.main.temp.kelvinToCeliusConverter())
        
        DispatchQueue.main.async {
            self.labelTemperature.text = (String(data.main.temp.kelvinToCeliusConverter()) + "°C")
            self.labelCity.text = "\(data.name ?? "") , \(data.sys.country ?? "")"
            self.labelDescription.text = data.weather[0].description

            self.symbolImage.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(data.weather[0].icon)@2x.png")
        }

    }
    
    func fetchData(city:String) {
        networkManager.fetchCurrentWeather(city: city) { (weather) in
            self.loadData(data: weather)
        }
    }
    
    @IBAction func forecast() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForecastViewController") as! ForecastViewController
        vc.selectedCity = self.selectedCity
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
