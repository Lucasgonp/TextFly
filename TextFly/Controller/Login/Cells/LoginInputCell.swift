//
//  LoginInputCell.swift
//  TextFly
//
//  Created by Lucas Pereira on 18/01/21.
//

import UIKit

class LoginInputCell: UITableViewCell {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var separatorInsetView: UIView!
    
    var textIn: String?
    var titleText: String = ""
    var placeholder: String = ""
    var separator: Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.initInput()
        self.setKeyboardType()
    }
    
    func initInput() {
        self.titleTextLabel.isHidden = true
        
        self.titleTextLabel.text = titleText
        self.inputTextField.placeholder = placeholder
        
        if !separator {
            self.separatorInsetView.isHidden = true
        }
    }
    
    func setKeyboardType() {
        if self.titleText == "E-mail" {
            self.inputTextField.textContentType = .emailAddress
            self.inputTextField.keyboardType = .emailAddress
        }
        
        if self.titleText == "Senha" {
            self.inputTextField.isSecureTextEntry = true
            self.inputTextField.textContentType = .password
        }
    }
    
    @IBAction func editingBegin(_ sender: Any) {
        self.titleTextLabel.isHidden = false
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        
    }
    
    
    @IBAction func editingDidEnd(_ sender: Any) {
        if let text = inputTextField.text, text == "" {
        self.titleTextLabel.isHidden = true
        }
    }
    
}
