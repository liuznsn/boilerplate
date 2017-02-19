//
//  RepoHeaderView.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation
import UIKit

class RepoHeaderView: UITableViewHeaderFooterView {
    
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var forksCountLabel: UILabel!
    private var starsCountLabel: UILabel!
    private var readMeButton: UIButton!

    
    func configure(title: String, description: String, forksCount: String, starsCount: String) {
        titleLabel = UILabel()
        titleLabel.text = title

        descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.text = description

        forksCountLabel = UILabel()
        forksCountLabel.text = "\(forksCount) forks"
        
        starsCountLabel = UILabel()
        starsCountLabel.text = "\(starsCount) stars"

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        forksCountLabel.translatesAutoresizingMaskIntoConstraints = false
        starsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        forksCountLabel.sizeToFit()
        starsCountLabel.sizeToFit()
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(forksCountLabel)
        self.contentView.addSubview(starsCountLabel)
        
        var allConstraints = [NSLayoutConstraint]()
        let views: [String: AnyObject] = ["titleLabel": titleLabel,
                                          "descriptionLabel": descriptionLabel,
                                          "forksCountLabel": forksCountLabel,
                                          "starsCountLabel": starsCountLabel]

        
        let titleLabelConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[titleLabel]-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += titleLabelConstraints
        
        let descriptionLabelConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[descriptionLabel]-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += descriptionLabelConstraints
        
        let starsAndforksLabelConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[forksCountLabel]-[starsCountLabel]-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += starsAndforksLabelConstraints

        
        let forksVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[titleLabel]-[descriptionLabel]-[forksCountLabel]|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += forksVerticalConstraints
        
        let starsVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[titleLabel]-[descriptionLabel]-[starsCountLabel]|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += starsVerticalConstraints
        
        NSLayoutConstraint.activate(allConstraints)

        //readMeButton

    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
       // self.contentView.backgroundColor = UIColor.white
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
