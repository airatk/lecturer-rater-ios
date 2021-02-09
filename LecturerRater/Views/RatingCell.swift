import UIKit


class RatingCell: UITableViewCell {
    
    public static let reuseIDForAllRatings: String = "reuseIDForAllRatings"
    public static let reuseIDForMyRatings: String = "reuseIDForMyRatings"
    
    
    private var rating: Rating? {
        didSet {
            self.lecturerLabel.text = rating?.lecturer
            self.numberOfStars = rating?.value ?? 1
            self.ratingTextLabel.text = rating?.text
        }
    }
    
    
    private let lecturerLabel: UILabel = UILabel()
    
    private var numberOfStars: Int = 1
    private let starsStack: UIStackView = UIStackView()
    
    private let ratingTextLabel: UILabel = UILabel()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.lecturerLabel.text = nil
        
        self.numberOfStars = 0
        for star in self.starsStack.arrangedSubviews {
            self.starsStack.removeArrangedSubview(star)
        }
        
        self.ratingTextLabel.text = nil
    }
    
    
    public func setUpSubviews(usingRating rating: Rating) {
        self.rating = rating
        
        self.setUpLecturerLabel()
        self.setUpStarsStack()
        self.setUpRatingTextLabel()
        
        // Setting appropriate RatingCell height by setting constraint of its bottom anchor
        self.contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: self.ratingTextLabel.bottomAnchor).isActive = true
    }
    
    
    private func setUpLecturerLabel() {
        self.lecturerLabel.font = .boldSystemFont(ofSize: 16)
        self.lecturerLabel.textAlignment = .left
        
        self.contentView.addSubview(self.lecturerLabel)
        
        self.lecturerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.lecturerLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.lecturerLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.lecturerLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func setUpStarsStack() {
        for _ in (1...self.numberOfStars) {
            self.starsStack.addArrangedSubview({
                let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
                
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                
                return imageView
            }())
        }
        
        self.starsStack.axis = .horizontal
        self.starsStack.spacing = 6
        
        self.contentView.addSubview(self.starsStack)
        
        self.starsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.starsStack.topAnchor.constraint(equalTo: self.lecturerLabel.bottomAnchor, constant: 8),
            self.starsStack.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor)
        ])
    }
    
    private func setUpRatingTextLabel() {
        self.ratingTextLabel.font = .systemFont(ofSize: 14)
        self.ratingTextLabel.numberOfLines = 2
        
        self.contentView.addSubview(self.ratingTextLabel)
        
        self.ratingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.ratingTextLabel.topAnchor.constraint(equalTo: self.starsStack.bottomAnchor, constant: 8),
            self.ratingTextLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.ratingTextLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
}
