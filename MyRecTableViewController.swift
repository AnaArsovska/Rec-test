//
//  MyRecTableViewController.swift
//  Recky
//
//  Created by Samina Abdullah on 7/23/18.
//  Copyright © 2018 Samina Abdullah. All rights reserved.
//

import UIKit
import CoreData

class MyRecTableViewController: UITableViewController {

    @IBOutlet weak var myRecommendationItem: UINavigationItem!
    // MARK: - Properties
    
    var resultsController: NSFetchedResultsController<Recommendation>!
    let coreDataStack = CoreDataStack()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Request
        let request: NSFetchRequest<Recommendation> = Recommendation.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        
        //Initialize
        request.sortDescriptors = [sortDescriptors]
        resultsController = NSFetchedResultsController(fetchRequest: request,
                                                      managedObjectContext: coreDataStack.managedContext,
                                                      sectionNameKeyPath: nil,
                                                      cacheName: nil)
        
        resultsController.delegate = self
        
        //Fetch
        do{
            try resultsController.performFetch()
        } catch{
            print("Perform fetch error: \(error)")
        }
    }

   
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsController.sections?[section].numberOfObjects ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let recommendation = resultsController.object(at: indexPath)
        cell.textLabel?.text = recommendation.name
        cell.detailTextLabel?.text = recommendation.location
        
        return cell
    }
 
    //  MARK: table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            // todo: delete todo
            let rec = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(rec)
            do{
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch{
                print("delete failed: \(error)")
                completion(false)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowAddRec", sender: tableView.cellForRow(at: indexPath))
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddRecViewController {
            vc.managedContext = resultsController.managedObjectContext
            
        }
        
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? AddRecViewController{
            vc.managedContext = resultsController.managedObjectContext
            if let indexPath = tableView.indexPath(for: cell){
                let rec = resultsController.object(at: indexPath)
                vc.rec = rec
            }
        }
    }
    

}


extension MyRecTableViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                let rec = resultsController.object(at: indexPath)
                cell.textLabel?.text = rec.name
                cell.detailTextLabel?.text = rec.location
            }
            
        default:
            break
        }
        
    }
    
}

