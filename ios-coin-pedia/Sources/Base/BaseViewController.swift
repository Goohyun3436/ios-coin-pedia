//
//  BaseViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

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

//MARK: - Method
extension BaseViewController {
    
    func pushVC(_ vc: BaseViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func presentVC(_ vc: BaseViewController) {
        present(vc, animated: true)
    }
    
    func dismissVC() {
        dismiss(animated: true)
    }
    
    func presentToast(_ type: ToastType) {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var tbc = keyWindow?.rootViewController {
            while let presentedViewController = tbc.presentedViewController {
                tbc = presentedViewController
            }
            
            switch type {
            case .network:
                tbc.view.makeToast(type.message, duration: 2.0, position: .bottom)
            case .spinner:
                tbc.view.makeToastActivity(.center)
            }
        }
        
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
