
import UIKit
protocol EmojiCollectionViewCellCellDelegate{
    
    func edit(indexPath: IndexPath)
    
    func delete(indexPath: IndexPath)
}

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    var onTapped: (() -> Void)?
    
    var delegate: EmojiCollectionViewCellCellDelegate?

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
extension EmojiCollectionViewCell: UIContextMenuInteractionDelegate {
 
 func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
  return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
      
    let pinUnpin = UIAction(title: "Закрепить", image: UIImage(systemName: "square.and.pencil")) { [weak self] action in
          guard let self else {return}
          self.delegate?.edit(indexPath: self.indexPath)
      }

    let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil")) { [weak self] action in
        guard let self else {return}
        self.delegate?.edit(indexPath: self.indexPath)
    }

    let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
        guard let self else {return}
        self.delegate?.delete(indexPath: self.indexPath)
    }
      
    return UIMenu(children: [pinUnpin, edit, delete])
   }
 }
}



