
import UIKit


final class EmojiCollectionViewCell: UICollectionViewCell {
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    var onTapped: (() -> Void)?

    let emojiCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 52, height: 52)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0
        return view
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "😊"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 38)
        label.frame = CGRect(x: 0, y: 0, width: 52, height: 52)
        return label
    }()
    
    @objc private func emojiTapped() {
        self.onTapped?()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupCellConstraint()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(emojiTapped))
        self.addGestureRecognizer(gesture)
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



