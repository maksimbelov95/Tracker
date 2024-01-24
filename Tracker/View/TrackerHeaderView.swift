import UIKit

final class TrackerHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "TrackerHeaderView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .hugeTitleBold19
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
