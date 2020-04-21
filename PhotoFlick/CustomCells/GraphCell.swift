//
//  GraphCell.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 21/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit
import AAInfographics

class GraphCell: UITableViewCell {

    var chartView = AAChartView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureChart()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureChart() {
        
        let chartViewWidth  = self.frame.size.width - 50
        let chartViewHeight = self.frame.size.height
        chartView.frame = CGRect(x:0,y:25,width:chartViewWidth,height:chartViewHeight-25)
        self.addSubview(chartView)
        
        let aaChartModel = AAChartModel()
                   .chartType(.bubble)//Can be any of the chart types listed under `AAChartType`.
                   .animationType(.bounce)
                   .title("")//The chart title
                   //.subtitle("subtitle")//The chart subtitle
                   //.dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
                   .tooltipValueSuffix("USD")//the value suffix of the chart tooltip
                   .categories(["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])
                   .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
                   .series([
                       AASeriesElement()
                           .name("Tokyo")
                           .data([7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]),
                       AASeriesElement()
                           .name("New York")
                           .data([0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]),
                       AASeriesElement()
                           .name("Berlin")
                           .data([0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]),
                       AASeriesElement()
                           .name("London")
                           .data([3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]),
                           ])
        chartView.aa_drawChartWithChartModel(aaChartModel)
    }
    
}
