
import UIKit


final class ColorCollectionViewCell: UICollectionViewCell {
    
    let colorsCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0
        view.frame = CGRect(x: 0, y: 0, width: 52, height: 52)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 8
        addSubview()
        setupCellConstraint()
    }
    
    func setupCellConstraint(){
        NSLayoutConstraint.activate([
            
            contentView.heightAnchor.constraint(equalToConstant: 52),
            contentView.widthAnchor.constraint(equalToConstant: 52),
            
            colorsCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorsCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            colorsCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            colorsCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
    private func addSubview() {
        contentView.addSubview(colorsCellView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



