import UIKit

protocol TrackerCellDelegate: AnyObject{
    func trackerButtonTapped(at indexPath: IndexPath)
}

final class TrackerCellsView: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var trackerCompleted: Bool = false
    
    let trackerCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 167, height: 90)
        view.backgroundColor = .ypBackgroundDay
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0
        return view
    }()
    let quantityManagementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 167, height: 58)
        return view
    }()
    let emojiView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        return view
    }()
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .hugeTitleMedium16
        label.frame = CGRect(x: 0, y: 0, width: 16, height: 32)
        return label
    }()
    let trackerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 0, y: 0, width: 143, height: 34)
        label.textColor = .ypWhite
        label.font = .hugeTitleMedium12
        print(label.font.fontName)
        label.numberOfLines = 2
        return label
    }()
    let countDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 0, y: 0, width: 101, height: 18)
        label.textColor = .ypBlack
        label.font = .hugeTitleMedium12
        return label
    }()
    let trackerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.layer.cornerRadius = 17
        button.tintColor = .ypWhite
        return button
    }()
    @objc private func trackerButtonTapped() {
        delegate?.trackerButtonTapped(at: indexPath)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(trackerCellView)
        contentView.addSubview(quantityManagementView)
        
        trackerCellView.addSubview(emojiView)
        emojiView.addSubview(emojiLabel)
        trackerCellView.addSubview(trackerLabel)
        
        quantityManagementView.addSubview(countDaysLabel)
        quantityManagementView.addSubview(trackerButton)
        
        trackerButton.addTarget(self, action: #selector(trackerButtonTapped), for: .touchUpInside)
        
        setupCellConstraint()
    }
    func setupCellConstraint(){
        NSLayoutConstraint.activate([
            trackerCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerCellView.heightAnchor.constraint(equalToConstant: 90),
            
            quantityManagementView.topAnchor.constraint(equalTo: trackerCellView.bottomAnchor),
            quantityManagementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quantityManagementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            quantityManagementView.heightAnchor.constraint(equalToConstant: 58),
            
            emojiView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            trackerLabel.leadingAnchor.constraint(equalTo: trackerCellView.leadingAnchor, constant: 12),
            trackerLabel.bottomAnchor.constraint(equalTo: trackerCellView.bottomAnchor, constant: -12),
            trackerLabel.widthAnchor.constraint(equalToConstant: 143),
        
            countDaysLabel.leadingAnchor.constraint(equalTo: quantityManagementView.leadingAnchor, constant: 12),
            countDaysLabel.centerYAnchor.constraint(equalTo: trackerButton.centerYAnchor),
            
            trackerButton.trailingAnchor.constraint(equalTo: quantityManagementView.trailingAnchor, constant: -12),
            trackerButton.topAnchor.constraint(equalTo: quantityManagementView.topAnchor, constant: 8),
            trackerButton.widthAnchor.constraint(equalToConstant: 34),
            trackerButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
