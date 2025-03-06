//
//  BaseViewModel.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
