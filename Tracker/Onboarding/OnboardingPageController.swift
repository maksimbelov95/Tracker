
import UIKit

class OnboardingPageController: UIViewController {
    
    private var slides = [OnboardingView]()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = .hugeTitleMedium16
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 2
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        
        return pageControl
    }()
    override func viewDidLoad() {
        addSubViews()
        setupConstraints()
        setDelegates()
        slides = createSlides()
        setupSlidesScrollView(slide: slides)
    }
    
    private func createSlides() -> [OnboardingView]{
        
        guard let firstOnboardingImage = UIImage(named: "FirstOnboardingImage") else { return [] }
        guard let secondOnboardingImage = UIImage(named: "SecondOnboardingImage") else { return [] }
        
        let firstOnboardingText = """
           Отслеживайте только
           то, что хотит
           """
        
        let secondOnboardingText = """
           Даже если это
           не литры воды и йога
           """
        
        let firstOnboardingView = OnboardingView()
        firstOnboardingView.setImage(image: firstOnboardingImage)
        firstOnboardingView.setTitleLabelText(text: firstOnboardingText)

        
        let secondOnboardingView = OnboardingView()
        secondOnboardingView.setImage(image: secondOnboardingImage)
        secondOnboardingView.setTitleLabelText(text: secondOnboardingText)
        
        return [firstOnboardingView, secondOnboardingView]
    }
    
    private func setupSlidesScrollView(slide: [OnboardingView]){
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slide.count),
                                        height: view.frame.height)
        
        for i in 0..<slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i),
                                     y: 0,
                                     width: view.frame.width,
                                     height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    private func setDelegates(){
        scrollView.delegate = self
    }
    
    @objc private func startButtonTapped (){
            let tabBarVC = TabBarController()
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            window.rootViewController = tabBarVC
            UserStorage.isOnboardingShow = true
            }

    private func addSubViews(){
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(startButton)
    }
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            pageControl.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -24),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            pageControl.heightAnchor.constraint(equalToConstant: 50),
    
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            startButton.heightAnchor.constraint(equalToConstant: 60),

        ])
    }
}
//MARK: UIScrollViewDelegate
extension OnboardingPageController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
