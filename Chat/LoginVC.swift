//
//  LoginVC.swift
//  Chat
//
//  Created by Niid tech on 08/03/18.
//  Copyright © 2018 NiidTechnology. All rights reserved.
//

import UIKit
import Messages

class LoginVC: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonPress(_ sender: Any) {
         if (nameTF.text?.isEmpty)!{
            
        }else if (emailTF.text?.isEmpty)!{
            
        }else if (passwordTF.text?.isEmpty)!{
            
        }else{
//            let  image  = UIImage.init(named: "profile pic")
//            let token = Messaging.messaging().fcmToken
//
//            User.registerUser(withName: self.nameTF.text!, email: self.emailTF.text!, password: self.passwordTF.text!, profilePic: image!, token: token) { [weak weakSelf = self] (status) in
//                DispatchQueue.main.async {
////                    weakSelf?.showLoading(state: false)
////                    for item in self.inputFields {
////                        item.text = ""
////                    }
//                    if status == true {
//                        UserDefaults.standard.set(true, forKey: "isSession")
//                        self .performSegue(withIdentifier: "Login", sender: self)
////                        weakSelf?.pushTomainView()
////                        weakSelf?.profilePicView.image = UIImage.init(named: "profile pic")
//                    } else {
////                        for item in (weakSelf?.waringLabels)! {
////                            item.isHidden = false
////                        }
//                    }
//                }
//            }
        }
    }
    @IBAction func pressLoginB(_ sender: Any) {
        if (emailTF.text?.isEmpty)!{
            
        }else if (passwordTF.text?.isEmpty)!{
            
        }else{
            User.loginUser(withEmail: self.emailTF.text!, password: self.passwordTF.text!) { [weak weakSelf = self](status) in
                DispatchQueue.main.async {
                    //                weakSelf?.showLoading(state: false)
                    //                for item in self.inputFields {
                    //                    item.text = ""
                    //                }
                    if status == true {
                        UserDefaults.standard.set(true, forKey: "isSession")
                        self .performSegue(withIdentifier: "Login", sender: self)
                        //                    weakSelf?.pushTomainView()
                    } else {
                        //                    for item in (weakSelf?.waringLabels)! {
                        //                        item.isHidden = false
                        //                    }
                    }
                    weakSelf = nil
                }
            }
        }
        
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
