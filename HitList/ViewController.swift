//
//  ViewController.swift
//  HitList
//
//  Created by Andrew Yap on 19/01/2015.
//  Copyright (c) 2015 Nimblic. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

  
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Instance variables
//  var names = [String]()
  var people = [NSManagedObject]()
  
  // MARK: - Override funcs
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    let managedContext = appDelegate.managedObjectContext!
    
    let fetchRequest = NSFetchRequest(entityName: "Person")
    
    var error: NSError?
    
    let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
    
    if let results = fetchedResults {
      people = results
    } else {
      println("Could not fetch \(error), \(error!.userInfo)")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\"The List\""
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Functions
  func saveName(name: String) {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    
    let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
    let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
    
    person.setValue(name, forKey: "name")
    
    var error: NSError?
    if !managedContext.save(&error) {
      println("Could not save \(error), \(error?.userInfo)")
    }
    
    people.append(person)
  }
  
  
  // MARK: - Actions
  @IBAction func addName(sender: AnyObject) {
    var alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .Alert)
    
    let saveAction = UIAlertAction(title: "Save", style: .Default, handler: { action in 
      let textField = alert.textFields![0] as UITextField
      self.saveName(textField.text)
      self.tableView.reloadData()
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
    
    alert.addTextFieldWithConfigurationHandler(nil)
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    presentViewController(alert, animated: true, completion: nil)
  }
}

extension ViewController: UITableViewDataSource {
  
  // MARK: - UITableViewDataSource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cellIdentifier = "Cell"
    var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
    if cell == nil {
      cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
    }
    
    let person = people[indexPath.row]
    cell.textLabel!.text = person.valueForKey("name") as String?
    return cell
  }
  
}