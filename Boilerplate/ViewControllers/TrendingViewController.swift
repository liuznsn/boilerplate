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

final class TrendingViewController: UIViewController, UITableViewDelegate, IndicatorInfoProvider {
    
    var viewModel:TrendingViewModel!
    var itemInfo: IndicatorInfo = "View"
    
    // MARK: - Private properties 🕶
    private let disposeBag = DisposeBag()
    private var tableView: UITableView!
    private var searchController: UISearchController!
    private var refreshControl : UIRefreshControl?
    
    // MARK: - LifeCycle 🌎
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Constructor 🏗
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo // IndicatorInfoProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

private extension TrendingViewController {
    func setup() {
        configureTableView()
        bindRx()
    }
    
    func bindRx() {
        self.viewModel = TrendingViewModel()
        self.viewModel.keyword(keyword: self.itemInfo.title!)
        self.viewModel.inputs.refresh()
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Repository>>(
            configureCell: { dataSource, tableView, indexPath, repository in
                let cell = RepoCell(frame: CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.width, height: 100)))
                
                cell.configure(title: repository.fullName! ,
                               description: repository.descriptionField == nil ?  "" : repository.descriptionField!,
                               language: repository.language!,
                               stars:  "\(repository.stargazersCount!) stars")
                
                return cell
        })
        
        self.refreshControl?.rx.controlEvent(.valueChanged)
            .bind(to:self.viewModel.inputs.loadPageTrigger)
            .disposed(by: disposeBag)
        
        self.tableView.rx.reachedBottom
            .bind(to:self.viewModel.inputs.loadNextPageTrigger)
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.elements.asDriver()
            .map { [SectionModel(model: "Repositories", items: $0)] }
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .map { (at: $0, animated: true) }
            .subscribe(onNext: tableView.deselectRow)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self]indexPath in
                self?.viewModel.inputs.tapped(indexRow: indexPath.row)
            }).disposed(by: disposeBag)
        
        self.viewModel.isLoading
            .do(onNext: { isLoading in
                if isLoading {
                    self.refreshControl?.endRefreshing()
                }
            })
            .drive(isLoading(for: self.view))
            .disposed(by: disposeBag)
        
        // Do any additional setup after loading the view.
        self.viewModel.outputs.selectedViewModel
            .drive(onNext: { repoViewModel in
                let repoViewController = RepoViewController()
                repoViewController.viewModel = repoViewModel
                self.navigationController?.pushViewController(repoViewController, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func configureTableView() {
        self.tableView = UITableView(frame: UIScreen.main.bounds)
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view = self.tableView
        
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.tableView.tableFooterView = UIView()
        
        self.refreshControl = UIRefreshControl()
        if let refreshControl = self.refreshControl {
            self.view.addSubview(refreshControl)
            refreshControl.backgroundColor = .clear
            refreshControl.tintColor = .lightGray
        }
    }
}
