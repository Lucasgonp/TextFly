//
//  LoginViewController.swift
//  TextFly
//
//  Created by Lucas Pereira on 18/01/21.
//

import UIKit

class LoginViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginButtonView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    
    let inputName = InputField(text: "E-mail", placeholder: "E-mail")
    let inputSenha = InputField(text: "Senha", placeholder: "Senha")
    var inputs: [InputField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initColor()
        self.initTableView()
    }
    
    private func initColor() {
        self.view.backgroundColor = Color.solitude
        self.footerView.backgroundColor = Color.solitude
        self.navigationController?.navigationBar.barTintColor = Color.solitude
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "LoginInputCell", bundle: nil), forCellReuseIdentifier: "LoginInputCell")
        
        self.tableView.layer.cornerRadius = 12
        self.loginButton.layer.cornerRadius = 12
        
        self.loadTableView()
    }
    
    private func loadTableView() {
        self.inputs = [inputName, inputSenha]
        self.tableView.reloadData()
        tableViewHeight.constant = CGFloat(self.inputs.count * 48)
    }
    
    @IBAction func openRegister(_ sender: Any) {
        let controller = RegisterViewController()
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inputs.count
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
