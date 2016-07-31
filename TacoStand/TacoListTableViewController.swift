//
//  TacoListTableViewController.swift
//  TacoStand
//
//  Created by Matt Milner on 7/26/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class TacoListTableViewController: UITableViewController {
    
    var tacosArray = [Taco]()

    override func viewDidLoad() {
        super.viewDidLoad()
            
            let tacoAPI = "https://taco-stand.herokuapp.com/api/tacos/"
            
            guard let url = NSURL(string: tacoAPI) else {
                fatalError("Invalid URL")
            }
            
            let session = NSURLSession.sharedSession()
            
            session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                
                let tacoDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                
                let tacoArray = tacoDictionary.valueForKey("tacos") as! NSArray
                
                print(tacoArray)
                
                for taco in tacoArray {
                    
                    print(taco.valueForKey("name") as! String)
                    
                    let newTaco = Taco()
//  
                    newTaco.tacoName = taco.valueForKey("name") as! String
                    newTaco.tacoImageName = taco.valueForKey("photo_url") as! String
                    newTaco.tacoPrice = taco.valueForKey("price_in_cents") as! Int
                    newTaco.tacoPriceString = taco.valueForKey("price") as! String
                    self.tacosArray.append(newTaco)
                    
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                

                
               // print(jsonTacoArray)
                
                
//                for item in jsonTacoArray {
//                    
//                    let taco = Taco()
//                    
//                    print(taco)
////                    taco.tacoName = item.valueForKey("name") as! String
////                    taco.tacoImageName = item.valueForKey("photo_url") as! String
////                    taco.tacoPrice = item.valueForKey("price_in_cents") as! Int
                
                // add taco object to array
//                    
//                }
                
            }.resume()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tacosArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TacoTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TacoCell", forIndexPath: indexPath) as! TacoTableViewCell

        // Configure the cell...
        
        let newTaco = tacosArray[indexPath.row]
        
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue) {
            let url = NSURL(string: newTaco.tacoImageName)
            let imageData = NSData(contentsOfURL: url!)
            let image = UIImage(data: imageData!)
            
            dispatch_async(dispatch_get_main_queue(), {
                cell.imageView?.image = image
                cell.textLabel?.text = newTaco.tacoName
                cell.detailTextLabel?.text = "\(newTaco.tacoPriceString)"
                
            })
            
        }

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "TacoInfoSegue"){
            let tacoInfoViewController = segue.destinationViewController as! TacoInformationViewController
        
            let indexPath = self.tableView.indexPathForSelectedRow?.row
        
            tacoInfoViewController.taco = tacosArray[indexPath!]
        }
    }
    
    
     @IBAction func addTaco() {
        
        let alertController = UIAlertController(title: "Enter Taco Information", message: "Name, Price and Photo URL", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            textField.placeholder = "Taco Name"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            textField.placeholder = "Taco Price"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            textField.placeholder = "Taco Photo URL"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default) { UIAlertAction in
            
            // alertController.textfields![0] -> Name, [1] -> Price, [2] -> Photo
            
            let nameToPost = alertController.textFields![0].text!
            let priceToPost = alertController.textFields![1].text!
            let photoToPost = alertController.textFields![2].text!
            
            let tacosURL = "https://taco-stand.herokuapp.com/api/tacos/"
            
            guard let apiURL = NSURL(string: tacosURL) else { fatalError("Incorrect URL") }
            
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(URL: apiURL)
            request.HTTPMethod = "POST"
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let parameters =  ["name" : nameToPost, "price": priceToPost, "photo_url": photoToPost]
            
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
            
            session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                
                let dataArray = try! NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
                print(dataArray)
                
            }.resume()
            
            // image URL = http://cdn.thedailybeast.com/content/dailybeast/articles/2013/03/12/this-taco-save-america/jcr:content/image.crop.800.500.jpg/45437113.cached.jpg
            
            
            
        }
        
        NSUTF8StringEncoding
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { UIAlertAction in }
        
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        self.tableView.reloadData()
        
    }
    
    
    

}




