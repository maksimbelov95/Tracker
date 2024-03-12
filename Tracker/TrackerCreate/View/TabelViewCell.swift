
import UIKit

final class TableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .hugeTitleMedium17
        label.textColor = .ypBlack
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .hugeTitleMedium17
        label.textColor = .ypGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addTableViewSubview()
        setupTableViewConstraints()
        setupUIImage()
        self.backgroundColor = .ypBackgroundDay
        self.layer.borderWidth = 0
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableViewConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
    private func setupUIImage(){
        let imageChevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageChevron.tintColor = .black
        self.accessoryView = imageChevron
    }
    
    private func addTableViewSubview(){
        addSubview(titleLabel)
        addSubview(descriptionLabel)}
    
    func settingStrings(title: String, description: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}


