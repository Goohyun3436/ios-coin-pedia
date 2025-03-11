//
//  PriceChartView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/11/25.
//

import SwiftUI
import Charts

struct PriceChartView: View {
    private var data: [CoinChartData] = []
    private var yMin: Double = 0
    private var yMax: Double = 0
    
    init(_ info: CoinChartInfo) {
        data = info.data
        yMin = info.yMin
        yMax = info.yMax
    }
    
    var body: some View {
        Chart(data) {
            LineMark(
                x: .value("Time", $0.time, unit: .hour),
                y: .value("Price", $0.price)
            )
            .foregroundStyle(.blue)
            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .interpolationMethod(.monotone)
            
            AreaMark(
                x: .value("Time", $0.time, unit: .hour),
                yStart: .value("Min", yMin),
                yEnd: .value("Value", $0.price)
            )
            .foregroundStyle(LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            ))
            .interpolationMethod(.catmullRom)
        }
        .chartXAxis { AxisMarks() { _ in } }
        .chartYAxis { AxisMarks() { _ in } }
        .chartYScale(domain: yMin...yMax)
    }
}
