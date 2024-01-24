
import UIKit

final class EmojiAndColorsHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "EmojiAndColorsHeaderView"
    
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
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

