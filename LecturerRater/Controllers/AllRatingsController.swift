import UIKit


class AllRatingsController: UITableViewController {
    
    var allRatings: [Rating] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "All Ratings"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshAllRatings), for: .valueChanged)
        
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
                let errorAlertController: UIAlertController = UIAlertController(title: "Refresh Error", message: error_message, preferredStyle: .alert)
                
                errorAlertController.addAction(UIAlertAction(title: "Close", style: .cancel))
                
                self.present(errorAlertController, animated: true)
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
        let ratingCell = tableView.dequeueReusableCell(withIdentifier: RatingCell.reuseIDForAllRatings, for: indexPath) as! RatingCell
        
        ratingCell.setUpSubviews(usingRating: self.allRatings[indexPath.row])
        
        return ratingCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ratingController: RatingController = RatingController()
        
        ratingController.rating = self.allRatings[indexPath.row]
        
        self.navigationController?.pushViewController(ratingController, animated: true)
    }
    
}
