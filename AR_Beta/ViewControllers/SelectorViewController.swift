//
//  SelectorViewController2.swift
//  AR_Beta
//
//  Created by ryo on 2022/12/12.
//

import UIKit

class SelectorViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let items = ["罐頭","逗貓棒","玩具球","罐頭","逗貓棒","玩具球","罐頭","逗貓棒","玩具球","罐頭","逗貓棒","玩具球"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension SelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    
}
