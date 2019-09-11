//
//  ListVC.swift
//  Chat
//
//  Created by Niid tech on 06/03/18.
//  Copyright © 2018 NiidTechnology. All rights reserved.
//

import UIKit
import Firebase
class ListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var switchB: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    let barHeight: CGFloat = 50

    var listArray = [[String: Any]]()
    var items = [Conversation]()
    var selectedUser: User?
    var navBar: UINavigationBar = UINavigationBar()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUserInfo()
        self.fetchData()
//        self.showLogoutAlertWithTitle(title: "Done", message: "dbvhzvchvckvjhcbabcjhadbv")
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate;
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;

//        self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 80.0)
//        setNavBarToTheView()
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.tableView.contentInset = UIEdgeInsetsMake(-60, 0.0, 0.0, 0.0);
        }else{
//            self.tableView.contentInset.bottom = self.barHeight
        }
       
        // Do any additional setup after loading the view.
    }
    
    func setNavBarToTheView() {
        self.navBar.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 80.0)  // Here you can set you Width and Height for your navBar
        self.navBar.backgroundColor = .white
        self.view.addSubview(navBar)
    }
    @IBAction func pressShareExtensionB(_ sender: Any) {
        
        
    }
    
    //Downloads conversations
    @IBAction func pressusersB(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowUsers", sender: self)

        
    }
    func fetchData() {
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
//                        self.playSound()
                        break
                    }
                }
                
            }
        }
//        DispatchQueue.main.async {
//
//            if isFromNotification == true {
//                if self.items.count > 0 {
//                    self.selectedUser = self.items[0].user
//                    self.performSegue(withIdentifier: "ShowChat", sender: self)
//                    isFromNotification = false
//                }
//            }
//
//        }
    
    }
    //    //Downloads current user credentials
    func fetchUserInfo() {
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id, completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
//                    weakSelf?.nameLabel.text = user.name
//                    weakSelf?.emailLabel.text = user.email
//                    weakSelf?.profilePicView.image = user.profilePic
//                    weakSelf = nil
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
            return 1
        } else {
            return self.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.items.count == 0 {
            return self.view.bounds.height - self.navigationController!.navigationBar.bounds.height
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell")!
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
            cell.clearCellData()
       //     cell.userIMG.image = self.items[indexPath.row].user.profilePic
            cell.titleL.text = self.items[indexPath.row].user.name
            switch self.items[indexPath.row].lastMessage.type {
            case .text:
                let message = self.items[indexPath.row].lastMessage.content as! String
                cell.detailL.text = message
            case .location:
                cell.detailL.text = "Location"
            default:
                cell.detailL.text = "Media"
            }
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp))
            let dataformatter = DateFormatter.init()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            cell.timeL.text = date
            if self.items[indexPath.row].lastMessage.owner == .sender && self.items[indexPath.row].lastMessage.isRead == false {
                cell.titleL.font = UIFont(name:"AvenirNext-DemiBold", size: 17.0)
                cell.detailL.font = UIFont(name:"AvenirNext-DemiBold", size: 14.0)
                cell.timeL.font = UIFont(name:"AvenirNext-DemiBold", size: 12.0)
//                cell.userIMG.layer.borderColor = GlobalVariables.blue.cgColor
//                cell.messageLabel.textColor = GlobalVariables.purple
            }else{

//                cell.titleL.font = UIFont(name:"System-Regular", size: 17.0)
//                cell.detailL.font = UIFont(name:"System-Light", size: 14.0)
                cell.titleL.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)
                cell.detailL.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.light)
                cell.timeL.font = UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.light)


            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row].user
            self.performSegue(withIdentifier: "ShowChat", sender: self)
        }
    }
    func showLogoutAlertWithTitle(title: String, message: String) {
        
        
        let actionSheet = UIAlertController.init(title: "", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        
        actionSheet .addAction(UIAlertAction (title: "Log Out", style: UIAlertActionStyle.destructive, handler: { (action) in
            
        }))
        actionSheet .addAction(UIAlertAction (title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    //MARK: Delegates
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1;
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return listArray.count;
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if tableView.isDragging {
//            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//            UIView.animate(withDuration: 0.3, animations: {
//                cell.transform = CGAffineTransform.identity
//            })
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
//        cell.clearCellData()
//        let dict = listArray[indexPath.row]
//        cell.userIMG.image = UIImage.init(named:(dict["image"] as? String)!)
//        cell.titleL.text = dict["title"] as? String
//        cell.detailL.text = dict["detail"] as? String
//        cell.countL.text = dict["count"] as? String
//        if indexPath.row == 3{
//            cell.countL.isHidden = true
//        }
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 61;
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        self.performSegue(withIdentifier: "ShowChat", sender: indexPath.row)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "ShowChat") {
//            let vc = segue.destination as! ChatVC
//            let tag = sender as! Int
//            //vc.indexPathRow = tag
//            vc.indexPathRow = 5
//
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChat" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
            if switchB.isOn{
                vc.isSwitchON = true
            }else{
                vc.isSwitchON = false

            }
        }
    }
    
//ShowChat
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




