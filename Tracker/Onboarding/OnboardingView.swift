import UIKit

class OnboardingView: UIView{
    
        private lazy var onboardingImageView: UIImageView = {
        let onboardingImageView = UIImageView(frame: CGRectMake(0, 0, 0, 0))
        onboardingImageView.translatesAutoresizingMaskIntoConstraints = false
        onboardingImageView.image = UIImage(named: "FirstOnboardingImage")
        onboardingImageView.isHidden = false
        return onboardingImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setupConstraints()
    }
    private func addSubViews(){
        addSubview(onboardingImageView)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
                onboardingImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                onboardingImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                onboardingImageView.topAnchor.constraint(equalTo: topAnchor),
                onboardingImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                onboardingImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setImage(image: UIImage){
        self.onboardingImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
