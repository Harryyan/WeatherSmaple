//
//  ViewController.swift
//  WeatherSmaple
//
//  Created by Harry Yan on 7/11/20.
//

import UIKit

class FavoriteListViewController: UIViewController {

    @IBOutlet weak var favoriteCities: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
    }


}



extension FavoriteListViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "ta"
        
        return cell
    }
}


extension FavoriteListViewController: UITableViewDelegate {
    
}
