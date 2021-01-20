//
//  ActivityTracker.swift
//  TextFly
//
//  Created by Lucas Pereira on 19/01/21.
//

import Foundation
import RxCocoa
import RxSwift

final class ActivityTracker: SharedSequenceConvertibleType {
    
    typealias O = ObservableConvertibleType
    typealias Element = Bool
    typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _variable = BehaviorRelay(value: false)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    init() {
        _loading = _variable.asDriver()
            .distinctUntilChanged()
    }
    
    func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }
    
    private func subscribed() {
        _lock.lock()
        _variable.accept(true)
        _lock.unlock()
    }
    
    private func sendStopLoading() {
        _lock.lock()
        _variable.accept(false)
        _lock.unlock()
    }
    
    func asSharedSequence() -> SharedSequence<DriverSharingStrategy, ActivityTracker.Element> {
        return _loading
    }
}
