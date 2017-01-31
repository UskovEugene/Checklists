//
//  AllListsViewController.swift
//  Checklists
//
//  Created by пользователь on 29.01.17.
//  Copyright © 2017 Eugene Uskov. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

    //--------------------------------------------------------------------------------------------
    
    var dataModel: DataModel!
    

    //--------------------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------------------
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowChecklist" {
            
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
            
        } else if segue.identifier == "AddChecklist" {
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    
    
    

    
    //--------------------------------------------------------------------------------------------

    // implementing the ListDetailViewControllerDelegate protocol
    
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishAdding checklist: Checklist) {
        
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishEditing checklist: Checklist) {
        
    
        dataModel.sortChecklists()
        
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //--------------------------------------------------------------------------------------------

    
    
    
    // is called when the navigation controller will slide to a new screen.
    func navigationController( _ navigationController: UINavigationController,
                               willShow viewController: UIViewController,
                               animated: Bool) {
        
        if viewController === self {
            
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    
    // is called after the view controller has become visible(when the navigation controller slides
    // the main screen back into view)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        
        if index >= 0 && index < dataModel.lists.count {
            
            let checklist = dataModel.lists[index]
            
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //--------------------------------------------------------------------------------------------
    
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            
            return cell
            
        } else {
            
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    
    // overriden tableView methods
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {

        return dataModel.lists.count
    }

    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = makeCell(for: tableView)
        let checklist = dataModel.lists[indexPath.row]
        
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        
        let count = checklist.countUncheckedItems()
        
        if checklist.items.count == 0 {
            
            cell.detailTextLabel!.text = "(No Items)"
            
        } else if count == 0 {
            
            cell.detailTextLabel!.text = "All Done!"
            
        } else {
            
            cell.detailTextLabel!.text = "\(count) Remaining"
        }
        
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
 
    
    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        // getting navigation controller from the storyboard
        let navigationController = storyboard!.instantiateViewController(
            withIdentifier: "ListDetailNavigationController") as! UINavigationController
        
        let controller = navigationController.topViewController as! ListDetailViewController
        
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }

}
