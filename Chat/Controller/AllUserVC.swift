//
//  AllUserVC.swift
//  Chat
//
//  Created by Niid tech on 08/03/18.
//  Copyright © 2018 NiidTechnology. All rights reserved.
//

import UIKit
import Firebase

class AllUserVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var items = [User]()
    var selectedUser: User?
    let barHeight: CGFloat = 50

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUsers()
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.tableview.contentInset = UIEdgeInsetsMake(-60, 0.0, 0.0, 0.0);
        }else{
//            self.tableview.contentInset.bottom = self.barHeight
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Downloads users list for Contacts View
    func fetchUsers()  {
        if let id = Auth.auth().currentUser?.uid {
            User.downloadAllUsers(exceptID: id, completion: {(user) in
                DispatchQueue.main.async {
                    self.items.append(user)
                    self.tableview.reloadData()
                }
            })
        }
    }
    //MARK: Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            return 0
        } else {
            return 1

//            return self.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if self.items.count == 0 {
//            return self.view.bounds.height - self.navigationController!.navigationBar.bounds.height
//        } else {
            return 80
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch self.items.count {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell")!
//            return cell
//        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListCell
//            cell.clearCellData()
            cell.userIMG.image = self.items[indexPath.row].profilePic
            cell.titleL.text = self.items[indexPath.row].name
        
            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row]
            self.performSegue(withIdentifier: "ShowChat", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChat" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
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
