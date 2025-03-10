//
//  BorderBottomSegmentControl.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/10/25.
//

import UIKit

final class BorderBottomSegmentControl: UISegmentedControl {
    
    override var selectedSegmentIndex: Int {
        didSet {
            changeUnderlinePosition()
        }
    }
    
    private var borderBottom: UIView?

    init() {
        super.init(frame: .zero)
        setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        selectedSegmentTintColor = AppColor.clear.value
        setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: AppColor.lightNavy.value,
            NSAttributedString.Key.font: AppFont.title2.value
        ], for: .normal)
        setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: AppColor.lightNavy.value,
            NSAttributedString.Key.font: AppFont.title2.value
        ], for: .highlighted)
        setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: AppColor.navy.value,
            NSAttributedString.Key.font: AppFont.title2.value
        ], for: .selected)
    }
    
    override func draw(_ rect: CGRect) {
        let baselineWidth: CGFloat = rect.width
        let baselineHeight: CGFloat = 1
        let baselineXPosition: CGFloat = 0
        let baseLineYPosition: CGFloat = rect.height - baselineHeight
        let baselineFrame = CGRect(x: baselineXPosition, y: baseLineYPosition, width: baselineWidth, height: baselineHeight)
        let baseline = UIView(frame: baselineFrame)
        baseline.backgroundColor = AppColor.lightNavy.value
        addSubview(baseline)
        
        let underlineWidth: CGFloat = rect.width / CGFloat(numberOfSegments)
        let underlineHeight: CGFloat = 2
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = rect.height - underlineHeight
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = AppColor.navy.value
        underline.tag = 1
        addSubview(underline)
    }
    
    func setSegment(titles: [String]) {
        titles.enumerated().forEach {
            insertSegment(withTitle: $1, at: $0, animated: false)
        }
    }
    
    private func changeUnderlinePosition() {
        guard let underline = viewWithTag(1) else { return }
        let underlineFinalXPosition = (bounds.width / CGFloat(numberOfSegments)) * CGFloat(selectedSegmentIndex)
        
        UIView.animate(withDuration: 0.3) {
            underline.frame.origin.x = underlineFinalXPosition
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
