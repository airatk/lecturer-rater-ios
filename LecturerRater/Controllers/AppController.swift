import UIKit

class AppController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers = [
            UINavigationController(rootViewController: { () -> AllRatingsController in
                let allRatingsController = AllRatingsController()
                
                allRatingsController.tabBarItem = UITabBarItem(title: "All Ratings", image: UIImage(named: "AllRatingsIcon"), selectedImage: nil)
                
                return allRatingsController
            }()),
            UINavigationController(rootViewController: { () -> MyRatingsController in
                let myRatingsController = MyRatingsController()
                
                myRatingsController.tabBarItem = UITabBarItem(title: "My Ratings", image: UIImage(named: "MyRatingsIcon"), selectedImage: nil)
                
                return myRatingsController
            }())
        ]
    }
    
}
