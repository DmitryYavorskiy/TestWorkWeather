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
    @IBOutlet var editButton: UIBarButtonItem?
    
    var cityIdArray = Array<Int>()
    var cityNameArray = Array<String>()
    var cityIconArray = Array<String>()
    var cityTempArray = Array<Int>()
    var cityHumidityArray = Array<Int>()
    var cityWindSpeedArray = Array<Double>()
    
    var preloadView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        preloadView = PreloaderView.preloaderView(view: self.view, indicator: true)
        
        loadApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*let realm = try! Realm()
        let allGroup = realm.objects(CityWeather.self)
        print(allGroup)*/
    }
    
    // MARK: - Edit Table Action

    @IBAction func editTableAction(_ sender: Any) {
        
        if tableCity?.isEditing == true {
            tableCity?.setEditing(false, animated: true)
            editButton?.title = "Edit"
        } else {
            tableCity?.setEditing(true, animated: true)
            editButton?.title = "Done"
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "segueToAdd" {
            let addCity: AddCityController = segue.destination as! AddCityController
            addCity.cityDelegate = self
        } else if segue.identifier == "segueToDetail" {
            
            let indexPath = sender as! IndexPath
            
            let detail: DetailController = segue.destination as! DetailController
            
            detail.currentCityTitle = cityNameArray[indexPath.row]
            detail.cityId = cityIdArray[indexPath.row]
        }
    }
}

//MARK: - Add City Delegate

extension MainViewController: AddCityDelegate {
    
    func updateCityList() {
        loadData()
    }
}

//MARK: - Load Data

extension MainViewController {
    
    func loadApi() {
        
        self.view.addSubview(preloadView)
        
        let realm = try! Realm()
        
        let city = realm.objects(CityGroup.self)
        
        let cityIdArray = city.value(forKey: "id") as! [Int]
        
        DataRequest.getData(dictionaryData: ["idArray" : cityIdArray], dictHttpBody: nil, methodName: MethodName.getGroupById, completionHandler: { (succes, info, errorCode) in
            
            if errorCode == 200 {
                
                self.loadData()
            } else {
                
                let alert = Alert.createAlert(error: errorCode)
                
                self.parent?.present(alert, animated: true, completion: nil)
                
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action: UIAlertAction) in
                    print("press Retry")
                    self.loadApi()
                }))
                
                self.loadData()
            }
        })
    }
    
    func loadData() {
        
        let realm = try! Realm()
        let allCityGroup = realm.objects(CityGroup.self)
        
        cityIdArray = allCityGroup.value(forKey: "id") as! Array
        cityNameArray = allCityGroup.value(forKey: "name") as! Array
        cityIconArray = allCityGroup.value(forKey: "icon") as! Array
        cityTempArray = allCityGroup.value(forKey: "temp") as! Array
        cityHumidityArray = allCityGroup.value(forKey: "humidity") as! Array
        cityWindSpeedArray = allCityGroup.value(forKey: "windSpeed") as! Array
        
        DispatchQueue.main.async {
            self.tableCity?.reloadData()
            self.preloadView.removeFromSuperview()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row == 0 || indexPath.row == 1 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            let realm = try! Realm()
            
            try! realm.write {
                
                let deleteGroup = realm.objects(CityGroup.self).filter("id == %@", cityIdArray[indexPath.row])
                realm.delete(deleteGroup)
            }
            
            cityIdArray.remove(at: indexPath.row)
            cityNameArray.remove(at: indexPath.row)
            cityIconArray.remove(at: indexPath.row)
            cityTempArray.remove(at: indexPath.row)
            cityHumidityArray.remove(at: indexPath.row)
            cityWindSpeedArray.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

//MARK: - Table Delegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: "segueToDetail", sender: indexPath)
    }
}

