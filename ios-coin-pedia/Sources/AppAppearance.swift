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
    static let lightGray = UIColor.appLightGray
    static let blue = UIColor.appBlue
    static let red = UIColor.appRed
    static let white = UIColor.white
    static let black = UIColor.black
}

enum AppFont {
    static let logo = UIFont.italicSystemFont(ofSize: 28)
    static let title1 = UIFont.systemFont(ofSize: 16, weight: .bold)
    static let title2 = UIFont.systemFont(ofSize: 14, weight: .bold)
    static let title3 = UIFont.systemFont(ofSize: 13, weight: .bold)
    static let text1 = UIFont.systemFont(ofSize: 12, weight: .bold)
    static let text2 = UIFont.systemFont(ofSize: 12)
    static let subText1 = UIFont.systemFont(ofSize: 10, weight: .bold)
    static let subText2 = UIFont.systemFont(ofSize: 9, weight: .bold)
    static let subText3 = UIFont.systemFont(ofSize: 9)
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
        let appearanceTB = UITabBarAppearance()
        appearanceTB.configureWithTransparentBackground()
        appearanceTB.shadowColor = AppColor.lightNavy
        appearanceTB.backgroundColor = AppColor.white
        UITabBar.appearance().tintColor = AppColor.navy
        UITabBar.appearance().standardAppearance = appearanceTB
        UITabBar.appearance().scrollEdgeAppearance = appearanceTB
        
        let appearanceTBI = UITabBarItemAppearance()
        let titleAttributesTBI = [NSAttributedString.Key.font: AppFont.subText1]
        appearanceTBI.normal.titleTextAttributes = titleAttributesTBI
        appearanceTBI.selected.titleTextAttributes = titleAttributesTBI
        appearanceTB.stackedLayoutAppearance = appearanceTBI
        
        let appearanceNB = UINavigationBarAppearance()
        let titleAttributesNB = [
            NSAttributedString.Key.foregroundColor: AppColor.navy,
            NSAttributedString.Key.font: AppFont.title1
        ]
        let backButtonImage = UIImage(systemName: AppIcon.arrowLeft)
        appearanceNB.configureWithTransparentBackground()
        appearanceNB.titlePositionAdjustment = UIOffset(horizontal: -CGFloat.greatestFiniteMagnitude, vertical: 0)
        appearanceNB.shadowColor = AppColor.lightNavy
        appearanceNB.backgroundColor = AppColor.white
        appearanceNB.titleTextAttributes = titleAttributesNB
        appearanceNB.largeTitleTextAttributes = titleAttributesNB
        appearanceNB.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        UINavigationBar.appearance().standardAppearance = appearanceNB
        UINavigationBar.appearance().scrollEdgeAppearance = appearanceNB
        UINavigationBar.appearance().compactAppearance = appearanceNB
        
        BaseView.appearance().backgroundColor = AppColor.white
        
        UITextField.appearance().tintColor = AppColor.navy
        UITextField.appearance().textColor = AppColor.navy
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.light
        
        UISearchBar.appearance().barTintColor = AppColor.white
        UISearchTextField.appearance().tintColor = AppColor.navy
        UISearchTextField.appearance().backgroundColor = AppColor.white
        UISearchBar.appearance().keyboardAppearance = UIKeyboardAppearance.light
        
        UITableView.appearance().backgroundColor = AppColor.white
        UITableView.appearance().separatorColor = AppColor.white
        UITableView.appearance().indicatorStyle = .black
        UITableViewCell.appearance().backgroundColor = AppColor.white
        UITableViewCell.appearance().selectionStyle = .none
        
        UICollectionView.appearance().backgroundColor = AppColor.white
        UICollectionViewCell.appearance().backgroundColor = AppColor.white
    }
    
}
