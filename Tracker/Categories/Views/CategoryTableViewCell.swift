import UIKit

protocol CategoryTableViewCellDelegate{
    func edit(indexPath: IndexPath)
    
    func delete(indexPath: IndexPath)
}

final class CategoryTableViewCell: UITableViewCell {
    
    var indexPath: IndexPath = IndexPath(index: 0)
    
    var delegate: CategoryTableViewCellDelegate?
    
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
        label.textColor = .ypBlack
        label.font = .hugeTitleMedium17
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        setupCategoryConstraints()
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
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

extension CategoryTableViewCell: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil")) { [weak self] action in
                guard let self else {return}
                self.delegate?.edit(indexPath: self.indexPath)
            }
            
            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
                guard let self else {return}
                self.delegate?.delete(indexPath: self.indexPath)
            }
            
            return UIMenu(children: [edit, delete])
        }
    }
}

