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
    @IBOutlet var searchBar: UISearchBar?
    
    weak var cityDelegate: AddCityDelegate?
    var titlesArray = Array<String>()
    
    var preloadView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        preloadView = PreloaderView.preloaderView(view: self.view, indicator: true)
        
        searchBar?.becomeFirstResponder()
        let textFieldInsideSearchBar = searchBar?.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(red: 255/255, green: 128/255, blue: 24/255, alpha: 1)
    }
    
    //MARK: - Cancel Add Action

    @IBAction func cancelAddAction(_ sender: UIButton) {
        self.view.endEditing(true)
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
            
            if errorCode == 200 {
                
                self.titlesArray = info?.value(forKey: "cityName") as! Array
                
                DispatchQueue.main.async {
                    self.tableAddCity?.reloadData()
                }
            } else {
                self.titlesArray = ["Error connecting to the Internet"]
                DispatchQueue.main.async {
                    self.tableAddCity?.reloadData()
                }
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
        self.view.addSubview(preloadView)
        self.view.endEditing(true)
        DataRequest.getData(dictionaryData: ["city" : currentCity], dictHttpBody: nil, methodName: MethodName.getPalceByName, completionHandler: { (succes, info, errorCode) in
            
            if self.cityDelegate != nil {
                self.cityDelegate!.updateCityList()
            }
            DispatchQueue.main.async {
                self.preloadView.removeFromSuperview()
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
}
