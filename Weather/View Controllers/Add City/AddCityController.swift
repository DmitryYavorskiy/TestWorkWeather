//
//  AddCityController.swift
//  Weather
//
//  Created by Dmitriy Yavorskiy on 16.11.16.
//  Copyright © 2016 Dmitriy Yavorskiy. All rights reserved.
//

import UIKit

class AddCityController: UIViewController {
    
    @IBOutlet var tableAddCity: UITableView?
    
    weak var cityDelegate: AddCityDelegate?
    var titlesArray = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Cancel Add Action

    @IBAction func cancelAddAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Add City Delegate protocol

protocol AddCityDelegate: NSObjectProtocol {
    
    func updateCityList()
}

//MARK: - Search Bar Delegate

extension AddCityController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print("searchText \(searchText)")
        
        DataRequest.getData(dictionaryData: ["input" : searchText], dictHttpBody: nil, methodName: MethodName.getPalceAutocomplete, completionHandler:{ (succes, info, errorCode) in
            
            self.titlesArray = info.value(forKey: "cityName") as! Array
            
            DispatchQueue.main.async {
                self.tableAddCity?.reloadData()
            }
        })
    }
}

//MARK: - Table Data Source

extension AddCityController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "addCellId", for: indexPath) as! CustomCell
        
        cell.titleText?.text = titlesArray[indexPath.row]
        
        return cell
    }
}

//MARK: - Table Delegate

extension AddCityController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let currentCity = titlesArray[indexPath.row]
        
        DataRequest.getData(dictionaryData: ["city" : currentCity], dictHttpBody: nil, methodName: MethodName.getPalceByName, completionHandler: { (succes, info, errorCode) in
            
            if self.cityDelegate != nil {
                self.cityDelegate!.updateCityList()
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
}
