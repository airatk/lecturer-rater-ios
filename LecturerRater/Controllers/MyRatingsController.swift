import UIKit


class MyRatingsController: UITableViewController {
    
    private var myRatings: [Rating] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(self.signOut))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.createRating))
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.refreshMyRatings), for: .valueChanged)
        
        self.tableView.register(RatingCell.self, forCellReuseIdentifier: RatingCell.reuseIDForMyRatings)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = UserDefaults.standard.string(forKey: "username")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.refreshControl?.beginRefreshing()
        self.refreshMyRatings()
    }
    
    
    @objc
    private func refreshMyRatings() {
        LecturerRaterAPI.getMyRatings(usingToken: UserDefaults.standard.string(forKey: "token")!) { (ratings, error_message) in
            if let ratings = ratings {
                self.myRatings = ratings
                
                self.tableView.reloadData()
            } else {
                let errorAlertController: UIAlertController = UIAlertController(title: "Refresh Error", message: error_message, preferredStyle: .alert)
                
                errorAlertController.addAction(UIAlertAction(title: "Close", style: .cancel))
                
                self.present(errorAlertController, animated: true)
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc
    private func createRating() {
        let ratingCreationNavigationController: UINavigationController = UINavigationController(rootViewController: RatingCreationController())
        
        self.present(ratingCreationNavigationController, animated: true)
    }
    
    @objc
    private func signOut() {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "token")
        
        self.tabBarController?.selectedIndex = 0
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myRatings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ratingCell = tableView.dequeueReusableCell(withIdentifier: RatingCell.reuseIDForMyRatings, for: indexPath) as! RatingCell
        
        ratingCell.setUpSubviews(usingRating: self.myRatings[indexPath.row])
        
        return ratingCell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch(editingStyle) {
            case .delete:
                LecturerRaterAPI.removeRating(withId: self.myRatings[indexPath.row].id, usingToken: UserDefaults.standard.string(forKey: "token")!) { (error_message) in
                    guard error_message == nil else {
                        let errorAlertController: UIAlertController = UIAlertController(title: "Deletion Error", message: error_message, preferredStyle: .alert)
                        
                        errorAlertController.addAction(UIAlertAction(title: "Close", style: .cancel))
                        
                        self.present(errorAlertController, animated: true)
                        
                        return
                    }
                    
                    self.myRatings.remove(at: indexPath.row)
                    tableView.deleteRows(at: [ indexPath ], with: .fade)
                }
                
            default:
                break
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ratingController: RatingController = RatingController()
        
        ratingController.rating = self.myRatings[indexPath.row]
        
        self.navigationController?.pushViewController(ratingController, animated: true)
    }
    
}
