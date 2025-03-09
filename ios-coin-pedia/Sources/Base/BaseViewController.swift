//
//  BaseViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import RxCocoa
import RxSwift

class BaseViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupUI()
        setupBind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupUI() {
        navigationItem.backButtonTitle = ""
    }
    
    func setupBind() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - BaseViewController LifeCycle + RxSwift
extension Reactive where Base: BaseViewController {
    
    var viewDidLoad: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
      return ControlEvent(events: source)
    }

    var viewWillAppear: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
      return ControlEvent(events: source)
    }
    var viewDidAppear: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { _ in }
      return ControlEvent(events: source)
    }

    var viewWillDisappear: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { _ in }
      return ControlEvent(events: source)
    }
    var viewDidDisappear: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { _ in }
      return ControlEvent(events: source)
    }
    
}
