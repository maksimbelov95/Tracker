
import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    
    let emojiCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0
        return view
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "😊"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 38)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupCellConstraint()
    }
    
    func setupCellConstraint(){
        NSLayoutConstraint.activate([
            emojiCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiCellView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiCellView.centerYAnchor),
        ])
    }
    private func addSubview() {
        contentView.addSubview(emojiCellView)
        emojiCellView.addSubview(emojiLabel)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




