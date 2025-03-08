//
//  AppAppearance.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
    
enum AppColor {
    case navy
    case lightNavy
    case lightGray
    case blue
    case red
    case overlay
    case white
    case black
    
    var value: UIColor {
        switch self {
        case .navy:
            return UIColor.appNavy
        case .lightNavy:
            return UIColor.appLightNavy
        case .lightGray:
            return UIColor.appLightGray
        case .blue:
            return UIColor.appBlue
        case .red:
            return UIColor.appRed
        case .overlay:
            return UIColor.appOverlay
        case .white:
            return UIColor.white
        case .black:
            return UIColor.black
        }
    }
}

enum AppFont {
    case logo
    case title1
    case title2
    case title3
    case text1
    case text2
    case subText1
    case subText2
    case subText3
    
    var value: UIFont {
        switch self {
        case .logo:
            return UIFont.italicSystemFont(ofSize: 28)
        case .title1:
            return UIFont.systemFont(ofSize: 16, weight: .bold)
        case .title2:
            return UIFont.systemFont(ofSize: 14, weight: .bold)
        case .title3:
            return UIFont.systemFont(ofSize: 13, weight: .bold)
        case .text1:
            return UIFont.systemFont(ofSize: 12, weight: .bold)
        case .text2:
            return UIFont.systemFont(ofSize: 12)
        case .subText1:
            return UIFont.systemFont(ofSize: 10, weight: .bold)
        case .subText2:
            return UIFont.systemFont(ofSize: 9, weight: .bold)
        case .subText3:
            return UIFont.systemFont(ofSize: 9)
        }
    }
}

enum AppIcon {
    case arrowUp
    case arrowDown
    case search
    case star
    case starFill
    case chevronRight
    case arrowLeft
    case ticker
    case trending
    
    var value: String {
        switch self {
        case .arrowUp:
            return "arrowtriangle.up.fill"
        case .arrowDown:
            return "arrowtriangle.down.fill"
        case .search:
            return"magnifyingglass"
        case .star:
            return "star"
        case .starFill:
            return "star.fill"
        case .chevronRight:
            return "chevron.right"
        case .arrowLeft:
            return "arrow.left"
        case .ticker:
            return "chart.line.uptrend.xyaxis"
        case .trending:
            return "chart.bar.fill"
        }
    }
}

enum AppImageSize {
    case large
    case small
    case thumb
    
    var value: CGSize {
        switch self {
        case .large:
            return CGSize(width: 72, height: 72)
        case .small:
            return CGSize(width: 36, height: 36)
        case .thumb:
            return CGSize(width: 26, height: 26)
        }
    }
}

final class AppAppearance {
    
    static func setup() {
        let appearanceTB = UITabBarAppearance()
        appearanceTB.configureWithTransparentBackground()
        appearanceTB.shadowColor = AppColor.lightNavy.value
        appearanceTB.backgroundColor = AppColor.white.value
        UITabBar.appearance().tintColor = AppColor.navy.value
        UITabBar.appearance().standardAppearance = appearanceTB
        UITabBar.appearance().scrollEdgeAppearance = appearanceTB
        
        let appearanceTBI = UITabBarItemAppearance()
        let titleAttributesTBI = [NSAttributedString.Key.font: AppFont.subText1.value]
        appearanceTBI.normal.titleTextAttributes = titleAttributesTBI
        appearanceTBI.selected.titleTextAttributes = titleAttributesTBI
        appearanceTB.stackedLayoutAppearance = appearanceTBI
        
        let appearanceNB = UINavigationBarAppearance()
        let titleAttributesNB = [
            NSAttributedString.Key.foregroundColor: AppColor.navy.value,
            NSAttributedString.Key.font: AppFont.title1.value
        ]
        let backButtonImage = UIImage(systemName: AppIcon.arrowLeft.value)
        appearanceNB.configureWithTransparentBackground()
        appearanceNB.titlePositionAdjustment = UIOffset(horizontal: -CGFloat.greatestFiniteMagnitude, vertical: 0)
        appearanceNB.shadowColor = AppColor.lightNavy.value
        appearanceNB.backgroundColor = AppColor.white.value
        appearanceNB.titleTextAttributes = titleAttributesNB
        appearanceNB.largeTitleTextAttributes = titleAttributesNB
        appearanceNB.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        UINavigationBar.appearance().standardAppearance = appearanceNB
        UINavigationBar.appearance().scrollEdgeAppearance = appearanceNB
        UINavigationBar.appearance().compactAppearance = appearanceNB
        
        BaseView.appearance().backgroundColor = AppColor.white.value
        
        UITextField.appearance().tintColor = AppColor.navy.value
        UITextField.appearance().textColor = AppColor.navy.value
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.light
        
        UISearchBar.appearance().barTintColor = AppColor.white.value
        UISearchTextField.appearance().tintColor = AppColor.navy.value
        UISearchTextField.appearance().backgroundColor = AppColor.white.value
        UISearchBar.appearance().keyboardAppearance = UIKeyboardAppearance.light
        
        UITableView.appearance().backgroundColor = AppColor.white.value
        UITableView.appearance().separatorColor = AppColor.white.value
        UITableView.appearance().indicatorStyle = .black
        UITableViewCell.appearance().backgroundColor = AppColor.white.value
        UITableViewCell.appearance().selectionStyle = .none
        
        UICollectionView.appearance().backgroundColor = AppColor.white.value
        UICollectionViewCell.appearance().backgroundColor = AppColor.white.value
    }
    
}
