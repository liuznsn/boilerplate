//
//  RepoViewController.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RepoViewController: UIViewController {

    var tableView: UITableView!
    var repoHeaderView:RepoHeaderView = RepoHeaderView(frame: CGRect(origin: CGPoint.init(x: 0, y: 0),
                                                                     size: CGSize(width: UIScreen.main.bounds.width,
                                                                                  height: 100)))
    var viewModel:RepoViewModel?
    var datasource =  [RepositorySectionViewModel]()
    let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindRx()
    }
    
    func bindRx() {
        guard let viewModel = self.viewModel else { return }
        
        self.title = viewModel.outputs.fullName
        
        self.repoHeaderView.configure(title: viewModel.outputs.fullName,
                                      description: viewModel.outputs.description,
                                      forksCount: viewModel.outputs.forksCounts,
                                      starsCount: viewModel.outputs.starsCount)
        
        viewModel.outputs.dataObservable.drive(onNext: { data in
            self.datasource = data
            self.tableView.reloadData()
        })
        .addDisposableTo(disposeBag)
        
        viewModel.isLoading
            .drive(isLoading(for: self.view))
            .addDisposableTo(disposeBag)

        
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

extension RepoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datasource[section].header
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "RepositoryCell")
        let item = datasource[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        return cell
    }
    
}



extension RepoViewController {
    func configureTableView() {
        self.tableView = UITableView(frame: UIScreen.main.bounds)
        self.tableView.tableHeaderView = self.repoHeaderView
        self.tableView.dataSource = self
        self.view = self.tableView
        self.tableView.tableFooterView = UIView() // Removes separators in empty cells
    }
}


