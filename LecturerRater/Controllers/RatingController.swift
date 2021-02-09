import UIKit


class RatingController: UIViewController {
    
    private var rating: Rating!
    
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let starsStack: UIStackView = UIStackView()
    private let ratingTextLabel: UILabel = UILabel()
    
    
    public convenience init(rating: Rating) {
        self.init()
        
        self.rating = rating
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = self.rating!.lecturer
        
        self.setUpStarsStack()
        self.setUpRatingTextLabel()
        self.setUpScrollView()
    }
    
    
    private func setUpStarsStack() {
        for _ in (1...self.rating!.value) {
            self.starsStack.addArrangedSubview({
                let imageView: UIImageView = UIImageView(image: UIImage(systemName: "star.fill"))
                
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                
                return imageView
            }())
        }
        
        self.starsStack.axis = .horizontal
        self.starsStack.spacing = 6
        
        self.scrollView.addSubview(self.starsStack)
        
        self.starsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.starsStack.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor, constant: 12),
            self.starsStack.leadingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func setUpRatingTextLabel() {
        self.ratingTextLabel.text = self.rating?.text
        
        self.ratingTextLabel.font = .systemFont(ofSize: 16)
        self.ratingTextLabel.numberOfLines = 0
        
        self.scrollView.addSubview(self.ratingTextLabel)
        
        self.ratingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.ratingTextLabel.topAnchor.constraint(equalTo: self.starsStack.bottomAnchor, constant: 24),
            self.ratingTextLabel.leadingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            self.ratingTextLabel.trailingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setUpScrollView() {
        self.scrollView.alwaysBounceVertical = true
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: self.ratingTextLabel.bottomAnchor, constant: 24)
        ])
    }
    
}
