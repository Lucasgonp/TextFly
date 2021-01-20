//
//  BaseViewController.swift
//  TextFly
//
//  Created by Lucas Pereira on 18/01/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModelProtocol: class {
    func bindViewModel()
}

class BaseViewController: UIViewController, ViewModelProtocol {
    
    let disposeBag = DisposeBag()
    let isLoading = BehaviorRelay(value: false)
    var isBind = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isBind {
            self.bindViewModel()
        }
    }
    
    func bindViewModel() {
        isBind = true
        isLoading.asDriver()
            .drive(onNext: { [weak self] isLoading in
                guard let `self` = self else { return }
                if isLoading {
                    // show loading
                } else {
                    // dismiss loading
                }
            }).disposed(by: disposeBag)
    }
    
    func hideKeyboardWhenTappedAround() {
            let tapGesture = UITapGestureRecognizer(target: self,
                             action: #selector(hideKeyboard))
            view.addGestureRecognizer(tapGesture)
        }

        @objc func hideKeyboard() {
            view.endEditing(true)
        }
}
