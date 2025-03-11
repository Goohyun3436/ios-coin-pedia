//
//  DetailView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import SwiftUI
import SnapKit

final class DetailView: BaseView {
    
    //MARK: - UI Property
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let coinThumbnailView = CoinThumbnailView()
    let favoriteButton = FavoriteButton()
    let priceLabel = AppLabel(.largeTitle)
    let volatilityView = VolatilityIconView()
    let chartView: UIView = {
        let hosting = UIHostingController(rootView: PriceChartView())
        guard let view = hosting.view else { return UIView() }
        return view
    }()
    let updateTimeLabel = AppLabel(.subText3, .lightNavy)
    let infoHeader = SectionHeaderView(.button)
    let infoView = DetailInfoView()
    let analyzeHeader = SectionHeaderView(.button)
    let analyzeView = DetailAnalyzeView()
    
    //MARK: - Setup Method
    override func setupUI() {
        [priceLabel, volatilityView, chartView, updateTimeLabel, infoHeader, infoView, analyzeHeader, analyzeView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        addSubview(scrollView)
    }
    
    override func setupConstraints() {
        let marginV: CGFloat = 24
        let marginH: CGFloat = 16
        let textMargin: CGFloat = 4
        let chartHeight: CGFloat = 200
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(marginV)
            make.leading.equalToSuperview().offset(marginH)
            make.trailing.lessThanOrEqualToSuperview().offset(-marginH)
        }
        
        volatilityView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(textMargin)
            make.leading.equalTo(safeAreaLayoutGuide).offset(marginH)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(volatilityView.snp.bottom).offset(marginV)
            make.horizontalEdges.equalToSuperview().inset(marginH)
            make.height.equalTo(chartHeight)
        }
        
        updateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(textMargin)
            make.leading.equalToSuperview().offset(marginH)
        }
        
        infoHeader.snp.makeConstraints { make in
            make.top.equalTo(updateTimeLabel.snp.bottom).offset(marginV)
            make.horizontalEdges.equalToSuperview()
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(infoHeader.snp.bottom).offset(marginV)
            make.horizontalEdges.equalToSuperview().inset(marginH)
        }
        
        analyzeHeader.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(marginV)
            make.horizontalEdges.equalToSuperview()
        }
        
        analyzeView.snp.makeConstraints { make in
            make.top.equalTo(analyzeHeader.snp.bottom).offset(marginV)
            make.horizontalEdges.equalToSuperview().inset(marginH)
            make.bottom.equalToSuperview().inset(marginV)
        }
    }
    
}
