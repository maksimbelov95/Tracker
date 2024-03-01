import UIKit

protocol TrackerCellDelegate: AnyObject{
    func completedTracker(id: UUID, indexPath: IndexPath)
    func uncompletedTracker(id: UUID, indexPath: IndexPath)
}

final class TrackerCellsView: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    
    private var isCompletedToday: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    
    private lazy var trackerCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypBackgroundDay
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0
        return view
    }()
    private lazy var quantityManagementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        return view
    }()
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .hugeTitleMedium16
        return label
    }()
    private lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypWhite
        label.font = .hugeTitleMedium12
        print(label.font.fontName)
        label.numberOfLines = 2
        return label
    }()
    private lazy var countDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .hugeTitleMedium12
        return label
    }()
    private lazy var trackerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 17
        button.tintColor = .ypWhite
        button.addTarget(self, action: #selector(trackerButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var pinImage: UIImageView = {
        let pinImage = UIImageView()
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        pinImage.image = UIImage(named: "Pin")
        pinImage.isHidden = true
        return pinImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @objc private func trackerButtonTapped() {
        guard let trackerId = trackerId, let indexPath = indexPath else {
            assertionFailure("no tracker id")
            return}
        if isCompletedToday{
            delegate?.uncompletedTracker(id: trackerId, indexPath: indexPath)
        }else {
            delegate?.completedTracker(id: trackerId, indexPath: indexPath)
        }
    }
    func configure(with tracker: Tracker, isCompletedToday: Bool, indexPath: IndexPath, completedDays: Int){
        self.indexPath = indexPath
        self.trackerId = tracker.id
        self.isCompletedToday = isCompletedToday
        let dayAddition = getDayAddition(completedDays)
        self.countDaysLabel.text = " \(dayAddition)"
        let color = tracker.color
        addElements()
        setupCellConstraint()
        
        trackerCellView.backgroundColor = color
        trackerButton.backgroundColor = color
        
        trackerLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        let image = isCompletedToday ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        trackerButton.setImage(image, for: .normal)
        
    }
    private func getDayAddition(_ day: Int) -> String {
        
        let preLastDigit = day % 100 / 10;
        
        if (preLastDigit == 1) {
            return "\(day) дней";
        }
        
        switch (day % 10) {
        case 1:
            return "\(day) день";
        case 2,3,4:
            return "\(day) дня";
        default:
            return "\(day) дней";
        }
    }
    func addElements() {
        contentView.addSubview(trackerCellView)
        contentView.addSubview(quantityManagementView)
        
        trackerCellView.addSubview(emojiView)
        trackerCellView.addSubview(pinImage)
        emojiView.addSubview(emojiLabel)
        trackerCellView.addSubview(trackerLabel)
        
        quantityManagementView.addSubview(countDaysLabel)
        quantityManagementView.addSubview(trackerButton)
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
            trackerButton.heightAnchor.constraint(equalToConstant: 34),
            
            pinImage.heightAnchor.constraint(equalToConstant: 12),
            pinImage.widthAnchor.constraint(equalToConstant: 8),
            pinImage.topAnchor.constraint(equalTo: trackerCellView.topAnchor, constant: 18),
            pinImage.trailingAnchor.constraint(equalTo: trackerCellView.trailingAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
