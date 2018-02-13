//
//  ProfileViewController.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SDWebImage

class AvatarTableViewCell: UITableViewCell {
    
    var contentImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        contentImageView.layer.masksToBounds = true
        contentImageView.layer.cornerRadius = 50
        contentImageView.sd_setShowActivityIndicatorView(true)
        contentImageView.sd_setIndicatorStyle(.gray)
        
        self.addSubview(contentImageView)
       
        


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentImageUrl: String? {
        didSet{
            contentImageView.sd_setImage(with: URL(string:self.contentImageUrl!)) { (_, _, _, _) in
                self.contentImageView.center = self.center
            }
            /*
            contentImageView.sd_setImage(with:  URL(string:self.contentImageUrl!) ) { [weak self] _ in
                 self?.contentImageView.center = (self?.center)!
                
            }
            */
        }
    }
    
}




public enum Profile {
    case avatar(title: String, avatarUrl: String)
    case detail(title: String, detail: String)
}

public typealias ProfileSectionModel = SectionModel<String, Profile>

class ProfileViewController: UIViewController, UITableViewDelegate {

    let viewMdoel = ProfileViewModel()
    private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var dataSource:RxTableViewSectionedReloadDataSource<ProfileSectionModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
        dataSource = RxTableViewSectionedReloadDataSource<ProfileSectionModel>(
            configureCell: { dataSource, tableView, indexPath, element in
                switch element {
                case let .avatar(_, avatarUrl):
                    let cell = AvatarTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
                    cell.contentImageUrl = avatarUrl
                    return cell
                case let .detail(_, detail):
                    let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
                    cell.textLabel?.text = detail
                    cell.textLabel?.textAlignment = .center
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
                    return cell
                }
        })
        
        self.viewMdoel.outputs.profileObservable
        .asObservable()
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        self.title = "Profile"
        
        self.tableView = UITableView(frame: UIScreen.main.bounds)
        /*
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        */
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.tableView.dataSource = nil
      
        
        self.view = self.tableView
      
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        
        definesPresentationContext = true
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
          return 150
        }
        return 40
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
