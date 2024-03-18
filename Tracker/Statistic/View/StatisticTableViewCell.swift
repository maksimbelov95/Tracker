//
//  StatisticTableViewCell.swift
//  Tracker
//
//  Created by Максим белов on 15.02.2024.
//
import UIKit


final class StatisticTableViewCell: UITableViewCell {
    
    lazy var statisticTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .hugeTitleBold32
        label.textAlignment = .center
        return label
    }()
    
    lazy var statisticDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .hugeTitleMedium12
        label.textAlignment = .center
        return label
    }()
    
    lazy var gradientView: UIView = {
        let gradientView = UIView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.layer.cornerRadius = 16
        
        return gradientView
    }()
    
    lazy var tableView: UIView = {
        let tableView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .ypWhite
        return tableView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        setupCategoryConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupContentView(){
        contentView.layer.masksToBounds = true
        contentView.addSubview(gradientView)
        gradientView.addSubview(tableView)
        tableView.addSubview(statisticTitle)
        tableView.addSubview(statisticDescription)
        contentView.backgroundColor = .ypWhite
        contentView.layer.cornerRadius = 16
    }
    
    private func setupCategoryConstraints(){
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            
            tableView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 1),
            tableView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 1),
            tableView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -1),
            tableView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -1),
            
            statisticTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            statisticTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            statisticDescription.topAnchor.constraint(equalTo: statisticTitle.bottomAnchor, constant: 10),
            statisticDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
        ])
    }
}
