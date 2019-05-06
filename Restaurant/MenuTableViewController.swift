//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by student12 on 5/2/19.
//  Copyright © 2019 pedro. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var menuItems = [MenuItem]()
    var category: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category.capitalized
        
        MenuController.shared.fetchMenuItems(forCategory: category) {
            (menuItems) in
            if let menuItems = menuItems {
                self.updateUI(with: menuItems)
            }
        }
    }
    
    func updateUI(with menuItems: [MenuItem]) {
        DispatchQueue.main.async {
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)
        configure(cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    return
                }
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuDetailSegue" {
            let menuItemViewController = segue.destination as! MenuItemViewController
            let index = tableView.indexPathForSelectedRow!.row
            
            menuItemViewController.menuItem = menuItems[index]
        }
    }
}
