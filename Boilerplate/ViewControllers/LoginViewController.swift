//
//  LoginViewController.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import SVProgressHUD

enum LoginForm {
    case textfield(title: String, textfield: UITextField)
    case loginButton()
}

typealias TitleSectionModel = SectionModel<String, LoginForm>

class LoginViewController: UIViewController,UITableViewDelegate {

   var dataSource:RxTableViewSectionedReloadDataSource<TitleSectionModel>!
   var viewModel:LoginViewModel!
   private let disposeBag = DisposeBag()
   private var tableView: UITableView!
    
   private lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.red
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .disabled)
        loginButton.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
   }()
   
   private lazy var cancelButton: UIBarButtonItem = {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        return cancelButton
    }()
    
    private lazy var emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect.zero
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.autocapitalizationType = .none
        textfield.setBottomBorder()
        return textfield
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect.zero
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.isSecureTextEntry = true
        textfield.setBottomBorder()
        return textfield
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindRx()
    }
    
    func bindRx() {
         dataSource = RxTableViewSectionedReloadDataSource<TitleSectionModel>(
            configureCell: { dataSource, tableView, indexPath, element in
                let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
                let migrate:CGFloat = 10
                switch element {
                case let .textfield(title, textfield):
                    textfield.placeholder = title
                    cell.addSubview(textfield)
                    textfield.topAnchor.constraint(equalTo: cell.topAnchor, constant: migrate).isActive = true
                    textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
                    textfield.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -migrate).isActive = true
                    textfield.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: migrate).isActive = true
                    textfield.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -migrate).isActive = true
                case .loginButton:
                    self.loginButton.frame = CGRect.zero
                    cell.addSubview(self.loginButton)
                    self.loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                    self.loginButton.topAnchor.constraint(equalTo: cell.topAnchor, constant: migrate).isActive = true
                    self.loginButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -migrate).isActive = true
                    self.loginButton.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: migrate).isActive = true
                    self.loginButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -migrate).isActive = true
                }
                return cell
        })
 
        
        let sections = Observable.just([
            TitleSectionModel(model: "Please use Github account to login", items: [
                LoginForm.textfield(title: "ID", textfield: emailTextField),
                LoginForm.textfield(title: "Password", textfield: passwordTextField),
                LoginForm.loginButton()
                ]),
            ])
        
        sections
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        emailTextField.becomeFirstResponder()
        
        cancelButton.rx.tap
            .bind {
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to:self.viewModel.inputs.loginTaps)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .bind(to:self.viewModel.inputs.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .bind(to:self.viewModel.inputs.password)
            .disposed(by: disposeBag)
        
        
        self.viewModel.outputs.enableLogin.drive(onNext: { enable in
            self.loginButton.isEnabled = enable
        }).disposed(by: disposeBag)
        
        self.viewModel.outputs.validatedEmail
            .drive()
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.validatedPassword
            .drive()
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.enableLogin
            .drive()
            .disposed(by: disposeBag)
        
        self.viewModel.isLoading
            .drive(isLoading(for: self.view))
            .disposed(by: disposeBag)
    }

    func configureTableView() {
        //self.navigationItem.rightBarButtonItem = cancelButton
        
        self.title = "Login"
        self.tableView = UITableView(frame: UIScreen.main.bounds)
        self.tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        self.view = self.tableView
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
        header.title = dataSource[section].model
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class HeaderView: UITableViewHeaderFooterView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set(title) {
            titleLabel.text = title
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
            self.contentView.backgroundColor = UIColor.white
            self.contentView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.centerYAnchor
                .constraint(equalTo: self.contentView.centerYAnchor)
                .isActive = true
            titleLabel.leadingAnchor
                .constraint(equalTo: self.contentView.leadingAnchor, constant: 30)
                .isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
