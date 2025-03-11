//
//  PriceChartView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/11/25.
//

import SwiftUI
import Charts

struct PriceChartView: View {
    @State private var yMin: Double = 0
    @State private var yMax: Double = 0
    let data: [CoinChartData]
    
    init() {
        let prices = mockCoinDetail.sparklineIn7d.price
        let startDate = Date().addingTimeInterval(-Double(prices.count) * 3600)
        data = prices.enumerated().map {
            CoinChartData(
                time: startDate.addingTimeInterval(Double($0) * 3600),
                price: $1
            )
        }
        if let yMin = prices.min(), let yMax = prices.max() {
            _yMin = State(initialValue: yMin * 0.98)
            _yMax = State(initialValue: yMax)
        }
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
