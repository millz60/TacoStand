//
//  TacoInformationViewController.swift
//  TacoStand
//
//  Created by Matt Milner on 7/27/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class TacoInformationViewController: UIViewController {
    
    var taco = Taco()
    @IBOutlet weak var tacoName: UILabel!
    @IBOutlet weak var tacoPrice: UILabel!
    @IBOutlet weak var tacoImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tacoName.text = self.taco.tacoName
        self.tacoPrice.text = self.taco.tacoPriceString
        
        
        let url = NSURL(string: self.taco.tacoImageName)
        let imageData = NSData(contentsOfURL: url!)
        let tacoImage = UIImage(data: imageData!)
        
        self.tacoImage.image = tacoImage
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
