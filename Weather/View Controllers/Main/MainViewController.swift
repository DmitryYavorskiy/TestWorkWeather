//
//  MainViewController.swift
//  Weather
//
//  Created by Dmitriy Yavorskiy on 15.11.16.
//  Copyright © 2016 Dmitriy Yavorskiy. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet var tableCity: UITableView?
    
    var cityNameArray = Array<String>()
    var cityIconArray = Array<String>()
    var cityTempArray = Array<Int>()
    var cityHumidityArray = Array<Int>()
    var cityWindSpeedArray = Array<Double>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToAdd" {
            let addCity: AddCityController = segue.destination as! AddCityController
            addCity.cityDelegate = self
        }
    }
}

//MARK: - Add City Delegate

extension MainViewController: AddCityDelegate {
    
    func updateCityList() {
        loadApi()
    }
}

//MARK: - Load Data

extension MainViewController {
    
    func loadApi() {
        let realm = try! Realm()
        
        let city = realm.objects(City.self)
        
        let cityIdArray = city.value(forKey: "id") as! [String]
        
        DataRequest.getData(dictionaryData: ["idArray" : cityIdArray], dictHttpBody: nil, methodName: MethodName.getGroupById, completionHandler: { (succes, info, errorCode) in
            self.loadData()
        })
    }
    
    func loadData() {
        
        let realm = try! Realm()
        let allCityGroup = realm.objects(CityGroup.self)
        
        cityNameArray = allCityGroup.value(forKey: "name") as! Array
        cityIconArray = allCityGroup.value(forKey: "icon") as! Array
        cityTempArray = allCityGroup.value(forKey: "temp") as! Array
        cityHumidityArray = allCityGroup.value(forKey: "humidity") as! Array
        cityWindSpeedArray = allCityGroup.value(forKey: "windSpeed") as! Array
        
        DispatchQueue.main.async {
            self.tableCity?.reloadData()
        }
    }
}

//MARK: - Table Data Source

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "cityCellid", for: indexPath) as! CustomCell
        
        cell.titleText?.text = cityNameArray[indexPath.row]
        cell.iconImage?.image = UIImage(named: cityIconArray[indexPath.row])
        cell.subTitleText?.text = "Temperature: \(cityTempArray[indexPath.row])°C\nHumidity: \(cityHumidityArray[indexPath.row])%\nWind: \(cityWindSpeedArray[indexPath.row]) m/s"
        
        return cell
    }
    
}
