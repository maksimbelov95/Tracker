
import UIKit

final class EditCategoriesTableViewCell: UITableViewCell {
    
    
    lazy var titleCategory: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .hugeTitleMedium17
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
        contentView.addSubview(titleCategory)
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .ypBackgroundDay
        
    }
    private func setupCategoryConstraints(){
        NSLayoutConstraint.activate([
            titleCategory.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleCategory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}

