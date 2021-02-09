import UIKit


class RatingController: UIViewController {
    
    public var rating: Rating?
    
    
    private let starsStack = UIStackView()
    private let ratingText = UITextView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationItem.title = self.rating!.lecturer
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.setUpStarsStack()
        self.setUpRatingTextLabel()
    }
    
    
    private func setUpStarsStack() {
        for _ in (1...self.rating!.value) {
            self.starsStack.addArrangedSubview({
                let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
                
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                
                return imageView
            }())
        }
        
        self.starsStack.distribution = .equalSpacing
        self.starsStack.alignment = .leading
        self.starsStack.axis = .horizontal
        self.starsStack.spacing = 6
        
        self.view.addSubview(self.starsStack)
        
        self.starsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.starsStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.starsStack.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor)
        ])
    }
    
    private func setUpRatingTextLabel() {
        self.ratingText.text = self.rating?.text
        
        self.ratingText.font = .systemFont(ofSize: 16)
        self.ratingText.textAlignment = .left
        self.ratingText.isEditable = false
        self.ratingText.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        self.view.addSubview(self.ratingText)
        
        self.ratingText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.ratingText.topAnchor.constraint(equalTo: self.starsStack.bottomAnchor, constant: 24),
            self.ratingText.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.ratingText.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.ratingText.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
