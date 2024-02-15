import UIKit

class OnboardingView: UIView{
    private lazy var onboardingImageView: UIImageView = {
        let onboardingImageView = UIImageView(frame: CGRectMake(0, 0, 0, 0))
        onboardingImageView.translatesAutoresizingMaskIntoConstraints = false
        onboardingImageView.isHidden = false
        return onboardingImageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .hugeTitleBold32
        titleLabel.textColor = .ypBlack
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.text = """
           Sed ut perspiciatis
           unde omnis iste natus
           """
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setupConstraints()
    }
    private func addSubViews(){
        addSubview(onboardingImageView)
        addSubview(titleLabel)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
                onboardingImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                onboardingImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                onboardingImageView.topAnchor.constraint(equalTo: topAnchor),
                onboardingImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                onboardingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 432),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -304)
        ])
    }
    
    func setImage(image: UIImage){
        self.onboardingImageView.image = image
    }
    func setTitleLabelText(text: String){
        self.titleLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
