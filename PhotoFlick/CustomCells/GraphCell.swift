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

    @IBOutlet weak var chartBgView: UIView!
    var chartView = AAChartView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureChart(dateArray: [String], favsArray: [String]?) {
        let chartFrame = chartBgView.frame
        if dateArray.count == 0 {
            let noDataLbl = UILabel(frame: chartFrame)
            noDataLbl.text = "no_fav_msg".localized()
            noDataLbl.textColor = .systemPink
            noDataLbl.textAlignment = .center
            noDataLbl.font = UIFont.systemFont(ofSize: CGFloat(AppConstants.NumericConstants.leftMenuFontSize))
            chartBgView.addSubview(noDataLbl)
            return
        }
        chartView.frame = chartFrame
        chartBgView.addSubview(chartView)
        addConstraints(to: chartView)
        guard let doubles = favsArray?.compactMap(Double.init) else { return }
        let aaChartModel = AAChartModel()
            .chartType(.bubble)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bounce)
            .title("")
            .dataLabelsEnabled(true) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("Likes")//the value suffix of the chart tooltip
            .categories(dateArray)
            .yAxisTitle("y_axis_title".localized())
            .yAxisMin(0.0)
            .colorsTheme([AppConstants.GeneralConstants.graphColor])
            .series([
            AASeriesElement()
                .name("x_axis_title".localized())
                .data(doubles)
            ])
        chartView.aa_drawChartWithChartModel(aaChartModel)
    }
    
}
