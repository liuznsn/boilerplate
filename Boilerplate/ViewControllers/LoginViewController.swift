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
}

typealias TitleSectionModel = SectionModel<String, LoginForm>

class LoginViewController: UIViewController,UITableViewDelegate {

   var dataSource:RxTableViewSectionedReloadDataSource<TitleSectionModel>!
   var viewModel:LoginViewModel!
   private let disposeBag = DisposeBag()
   private var tableView: UITableView!
   private var loginButton:UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindRx()
    }
    
    func bindRx() {
         dataSource = RxTableViewSectionedReloadDataSource<TitleSectionModel>(
            configureCell: { dataSource, tableView, indexPath, element in
                let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
                switch element {
                case let .textfield(title, textfield):
                    textfield.placeholder = title
                    textfield.frame = CGRect(x: 20, y: 5, width: Int(cell.frame.width - 40), height: Int(cell.frame.height - 10))
                    cell.addSubview(textfield)
                }
                return cell
        })
 
        let emailTextField = UITextField()
        let passwordTextField = UITextField()
        passwordTextField.isSecureTextEntry = true
        
        let sections = Observable.just([
            TitleSectionModel(model: "Please use Github account to login", items: [
                LoginForm.textfield(title: "ID", textfield: emailTextField),
                LoginForm.textfield(title: "Password", textfield: passwordTextField)
                ]),
            ])
        
        sections
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        emailTextField.becomeFirstResponder()
        
        
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
        self.loginButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        self.loginButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = loginButton
        
        self.title = "Login"
        self.tableView = UITableView(frame: UIScreen.main.bounds)
        self.tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
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

