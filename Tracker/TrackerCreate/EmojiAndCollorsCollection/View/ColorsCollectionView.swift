
import UIKit


final class ColorCollectionViewCell: UICollectionViewCell {
    
    let colorsCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0
        view.frame = CGRect(x: 0, y: 0, width: 52, height: 52)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 16
        addSubview()
        setupCellConstraint()
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



