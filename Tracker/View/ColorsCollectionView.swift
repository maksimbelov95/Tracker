
import UIKit


final class ColorCollectionViewCell: UICollectionViewCell {
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    var onTapped: (() -> Void)?

    let colorsCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0
        view.frame = CGRect(x: 0, y: 0, width: 52, height: 52)
        return view
    }()
    
    @objc private func colorTapped() {
        self.onTapped?()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 16
        addSubview()
        setupCellConstraint()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
        self.addGestureRecognizer(gesture)
        

    }
    
    func setupCellConstraint(){
        NSLayoutConstraint.activate([
            colorsCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorsCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorsCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorsCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    private func addSubview() {
        contentView.addSubview(colorsCellView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



