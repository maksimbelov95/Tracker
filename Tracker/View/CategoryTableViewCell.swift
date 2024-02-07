
import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    private lazy var selectedCategoryImage: UIImageView = {
        let imageView = UIImageView(frame: CGRectMake(0, 0, 24, 24))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "SelectedCategory")
        imageView.isHidden = true
        return imageView
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        contentView.addSubview(selectedCategoryImage)
        setupCategoryConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupContentView(){
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .ypBackgroundDay
        
      
    }
    private func setupCategoryConstraints(){
        NSLayoutConstraint.activate([
            selectedCategoryImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            selectedCategoryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            selectedCategoryImage.heightAnchor.constraint(equalToConstant: 24),
            selectedCategoryImage.widthAnchor.constraint(equalToConstant: 24)
        ])
    }

}

