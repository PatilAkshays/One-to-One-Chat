//
//  ImageDetailVC.swift
//  Chat
//
//  Created by Niid tech on 05/03/18.
//  Copyright © 2018 NiidTechnology. All rights reserved.
//

import UIKit

class ImageDetailVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = selectedImage
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    
    @IBAction func pressCrossB(_ sender: Any) {
        self .dismiss(animated: true, completion:nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
