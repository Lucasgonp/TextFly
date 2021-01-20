//
//  RegisterViewController.swift
//  TextFly
//
//  Created by Lucas Pereira on 18/01/21.
//

import UIKit
import Firebase

class RegisterViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollSubView: UIView!
    
    var textIn: String = ""
    var textInput: String = ""
    var placeholder: String = ""
    
    var viewModel: RegisterViewModel = RegisterViewModel()
    
    let inputName = InputField(text: "Nome", placeholder: "Nome")
    let inputLastName = InputField(text: "Sobrenome", placeholder: "Sobrenome")
    let inputPhone = InputField(text: "Telefone", placeholder: "(00) 00000-0000")
    let inputEmail = InputField(text: "E-mail", placeholder: "E-mail")
    let inputPassword = InputField(text: "Senha", placeholder: "Senha")
    var inputs: [InputField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initColor()
        self.initTableView()
        self.setViews()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        viewModel.output.isLoading
            .drive(isLoading)
            .disposed(by: disposeBag)
        
        
        viewModel.output.onRegisterUser
            .drive(onNext: { [weak self] user in
                guard let `self` = self else { return }
                
            }).disposed(by: disposeBag)
        
        viewModel.output.error
            .drive(onNext: { [weak self] user in
                guard let `self` = self else { return }
                
            }).disposed(by: disposeBag)
    }
    
    private func initColor() {
        self.view.backgroundColor = Color.solitude
        self.footerView.backgroundColor = Color.solitude
        self.scrollSubView.backgroundColor = Color.solitude
    }
    
    private func setViews() {
        self.registerButton.layer.cornerRadius = 12
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "LoginInputCell", bundle: nil), forCellReuseIdentifier: "LoginInputCell")
        
        self.tableView.layer.cornerRadius = 12
        
        self.loadTableView()
    }
    
    private func loadTableView() {
        self.inputs = [inputName, inputLastName, inputPhone, inputEmail, inputPassword]
        self.tableView.reloadData()
        tableViewHeight.constant = CGFloat(self.inputs.count * 48)
    }
    
    
    @IBAction func registerAction(_ sender: Any) {
        guard let cells = self.tableView.cells as? [LoginInputCell] else { return }
        var inputs: [String:Any] = [:]
        for input in cells {
            if let text = input.inputTextField.text {
            inputs[input.sender] = text
            }
        }
        
        self.viewModel.registerUser(inputs: inputs)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.inputs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginInputCell", for: indexPath) as! LoginInputCell
        cell.titleText = self.inputs[indexPath.row].text
        cell.placeholder = self.inputs[indexPath.row].placeholder
        
        if indexPath.row + 1 == self.inputs.count {
            cell.separator = false
        }
        return cell
    }
    
}
