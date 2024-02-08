
import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    private lazy var selectedCategoryImage: UIImageView = {
        let imageView = UIImageView(frame: CGRectMake(0, 0, 24, 24))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "SelectedCategory")
        imageView.isHidden = true
        return imageView
    }()
     lazy var titleCategory: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 0, y: 0, width: 149, height: 22)
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
        contentView.addSubview(selectedCategoryImage)
        contentView.addSubview(titleCategory)
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .ypBackgroundDay
        
      
    }
    private func setupCategoryConstraints(){
        NSLayoutConstraint.activate([
            selectedCategoryImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            selectedCategoryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            selectedCategoryImage.heightAnchor.constraint(equalToConstant: 24),
            selectedCategoryImage.widthAnchor.constraint(equalToConstant: 24),
            
            titleCategory.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleCategory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}

