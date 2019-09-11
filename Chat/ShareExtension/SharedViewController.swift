//
//  SharedViewController.swift
//  Chat
//
//  Created by Niid tech on 06/07/18.
//  Copyright © 2018 NiidTechnology. All rights reserved.
//

import UIKit

class SharedViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userDefault = UserDefaults(suiteName: "group.ChatAppDemo")
        
        if let dict = userDefault?.value(forKey: "img") as? [String : Any]{
            
            let data = dict["imgData"] as! Data
            let str = dict["name"] as! String
            
            self.imageView.image = UIImage(data: data)
            self.textLabel.text = str
            
            userDefault?.removeObject(forKey: "img")
            userDefault?.synchronize()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


