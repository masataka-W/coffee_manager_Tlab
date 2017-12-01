//
//  roulette2.swift
//  coffee_management
//
//  Created by Masataka W. on 2017/11/30.
//  Copyright © 2017年 Masataka W. All rights reserved.
//円グラフ表示したいけどできてない

import Foundation
import UIKit
import Charts

class roulette2: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//    private func setupPieChartView() {
//        self.pieChartView.usePercentValuesEnabled = true
//        self.pieChartView.descriptionText = "チャートの説明"
//
//        // 円グラフに表示するデータ
//        var dataEntries = [ChartDataEntry]()
//        for index in (1...4).reversed() {
//            dataEntries.append(ChartDataEntry(x: Double(index) * 10.0, y: Double(index)))
//        }
//        let dataSet = PieChartDataSet(values: dataEntries, label: "チャートのラベル")
//        dataSet.colors = ChartColorTemplates.colorful()
//        let data = ChartData(xVals: ["A", "B", "C", "D"], dataSet: dataSet)
//
//        // %表示
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = NumberFormatter.Style.percent;
//        numberFormatter.maximumFractionDigits = 1;
//        numberFormatter.multiplier = NSNumber(value: 1)
//        numberFormatter.percentSymbol = " %";
//        data.setValueFormatter(numberFormatter)
//
//        self.pieChartView.data = data
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
