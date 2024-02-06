
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

    private var titleLabelTopConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)

        titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14)

        NSLayoutConstraint.activate([
            titleLabelTopConstraint,
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])

        self.backgroundColor = .ypBackgroundDay
        self.layer.borderWidth = 0
        self.layer.masksToBounds = true

        let disclosureIndicator = UIImageView(image: UIImage(systemName: "chevron.right"))
        disclosureIndicator.tintColor = .black
        self.accessoryView = disclosureIndicator
    }

    func configure(title: String, description: String?) {
        titleLabel.text = title
        descriptionLabel.text = description

        let constant: CGFloat = description?.isEmpty == true ? 14 : 20
        titleLabelTopConstraint.constant = constant
    }
}


