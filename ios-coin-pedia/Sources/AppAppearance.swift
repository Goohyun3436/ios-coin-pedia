//
//  AppAppearance.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit

enum AppColor {
    static let navy = UIColor.appNavy
    static let lightNavy = UIColor.appLightNavy
    static let white = UIColor.appWhite
    static let blue = UIColor.appBlue
    static let red = UIColor.appRed
}

enum AppFont {
    static let logo = UIFont.italicSystemFont(ofSize: 28)
    static let title1 = UIFont.systemFont(ofSize: 16, weight: .bold)
    static let title2 = UIFont.systemFont(ofSize: 14, weight: .bold)
    static let title3 = UIFont.systemFont(ofSize: 13, weight: .bold)
    static let text1 = UIFont.systemFont(ofSize: 12, weight: .bold)
    static let text2 = UIFont.systemFont(ofSize: 12)
    static let subText1 = UIFont.systemFont(ofSize: 9, weight: .bold)
    static let subText2 = UIFont.systemFont(ofSize: 9)
}

enum AppIcon {
    static let arrowUp = "arrowtriangle.up.fill"
    static let arrowDown = "arrowtriangle.down.fill"
    static let search = "magnifyingglass"
    static let star = "star"
    static let starFill = "star.fill"
    static let chevronRight = "chevron.right"
    static let arrowLeft = "arrow.left"
    static let ticker = "chart.line.uptrend.xyaxis"
    static let trending = "chart.bar.fill"
}

enum AppImageSize {
    static let large = CGSize(width: 72, height: 72)
    static let small = CGSize(width: 36, height: 36)
    static let thumb = CGSize(width: 26, height: 26)
}

final class AppAppearance {
    
    static func setup() {

    }
    
}
