//
//  TabBarController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit

private enum TabBar: String, CaseIterable {
    case trending
    case ticker
    case user
    
    var vc: UIViewController.Type {
        switch self {
        case .ticker:
            return TickerViewController.self
        case .trending:
            return TrendingViewController.self
        case .user:
            return UserViewController.self
        }
    }
    
    var navigationTitle: String {
        switch self {
        case .ticker:
            return "거래소"
        case .trending:
            return "가상자산 / 심볼 검색"
        case .user:
            return "포트폴리오"
        }
    }
    
    var title: String {
        switch self {
        case .ticker:
            return "거래소"
        case .trending:
            return "코인정보"
        case .user:
            return "포트폴리오"
        }
    }
    
    var icon: String {
        switch self {
        case .ticker:
            return AppIcon.ticker.value
        case .trending:
            return AppIcon.trending.value
        case .user:
            return AppIcon.star.value
        }
    }
}

class TabBarController: UITabBarController {
    
    //MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTBC()
    }
    
    //MARK: - Setup Method
    private func setupTBC() {
        view.backgroundColor = UIColor.white
        view.tintColor = UIColor.black
        
        let tabs = TabBar.allCases
        var navs = [UINavigationController]()
        
        for item in tabs {
            navs.append(makeNav(item))
        }
        
        setViewControllers(navs, animated: true)
    }
    
    //MARK: - Method
    private func makeNav(_ tab: TabBar) -> UINavigationController {
        let vc = tab.vc.init()
        let nav = UINavigationController(rootViewController: vc)
        vc.navigationItem.title = tab.navigationTitle
        nav.tabBarItem.image = UIImage(
            systemName: tab.icon,
            withConfiguration: UIImage.SymbolConfiguration(
                font: .systemFont(ofSize: 16, weight: .bold)
            )
        )
        nav.tabBarItem.title = tab.title
        return nav
    }
    
}
