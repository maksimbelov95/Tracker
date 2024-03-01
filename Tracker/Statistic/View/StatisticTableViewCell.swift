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
        contentView.addSubview(statisticTitle)
        contentView.addSubview(statisticDescription)
        contentView.backgroundColor = .ypWhite
        
        
    }
    private func setupCategoryConstraints(){
        NSLayoutConstraint.activate([
            statisticTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            statisticTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            statisticDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            statisticDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            contentView.heightAnchor.constraint(equalToConstant: 90),
            contentView.widthAnchor.constraint(equalToConstant: 343),
        ])
    }
}
