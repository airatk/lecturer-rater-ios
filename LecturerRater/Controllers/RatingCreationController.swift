import UIKit


class RatingCreationController: UIViewController {
    
    private let lecturerInput: UITextField = UITextField()
    private let valueSlider: UISlider = UISlider()
    private let ratingTextInput: UITextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissRatingCreatingController))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.createRating))
        
        self.navigationItem.title = "New Rating"
        
        self.setUpLecturerInput()
        self.setUpValueSlider()
        self.setUpRatingTextInput()
        
        self.setUpKeyboardDismissOnTapOutsideOfKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lecturerInput.becomeFirstResponder()
    }
    
    
    @objc
    private func dismissRatingCreatingController() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func createRating() {
        guard let lecturer = self.lecturerInput.text, let ratingText = self.ratingTextInput.text, !lecturer.isEmpty, !ratingText.isEmpty else {
            self.present(UIAlertController(title: "Input Error", message: "Lecturer name or rating text cannot be empty.", actionButtonTitle: "Close"), animated: true)
            return
        }
        
        let rating: Rating = Rating(
            id: 0, userId: 0,  // ID & User ID are not used for rating creation on the server, therefor are set to 0
            
            lecturer: lecturer,
            value: Int(self.valueSlider.value),
            text: ratingText
        )
        
        LecturerRaterAPI.createRating(rating, usingToken: UserDefaults.standard.string(forKey: "token")!) { (error_message) in
            guard error_message == nil else {
                self.present(UIAlertController(title: "Input Error", message: error_message, actionButtonTitle: "Close"), animated: true)
                return
            }
            
            self.dismiss(animated: true)
        }
    }
    
    @objc
    private func valueSliderValueChanged() {
        self.valueSlider.value = round(self.valueSlider.value)
    }
    
    @objc func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    
    private func setUpLecturerInput() {
        self.lecturerInput.placeholder = "Enter lecturer name…"
        self.lecturerInput.font = .systemFont(ofSize: 16)
        self.lecturerInput.textAlignment = .left
        
        self.view.addSubview(self.lecturerInput)
        
        self.lecturerInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.lecturerInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.lecturerInput.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.lecturerInput.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            self.lecturerInput.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setUpValueSlider() {
        self.valueSlider.minimumValue = 1
        self.valueSlider.maximumValue = 5
        self.valueSlider.addTarget(self, action: #selector(self.valueSliderValueChanged), for: .valueChanged)
        
        self.view.addSubview(self.valueSlider)
        
        self.valueSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.valueSlider.topAnchor.constraint(equalTo: self.lecturerInput.bottomAnchor, constant: 16),
            self.valueSlider.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.valueSlider.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    private func setUpRatingTextInput() {
        self.ratingTextInput.placeholder = "Enter rating text…"
        self.ratingTextInput.font = .systemFont(ofSize: 16)
        self.ratingTextInput.textAlignment = .left
        
        self.view.addSubview(self.ratingTextInput)
        
        self.ratingTextInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.ratingTextInput.topAnchor.constraint(equalTo: self.valueSlider.bottomAnchor, constant: 32),
            self.ratingTextInput.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.ratingTextInput.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func setUpKeyboardDismissOnTapOutsideOfKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tap)
    }
    
}
