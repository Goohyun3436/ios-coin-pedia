//
//  ModalViewModel.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ModalViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let submitTap: ControlEvent<Void>
        let cancelTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let title: Observable<String>
        let message: Observable<String>
        let submitButtonTitle: Observable<String>
        let cancelButtonTitle: Observable<String>
    }
    
    //MARK: - Private
    private struct Private {
        let info: NetworkModalInfo
        let submitHandler: (() -> Void)?
        let cancelHandler: (() -> Void)?
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    //MARK: - Initializer Method
    init(info: NetworkModalInfo) {
        priv = Private(
            info: info,
            submitHandler: info.submitHandler,
            cancelHandler: info.cancelHandler
        )
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let title = Observable.just(priv.info.title)
        let message = Observable.just(priv.info.message)
        let submitButtonTitle = Observable.just(priv.info.submitButtonTitle)
        let cancelButtonTitle = Observable.just(priv.info.cancelButtonTitle)
        
        input.submitTap
            .bind(with: self, onNext: { owner, _ in
                owner.priv.submitHandler?()
            })
            .disposed(by: priv.disposeBag)
        
        input.cancelTap
            .bind(with: self, onNext: { owner, _ in
                owner.priv.cancelHandler?()
            })
            .disposed(by: priv.disposeBag)
        
        return Output(
            title: title,
            message: message,
            submitButtonTitle: submitButtonTitle,
            cancelButtonTitle: cancelButtonTitle
        )
    }
    
}
