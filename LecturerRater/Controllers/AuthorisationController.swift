import UIKit


class AuthorisationController: UIViewController {
    
    private let usernameInput: UITextField = UITextField()
    private let passwordInput: UITextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Up", style: .plain, target: self, action: #selector(self.signUp))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action: #selector(self.signIn))
        
        self.setUpUsernameInput()
        self.setUpPasswordInput()
        self.setUpKeyboardDismissOnTapOutsideOfKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.usernameInput.becomeFirstResponder()
    }
    
    
    @objc
    private func signUp() {
        guard let username = self.usernameInput.text, let password = self.passwordInput.text, !username.isEmpty, !password.isEmpty else {
            let errorAlertController: UIAlertController = UIAlertController(title: "Input Error", message: "Username or password cannot be empty.", preferredStyle: .alert)
            
            errorAlertController.addAction(UIAlertAction(title: "Close", style: .cancel))
            
            self.present(errorAlertController, animated: true)
            
            return
        }
        
        LecturerRaterAPI.signUp(username: username, password: password) { (token, error_message) in
            guard let token = token else {
                let errorAlertController: UIAlertController = UIAlertController(title: "Signing Up Error", message: error_message, preferredStyle: .alert)
                
                errorAlertController.addAction(UIAlertAction(title: "Close", style: .cancel))
                
                self.present(errorAlertController, animated: true)
                
                return
            }
            
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(token, forKey: "token")
            
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    @objc
    private func signIn() {
        guard let username = self.usernameInput.text, let password = self.passwordInput.text, !username.isEmpty, !password.isEmpty else {
            let errorAlertController: UIAlertController = UIAlertController(title: "Input Error", message: "Username or password cannot be empty.", preferredStyle: .alert)
            
            errorAlertController.addAction(UIAlertAction(title: "Close", style: .cancel))
            
            self.present(errorAlertController, animated: true)
            
            return
        }
        
        LecturerRaterAPI.signIn(username: username, password: password) { (token, error_message) in
            guard let token = token else {
                let errorAlertController: UIAlertController = UIAlertController(title: "Signing In Error", message: error_message, preferredStyle: .alert)
                
                errorAlertController.addAction(UIAlertAction(title: "Close", style: .cancel))
                
                self.present(errorAlertController, animated: true)
                
                return
            }
            
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(token, forKey: "token")
            
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    @objc func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    
    private func setUpUsernameInput() {
        self.usernameInput.placeholder = "username"
        self.usernameInput.textAlignment = .center
        
        self.view.addSubview(self.usernameInput)
        
        self.usernameInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.usernameInput.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 16),
            self.usernameInput.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 32),
            self.usernameInput.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -32),
            self.usernameInput.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setUpPasswordInput() {
        self.passwordInput.placeholder = "password"
        self.passwordInput.textAlignment = .center
        self.passwordInput.isSecureTextEntry = true
        
        self.view.addSubview(self.passwordInput)
        
        self.passwordInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.passwordInput.topAnchor.constraint(equalTo: self.usernameInput.bottomAnchor, constant: 8),
            self.passwordInput.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 32),
            self.passwordInput.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -32),
            self.passwordInput.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setUpKeyboardDismissOnTapOutsideOfKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tap)
    }
    
}
