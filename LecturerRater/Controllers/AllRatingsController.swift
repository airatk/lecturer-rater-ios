import UIKit


class AllRatingsController: UITableViewController {
    
    private var allRatings: [Rating] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = "All Ratings"
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.refreshAllRatings), for: .valueChanged)
        
        self.tableView.register(RatingCell.self, forCellReuseIdentifier: RatingCell.reuseIDForAllRatings)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.string(forKey: "token") == nil {
            let authorisationNavigationController: UINavigationController = UINavigationController(rootViewController: AuthorisationController())
            
            authorisationNavigationController.isModalInPresentation = true
            
            self.present(authorisationNavigationController, animated: true)
        }
        
        self.refreshControl?.beginRefreshing()
        self.refreshAllRatings()
    }
    
    
    @objc
    private func refreshAllRatings() {
        LecturerRaterAPI.getRatings { (ratings, error_message) in
            if let ratings = ratings {
                self.allRatings = ratings
                self.tableView.reloadData()
            } else {
                self.present(UIAlertController(title: "Refresh Error", message: error_message, actionButtonTitle: "Close"), animated: true)
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allRatings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ratingCell: RatingCell = tableView.dequeueReusableCell(withIdentifier: RatingCell.reuseIDForAllRatings, for: indexPath) as! RatingCell
        
        ratingCell.setUpSubviews(usingRating: self.allRatings[indexPath.row])
        
        return ratingCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(RatingController(rating: self.allRatings[indexPath.row]), animated: true)
    }
    
}
