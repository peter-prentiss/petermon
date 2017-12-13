//
//  PeterdexViewController.swift
//  Petermon Go
//
//  Created by admin on 12/13/17.
//  Copyright © 2017 Peter Prentiss. All rights reserved.
//

import UIKit

class PeterdexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var caughtPetermons : [Petermon] = []
    var uncaughtPetermons : [Petermon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caughtPetermons = getCaughtPetermon()
        uncaughtPetermons = getUncaughtPetermon()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CAUGHT"
        } else {
            return "UNCAUGHT"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPetermons.count
        } else {
            return uncaughtPetermons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var petermon : Petermon
        
        if indexPath.section == 0 {
            petermon = caughtPetermons[indexPath.row]
        } else {
            petermon = uncaughtPetermons[indexPath.row]
        }
        
        if let imageName = petermon.imageName {
            cell.imageView?.image = UIImage(named: imageName)
        }
        
        cell.textLabel?.text = petermon.name
        
        return cell
    }

    @IBAction func returnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
