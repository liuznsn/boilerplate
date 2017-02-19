//
//  SearchRepositoriesViewController.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchReposViewController: UIViewController,UITableViewDelegate {

    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Repository>>()
    private let disposeBag = DisposeBag()
    private var tableView: UITableView!
    private var searchController: UISearchController!
    private let viewModel = SearchReposViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindRx()
        
    }
    
    func bindRx() {
        dataSource.configureCell = { dataSource, tableView, indexPath, repository in
            let cell = RepoCell(frame: CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.width, height: 100)))
            
            cell.configure(title: repository.fullName ,
                           description: repository.descriptionField,
                           language: repository.language,
                           stars:  "\(repository.stargazersCount) stars")
            return cell
        }
        
        self.searchController.searchBar.rx.text
            .bindTo(viewModel.inputs.searchKeyword)
            .addDisposableTo(disposeBag)
        
        self.tableView.rx.reachedBottom
            .bindTo(viewModel.inputs.loadNextPageTrigger)
            .addDisposableTo(disposeBag)
        
        self.tableView.rx.itemSelected
            .map { (at: $0, animated: true) }
            .subscribe(onNext: tableView.deselectRow)
            .addDisposableTo(disposeBag)
        
        
        self.viewModel.outputs.elements.asDriver()
            .map { [SectionModel(model: "Repositories", items: $0)] }
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        self.viewModel.isLoading
            .drive()
            // .drive(isLoading(for: self.view))
            .addDisposableTo(disposeBag)
        
        self.tableView.rx.contentOffset
            .subscribe { _ in
                if self.searchController.searchBar.isFirstResponder {
                    _ = self.searchController.searchBar.resignFirstResponder()
                }
            }
            .addDisposableTo(disposeBag)
        
        self.tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: { repo in
                self.viewModel.inputs.tapped(repository: repo)
            }).addDisposableTo(disposeBag)
        
        self.viewModel.outputs.selectedViewModel.drive(onNext: { repoViewModel in
            let repoViewController = RepoViewController()
            repoViewController.viewModel = repoViewModel
            self.navigationController?.pushViewController(repoViewController, animated: true)
        }).addDisposableTo(disposeBag)

    }

    func configureTableView() {
        self.title = "Search"
        
        self.tableView = UITableView(frame: UIScreen.main.bounds)
        self.tableView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
        self.view = self.tableView
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Do any additional setup after loading the view.
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        definesPresentationContext = true
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



