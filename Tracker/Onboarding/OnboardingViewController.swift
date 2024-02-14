
import UIKit

final class OnboardingViewController: UIViewController {
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
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .hugeTitleMedium12
        descriptionLabel.textColor = .ypBlack
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byCharWrapping
        descriptionLabel.text = """
        Sed ut perspiciatis unde omnis iste  natus error sit voluptatem
        """
        return descriptionLabel
    }()
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.setTitle("Начать", for: .normal)
        button.titleLabel?.font = .hugeTitleMedium16
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var onboardingImageView: UIImageView = {
        let onboardingImageView = UIImageView(frame: CGRectMake(0, 0, 0, 0))
        onboardingImageView.translatesAutoresizingMaskIntoConstraints = false
        onboardingImageView.image = UIImage(named: "FirstOnboardingImage")
        onboardingImageView.isHidden = false
        return onboardingImageView
    }()
    
    override func viewDidLoad() {
        addSubViews()
        setupConstraints()
    }
    private func addSubViews(){
        view.addSubview(onboardingImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(startButton)
    }
    private func setupConstraints(){
        NSLayoutConstraint.activate([

        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 476),
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        
        startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
        startButton.heightAnchor.constraint(equalToConstant: 60),
        
        onboardingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        onboardingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        onboardingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        onboardingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        onboardingImageView.topAnchor.constraint(equalTo: view.topAnchor),
        onboardingImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    @objc private func startButtonTapped (){
        let tabBarVC = TabBarController()
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = tabBarVC
        }
    
    }

