import UIKit


class AppController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers = [
            self.getTabBarItem(withTitle: "All Ratings", withImageNamed: "AllRatingsIcon", usingController: AllRatingsController()),
            self.getTabBarItem(withTitle: "My Ratings", withImageNamed: "MyRatingsIcon", usingController: MyRatingsController())
        ]
    }
    
    
    private func getTabBarItem(withTitle title: String, withImageNamed imageName: String, usingController tabController: UIViewController) -> UINavigationController {
        let tabNavigationController: UINavigationController = UINavigationController(rootViewController: tabController)
        
        tabNavigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)
        
        return tabNavigationController
    }
    
}
