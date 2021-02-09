import UIKit


extension UIAlertController {
    
    public convenience init(title: String?, message: String?, actionButtonTitle: String?) {
        self.init(title: title, message: message, preferredStyle: .alert)
        
        self.addAction(UIAlertAction(title: actionButtonTitle, style: .cancel))
    }
    
}
