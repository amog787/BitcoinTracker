//
//  ViewController.swift
//  BitcoinPriceTracker
//
//  Created by ADG RIT 13 on 31/03/19.
//  Copyright © 2019 amog787. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController, ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        //
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        //
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        //
    }
    

    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var label: UILabel!
    @IBAction func button(_ sender: Any) {
        getPrice()
        
    }
    
    var arrayUSD: [Double] = [4000.00]
    var arrayINR: [Double] = [286000]
    
    struct Prices: Decodable{
        let bpi: [String: Bpi]
    
    }
    
    struct Bpi: Decodable{
        let code: String?
        let rate_float: Double?
    }
    
    func updateChart(usdValue: Double){
        if arrayUSD.count > 20 {
            arrayUSD.remove(at: 0)
        }
        
        arrayUSD.append(usdValue)
        let series = ChartSeries(arrayUSD)
        chart.removeAllSeries()
        chart.add(series)
    }
    
    func updateChartI(usdValue: Double){
        if arrayINR.count > 20 {
            arrayINR.remove(at: 0)
        }
        
        arrayINR.append(usdValue)
        let series = ChartSeries(arrayINR)
        chart.removeAllSeries()
        chart.add(series)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPrice()
        chart.delegate = self
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(getPrice), userInfo: nil, repeats: true)
    }
    
    @objc func getPrice(){
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/INR.json")
        URLSession.shared.dataTask(with: url!){ (data,response, error) in
            if error != nil{
                print(error!.localizedDescription)
            }
            
            if let data = data{
                let price = try? JSONDecoder().decode(Prices.self, from: data)
                let bpi = price?.bpi
                //let code = bpi!["USD"]!.code
                let rateU = bpi!["USD"]!.rate_float!
                let rateI = bpi!["INR"]!.rate_float!
                DispatchQueue.main.async {
                    if self.segmentControl.selectedSegmentIndex == 0 {
                        self.label.text = "$\(rateU)"
                        self.updateChart(usdValue: rateU)
                    }
                    else {
                        self.label.text = "₹\(rateI)"
                        self.updateChartI(usdValue: rateI)
                    }
                }
            }
            
        }.resume()
    }


}

