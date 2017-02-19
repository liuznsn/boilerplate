//
//  TrendingViewController.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import XLPagerTabStrip

class TrendingViewController: UIViewController,UITableViewDelegate,IndicatorInfoProvider {

    private var viewModel:TrendingViewModel!
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Repository>>()
    private let disposeBag = DisposeBag()
    private var tableView: UITableView!
    private var searchController: UISearchController!
    private var refreshControl : UIRefreshControl?
    var itemInfo: IndicatorInfo = "View"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindRx()
    }

    func bindRx() {
        self.viewModel = TrendingViewModel()
        self.viewModel.keyword(keyword: self.itemInfo.title)
        self.viewModel.inputs.refresh()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, repository in
            //   let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
            let cell = RepoCell(frame: CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.width, height: 100)))
            
            cell.configure(title: repository.fullName ,
                           description: repository.descriptionField,
                           language: repository.language,
                           stars:  "\(repository.stargazersCount) stars")
            return cell
        }
        
        self.refreshControl?.rx.controlEvent(.valueChanged)
            .bindTo(self.viewModel.inputs.loadPageTrigger)
            .addDisposableTo(disposeBag)
        
        self.tableView.rx.reachedBottom
            .bindTo(self.viewModel.inputs.loadNextPageTrigger)
            .addDisposableTo(disposeBag)
        
        self.viewModel.outputs.elements.asDriver()
            .map { [SectionModel(model: "Repositories", items: $0)] }
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        self.tableView.rx.itemSelected
            .map { (at: $0, animated: true) }
            .subscribe(onNext: tableView.deselectRow)
            .addDisposableTo(disposeBag)
        
        /*
         self.tableView.rx.itemSelected
         .subscribe(onNext: { [weak self]indexPath in
         print("indexPath.row:\(indexPath.row)")
         }).addDisposableTo(disposeBag)
         */
        
        self.tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: { repo in
                self.viewModel.inputs.tapped(repository: repo)
            }).addDisposableTo(disposeBag)
        
        self.viewModel.isLoading
            .do(onNext: { isLoading in
                if isLoading {
                    self.refreshControl?.endRefreshing()
                }
            })
            .drive(isLoading(for: self.view))
            .addDisposableTo(disposeBag)
        // Do any additional setup after loading the view.
        
        self.viewModel.outputs.selectedViewModel.drive(onNext: { repoViewModel in
            let repoViewController = RepoViewController()
            repoViewController.viewModel = repoViewModel
            self.navigationController?.pushViewController(repoViewController, animated: true)
        }).addDisposableTo(disposeBag)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        self.tableView = UITableView(frame: UIScreen.main.bounds)
        self.tableView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;

        self.view = self.tableView
        
        self.tableView.tableFooterView = UIView()
        
        self.refreshControl = UIRefreshControl()
        if let refreshControl = self.refreshControl {
            self.view.addSubview(refreshControl)
            refreshControl.backgroundColor = .clear
            refreshControl.tintColor = .lightGray
        }
        
    }
    
    
    // MARK: - IndicatorInfoProvider
    
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
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


