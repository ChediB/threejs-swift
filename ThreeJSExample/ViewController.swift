//
//  ViewController.swift
//  ThreeJSExample
//
//  Created by Chedi BACCARI on 28/10/2019.
//  Copyright © 2019 Chedi BACCARI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let data = ["Load an url in WKWebView",
                "Communication: JavaScript --> Swift",
                "Communication: Swift --> JavaScript",
                "Simple cube with three.js",
                "3D model with three.js"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSegue",
            let destinationVC = segue.destination as? DetailsViewController {
            destinationVC.selectedItem = tableView.indexPathForSelectedRow?.row
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdenitifier", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}
