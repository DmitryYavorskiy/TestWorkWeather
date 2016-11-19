//
//  DetailController.swift
//  Weather
//
//  Created by Dmitriy Yavorskiy on 17.11.16.
//  Copyright © 2016 Dmitriy Yavorskiy. All rights reserved.
//

import UIKit
import RealmSwift

class DetailController: UIViewController {
    
    @IBOutlet var tableDayCollection: UICollectionView?
    @IBOutlet var segment: UISegmentedControl?
    
    @IBOutlet var mainTitle: UILabel?
    @IBOutlet var dayWeekTitle: UILabel?
    @IBOutlet var mainImage: UIImageView?
    @IBOutlet var tempDataText: UILabel?
    
    var currentCityTitle = String()
    var cityId = Int()
    var currentIndex = -1
    
    var dayWeekArray = Array<String>()
    var minTempArray = Array<Int>()
    var maxTempArray = Array<Int>()
    var iconNameArray = Array<String>()
    var backArray = Array<UIColor>()
    var dayTempArray = Array<Int>()
    var nightTempArray = Array<Int>()
    var eveTempArray = Array<Int>()
    var mornTempArray = Array<Int>()
    var pressureArray = Array<Double>()
    var humidityArray = Array<Int>()
    var speedWindArray = Array<Double>()
    
    let selectColor = UIColor.clear
    let deselectColor = UIColor(red: 69/255, green: 68/255, blue: 65/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        /*DataRequest.getData(dictionaryData: ["id" : cityId], dictHttpBody: nil, methodName: MethodName.getDaysWeather, completionHandler: { (succes, info, errorCode) in
            self.loadData(id: self.cityId)
        })*/
        mainTitle?.text = currentCityTitle
        
        changeDayCount(segment!)
        
    }
    
    @IBAction func changeDayCount(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            loadData(id: cityId, index: 3)
        } else {
            loadData(id: cityId, index: 7)
        }
    }
    
}

//MARK: - Load Data

extension DetailController {
    
    func loadData(id: Int, index: Int) {
        
        dayWeekArray = Array<String>()
        minTempArray = Array<Int>()
        maxTempArray = Array<Int>()
        iconNameArray = Array<String>()
        backArray = Array<UIColor>()
        dayTempArray = Array<Int>()
        nightTempArray = Array<Int>()
        eveTempArray = Array<Int>()
        mornTempArray = Array<Int>()
        pressureArray = Array<Double>()
        humidityArray = Array<Int>()
        speedWindArray = Array<Double>()
        
        let realm = try! Realm()
        let allGroup = realm.objects(CityWeather.self).filter("id == \(id)")
        
        let weatherArray = allGroup.value(forKey: "list.dt") as! [[String]]
        let minArray = allGroup.value(forKey: "list.minTemp") as! [[Int]]
        let maxArray = allGroup.value(forKey: "list.maxTemp") as! [[Int]]
        let iconArray = allGroup.value(forKey: "list.icon") as! [[String]]
        let dayArray = allGroup.value(forKey: "list.dayTemp") as! [[Int]]
        let nightArray = allGroup.value(forKey: "list.nightTemp") as! [[Int]]
        let eveArray = allGroup.value(forKey: "list.eveTemp") as! [[Int]]
        let mornArray = allGroup.value(forKey: "list.mornTemp") as! [[Int]]
        let pressure = allGroup.value(forKey: "list.pressure") as! [[Double]]
        let humidity = allGroup.value(forKey: "list.humidity") as! [[Int]]
        let speedWind = allGroup.value(forKey: "list.speedWind") as! [[Double]]
        
        if weatherArray.count > 0 {
            dayWeekArray.append(contentsOf: weatherArray[0][0..<index])
            minTempArray.append(contentsOf: minArray[0][0..<index])
            maxTempArray.append(contentsOf: maxArray[0][0..<index])
            iconNameArray.append(contentsOf: iconArray[0][0..<index])
            dayTempArray.append(contentsOf: dayArray[0][0..<index])
            nightTempArray.append(contentsOf: nightArray[0][0..<index])
            eveTempArray.append(contentsOf: eveArray[0][0..<index])
            mornTempArray.append(contentsOf: mornArray[0][0..<index])
            pressureArray.append(contentsOf: pressure[0][0..<index])
            humidityArray.append(contentsOf: humidity[0][0..<index])
            speedWindArray.append(contentsOf: speedWind[0][0..<index])
            //print(dayWeekArray)
            for _ in 0..<dayWeekArray.count {
                backArray.append(deselectColor)
            }
            
            backArray[0] = selectColor
            
            DispatchQueue.main.async {
                
                self.attributedTextCreate(index: 0)
                self.tableDayCollection?.reloadData()
                self.tableDayCollection?.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
            }
        }
    }
}

//MARK: - Attributed Text

extension DetailController {
    
    func attributedTextCreate(index: Int) {
        
        self.dayWeekTitle?.text = self.dayWeekArray[index]
        self.mainImage?.image = UIImage(named: "\(self.iconNameArray[index])")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        let attrString = NSMutableAttributedString(string: "Day temperature: \(self.dayTempArray[index])°C\nMin temperature: \(self.minTempArray[index])°C\nMax temperature: \(self.maxTempArray[index])°C\nNight temperature: \(self.nightTempArray[index])°C\nEvening temperature: \(self.eveTempArray[index])°C\nMorning temperature: \(self.mornTempArray[index])°C\nPressure: \(self.pressureArray[index]) hpa\nHumidity: \(self.humidityArray[index])%\nWind speed: \(self.speedWindArray[index]) meter/sec")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        self.tempDataText?.attributedText = attrString
    }
}

//MARK: - CollectionView Data Source

extension DetailController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayWeekArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCellid", for: indexPath) as! CollectionViewCell
        
        cell.titleText?.text = dayWeekArray[indexPath.row]
        cell.subTitleText?.text = "\(minTempArray[indexPath.row])...\(maxTempArray[indexPath.row])"
        cell.iconImage?.image = UIImage(named: iconNameArray[indexPath.row])
        cell.backgroundColor = backArray[indexPath.row]
        
        return cell
    }
}

//MARK: - CollectionView Delegate

extension DetailController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        backArray[indexPath.row] = selectColor
        if currentIndex != -1 {
            backArray[currentIndex] = deselectColor
        }
        
        DispatchQueue.main.async {
            
            self.attributedTextCreate(index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        currentIndex = indexPath.row
        
        tableDayCollection?.reloadData()
    }
}
