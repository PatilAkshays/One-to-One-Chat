//  MIT License

//  Copyright (c) 2017 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit
import Photos
import CoreLocation
import Firebase
//import AMScrollingNavbar

var isFromImage : Int = 0

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,  UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate,UIScrollViewDelegate {
    
    //MARK: Properties
    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var indexPathRow: Int?
    var objectCount: Int?

    var ref: DatabaseReference!
    var searchBar = UISearchBar()
    
    var animator = Animator()

//    fileprivate var activityIndicator: LoadMoreActivityIndicator!

    override var inputAccessoryView: UIView? {
        get {
            self.inputBar.frame.size.height = self.barHeight
            self.inputBar.clipsToBounds = true
            return self.inputBar
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    let locationManager = CLLocationManager()
    var items = [Message]()//Message
//    var items = ChatHeaderMessage()//Message

    let imagePicker = UIImagePickerController()
    let barHeight: CGFloat = 50
    var deviceToken: String = ""

    var currentUser: User?
    var canSendLocation = true
    var isSwitchON = false
    var selectedChatArray: Array<Message> = []
    
//    var selectedItems = [Items]()
//    var selectedChatArray : Array = [];

    //MARK: Methods
    func customization() {

       
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        
        //add search view on navigation bar
 //  /*
        
         let view = UIView.init(frame: CGRect(x: 0 ,y : 0 ,width: ScreenSize.SCREEN_WIDTH - 60,height : 40))
        searchBar.frame = CGRect(x: 0 ,y : 0 ,width: 300,height : 35)
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .clear
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)
        self.navigationItem.titleView = view
     //   */
        
        self.imagePicker.delegate = self
        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.bottom = self.barHeight

        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
        self.navigationItem.title = self.currentUser?.name
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
       
        //navigation bar height increase
//        self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 80.0)

        
//        let icon = UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal)
//        let backButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(self.dismissSelf))
//        self.navigationItem.leftBarButtonItem = backButton
        
        self.locationManager.delegate = self
        
        self.getToken()
        
//        activityIndicator = LoadMoreActivityIndicator(tableView: tableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if let navigationController = navigationController as? ScrollingNavigationController {
//            navigationController.followScrollView(tableView, delay: 50.0)
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        if let navigationController = navigationController as? ScrollingNavigationController {
//            navigationController.stopFollowingScrollView()
//        }
    }
    
    

    @objc func showEditing(_ sender: UIBarButtonItem)
    {
        if(self.tableView.isEditing == true)
        {
            tableView.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
        else
        {
            tableView.setEditing(true, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
//        self.tableView.reloadData()
    }
    
    func getToken() {
        Message.downloadReciverToken(forUserID: self.currentUser!.id, completion: {[weak weakSelf = self] (deviceToken) in
            self.deviceToken = deviceToken
        })
    }
    
    //Downloads messages
  /*
     func fetchData() {
//        let userID : String = (Auth.auth().currentUser?.uid)!

        Message.downloadAllMessages(forUserID: self.currentUser!.id, completion: {[weak weakSelf = self] (message) in
            
//            let lastMessage = self.items.messages.last
            
            weakSelf?.items.addSection(section: message.date, item: [message])
//            weakSelf?.items.messages.sort{ $0.timestamp < $1.timestamp }

//            weakSelf?.items.append(message)
//            weakSelf?.items.  sort{ $0.timestamp < $1.timestamp }

//            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.messages.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: 0, section: self.items.sections.count - 1), at: .bottom, animated: false)
                }
            }
        })
        Message.markMessagesRead(forUserID: self.currentUser!.id)
    }*/
   
    func fetchData() {
        //        let userID : String = (Auth.auth().currentUser?.uid)!
        
        Message.downloadAllMessages(forUserID: self.currentUser!.id, completion: {[weak weakSelf = self] (message) in
            
            if self.items.count > 1{
                let lastMessage : Message = self.items[self.objectCount! - 1]
                let dateStr = message.date
                let priSecDateStr = lastMessage.date
                
                let isDayChange = self.dayDifferenceFrom(dateStr: dateStr as NSString, priSecDate: priSecDateStr as NSString)
                if !isDayChange {
                    let timeMessageObj = Message.init(type: .text, content: message.content, owner: .timeHeader, timestamp: message.timestamp, isRead: true, date: dateStr as String)
                    weakSelf?.items.append(timeMessageObj)
                    weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
                }
            }else{
//                let lastMessage : Message = self.items[self.objectCount!]
                let dateStr = message.date
//                let priSecDateStr = lastMessage.date
                
//                let isDayChange = self.dayDifferenceFrom(dateStr: dateStr as NSString, priSecDate: priSecDateStr as NSString)
//                if isDayChange {
                    let timeMessageObj = Message.init(type: .text, content: message.content, owner: .timeHeader, timestamp: message.timestamp, isRead: true, date: dateStr as String)
                    weakSelf?.items.append(timeMessageObj)
                    weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
//                }
            }
         

            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            self.objectCount = self.items.count
            
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
//                if let state = weakSelf?.items.messages.isEmpty, state == false {
//                    weakSelf?.tableView.reloadData()
//                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: 0, section: self.items.sections.count - 1), at: .bottom, animated: false)
//                }
            }
        })
        Message.markMessagesRead(forUserID: self.currentUser!.id)
    }//*/
    
    //Hides current viewcontroller
    @objc func dismissSelf() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func composeMessage(type: MessageType, content: Any)  {
        let dateStr = self.currentDateToTimeConverter()
       
        let message = Message.init(type: type, content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false, date: dateStr as String)
        Message.send(message: message, toID: self.currentUser!.id, completion: {(_) in
        })
  
        self.inputAccessoryView?.isHidden = false

    }
    
    func checkLocationPermission() -> Bool {
        var state = false
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            state = true
        case .authorizedAlways:
            state = true
        default: break
        }
        return state
    }
    
    func animateExtraButtons(toHide: Bool)  {
        switch toHide {
        case true:
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.inputBar.layoutIfNeeded()
            }
        default:
            self.bottomConstraint.constant = -50
            UIView.animate(withDuration: 0.3) {
                self.inputBar.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func showMessage(_ sender: Any) {
       self.animateExtraButtons(toHide: true)
    }
    
    @IBAction func selectGallery(_ sender: Any) {
        self.animateExtraButtons(toHide: true)
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == .authorized || status == .notDetermined) {
            self.imagePicker.sourceType = .savedPhotosAlbum;
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func selectCamera(_ sender: Any) {
        self.animateExtraButtons(toHide: true)
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if (status == .authorized || status == .notDetermined) {
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectLocation(_ sender: Any) {
        self.canSendLocation = true
        self.animateExtraButtons(toHide: true)
        if self.checkLocationPermission() {
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    @IBAction func showOptions(_ sender: Any) {

        self.animateExtraButtons(toHide: false)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let text = self.inputTextField.text {
            if text.characters.count > 0 {
                self.composeMessage(type: .text, content: self.inputTextField.text!)
                self.callPushNotificationAPI(text: self.inputTextField.text!, token: deviceToken)
                self.inputTextField.text = ""
            }
        }
    }
    
    //MARK: NotificationCenter handlers
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tableView.contentInset.bottom = height
            self.tableView.scrollIndicatorInsets.bottom = height
//            if self.items.messages.count > 0 {
//              self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: self.items.sections.count - 1), at: .bottom, animated: true)
//            }
            if isFromImage == 0{
                
                if self.items.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
            }else{
                isFromImage = 0
            }
            
        }
    }

    //MARK: Delegates
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 //items.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count//items.messages[section].count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    //use for whats app type ui
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item : Message = self.items[indexPath.row]
//        Message *message = [self.tableArray objectAtIndexPath:indexPath];
        switch self.items[indexPath.row].owner {
        case .timeHeader:
            return 60
        case .receiver:
            if item.heigh == nil {
                return 0
            }else{
                switch self.items[indexPath.row].type {
                case .text:
                    return item.heigh!
                case .photo:
                    return item.heigh! + 10
                case .location:
                    return item.heigh!
                }
            }
        case .sender:
            if item.heigh == nil {
                return 0
            }else{
//                return item.heigh!
                switch self.items[indexPath.row].type {
                case .text:
                    return item.heigh!
                case .photo:
                    return item.heigh! + 10
                case .location:
                    return item.heigh!
                }
            }
        }
       
    }
 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let row = indexPath.row
//        let section = indexPath.section
//        switch items.messages[section][row].owner {
        
        //use for whats app type ui
/*
        switch self.items[indexPath.row].owner {
        case .timeHeader:
            print("Header")

            let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell1", for: indexPath) as! CustomHeaderCell
            headerCell.backgroundColor = UIColor.clear
            headerCell.headerLabel.text = self.dateFormatterWithDays(dateStr: items[indexPath.row].date as NSString) as String
            headerCell.selectionStyle = UITableViewCellSelectionStyle.none
            return headerCell;
            
        case .receiver:
            print("Receiver")

            let CellIdentifier = "MessageCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? MessageCell
            if cell == nil {
                cell = MessageCell(style: .default, reuseIdentifier: CellIdentifier)
            }
            cell?.setMessage(message: self.items[indexPath.row])

            switch self.items[indexPath.row].type {
            case .text:
                cell?.bubbleImage?.backgroundColor = UIColor.clear
                cell?.textView?.text = self.items[indexPath.row].content as! String
            case .photo:
//                cell?.bubbleImage?.image = self.items[indexPath.row].image
                if let image = self.items[indexPath.row].image {
                    cell?.bubbleImage?.image = image
                    cell?.textView?.isHidden = true
                    cell?.bubbleImage?.backgroundColor = UIColor.clear

                    
                    
                    var tapGesture = UITapGestureRecognizer()
                    tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTapOnPhoto(_:)))
                    tapGesture.numberOfTapsRequired = 1
                    cell?.bubbleImage?.isUserInteractionEnabled = true
                    cell?.bubbleImage?.addGestureRecognizer(tapGesture)
                    tapGesture.delegate = self as? UIGestureRecognizerDelegate;
                    cell?.bubbleImage?.tag = indexPath.row;
                    
                } else {
                    cell?.bubbleImage?.image = UIImage.init(named: "loading")
                    cell?.bubbleImage?.backgroundColor = UIColor.lightGray

                    //                    cell.messageBackground.image = self.items[indexPath.row].content as? UIImage
                                        cell?.textView?.isHidden = true
                    
                    
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                //                                self.tableView .reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                                //                                self.tableView.reloadData()
                            }
                        }
                    })
                    //
                }
                
//               break
               
            case .location:
               break
            }
            
            cell?.backgroundColor = UIColor.clear
            return cell!
        case .sender:
            print("Sender")
            
            let CellIdentifier = "GroupSenderCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? GroupSenderCell
            if cell == nil {
                cell = GroupSenderCell(style: .default, reuseIdentifier: CellIdentifier)
            }
            cell?.setMessage(message: self.items[indexPath.row])
            cell?.nameLabel?.text = currentUser?.name
            
            switch self.items[indexPath.row].type {
            case .text:
                cell?.bubbleImage?.backgroundColor = UIColor.clear
                
                cell?.textView?.text = self.items[indexPath.row].content as! String
            case .photo:
                //                cell?.bubbleImage?.image = self.items[indexPath.row].image
                if let image = self.items[indexPath.row].image {
                    cell?.bubbleImage?.image = image
                    cell?.textView?.isHidden = true
                    
                    cell?.bubbleImage?.backgroundColor = UIColor.clear
                    
                    
                    var tapGesture = UITapGestureRecognizer()
                    tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTapOnPhoto(_:)))
                    tapGesture.numberOfTapsRequired = 1
                    cell?.bubbleImage?.isUserInteractionEnabled = true
                    cell?.bubbleImage?.addGestureRecognizer(tapGesture)
                    tapGesture.delegate = self as? UIGestureRecognizerDelegate;
                    cell?.bubbleImage?.tag = indexPath.row;
                    
                } else {
                    cell?.bubbleImage?.image = UIImage.init(named: "loading")
                    cell?.bubbleImage?.backgroundColor = UIColor.lightGray
                    //                    cell.messageBackground.image = self.items[indexPath.row].content as? UIImage
                    cell?.textView?.isHidden = true
                    
                    
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                //                                self.tableView .reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                                //                                self.tableView.reloadData()
                            }
                        }
                    })
                    //
                }
                
                //               break
                
            case .location:
                break
            }
            
            cell?.backgroundColor = UIColor.clear
            return cell!
/*
            let CellIdentifier = "MessageCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? MessageCell
            if cell == nil {
                cell = MessageCell(style: .default, reuseIdentifier: CellIdentifier)
            }
            cell?.setMessage(message: self.items[indexPath.row])
            
            
            switch self.items[indexPath.row].type {
            case .text:
                cell?.bubbleImage?.backgroundColor = UIColor.clear

                cell?.textView?.text = self.items[indexPath.row].content as! String
            case .photo:
                //                cell?.bubbleImage?.image = self.items[indexPath.row].image
                if let image = self.items[indexPath.row].image {
                    cell?.bubbleImage?.image = image
                    cell?.textView?.isHidden = true
                    
                    cell?.bubbleImage?.backgroundColor = UIColor.clear

                    
                    var tapGesture = UITapGestureRecognizer()
                    tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTapOnPhoto(_:)))
                    tapGesture.numberOfTapsRequired = 1
                    cell?.bubbleImage?.isUserInteractionEnabled = true
                    cell?.bubbleImage?.addGestureRecognizer(tapGesture)
                    tapGesture.delegate = self as? UIGestureRecognizerDelegate;
                    cell?.bubbleImage?.tag = indexPath.row;
                    
                } else {
                    cell?.bubbleImage?.image = UIImage.init(named: "loading")
                    cell?.bubbleImage?.backgroundColor = UIColor.lightGray
                    //                    cell.messageBackground.image = self.items[indexPath.row].content as? UIImage
                    cell?.textView?.isHidden = true
                    
                    
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                //                                self.tableView .reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                                //                                self.tableView.reloadData()
                            }
                        }
                    })
                    //
                }
                
                //               break
                
            case .location:
                break
            }
            
            cell?.backgroundColor = UIColor.clear
            return cell!
             */
        }
      //  */
        
       // /*
        
        switch self.items[indexPath.row].owner {
        case .timeHeader:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! CustomHeaderCell
            headerCell.backgroundColor = UIColor.clear
            
            headerCell.headerLabel.text = self.dateFormatterWithDays(dateStr: items[indexPath.row].date as NSString) as String
            headerCell.selectionStyle = UITableViewCellSelectionStyle.none
            return headerCell;

        case .receiver:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
            cell.clearCellData()
            cell.timeL.font = UIFont(name:"Helvetica", size: 10.0)

            switch self.items[indexPath.row].type {
            case .text:
                cell.timeL.backgroundColor = UIColor.clear
                cell.message.isUserInteractionEnabled = true
                cell.message.text = self.items[indexPath.row].content as! String
//                cell.timeL.textColor = UIColor.init(red: 76/255.0, green: 67/255.0, blue: 67/255.0, alpha: 1)
                cell.timeL.textColor = UIColor.lightGray
                
                
//                let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
//                cell.addGestureRecognizer(gestureRecognizer)
//                cell.isUserInteractionEnabled = true
                
//                var longGesture = UILongPressGestureRecognizer()
//                longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ChatVC.handleTextLongPress(_:)))
//                longGesture.minimumPressDuration = 1
//                cell.addGestureRecognizer(longGesture)
//                longGesture.delegate = self as? UIGestureRecognizerDelegate;
                
                
            case .photo:
                cell.timeL.backgroundColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.18)
                cell.timeL.textColor = UIColor.lightGray

                cell.message.isUserInteractionEnabled = false

                var longGesture = UILongPressGestureRecognizer()
                longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ChatVC.handlePhotoLongPress(_:)))
                longGesture.minimumPressDuration = 1
                cell.addGestureRecognizer(longGesture)
                longGesture.delegate = self as? UIGestureRecognizerDelegate;
                
               
//                if let image = self.items.messages[section][row].image {

                if let image = self.items[indexPath.row].image {
                    cell.messageBackground.image = image
                    cell.message.isHidden = true
//                    cell.setLongPressGestureForImage(message:self.items[indexPath.row])

                    
                    var tapGesture = UITapGestureRecognizer()
                    tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTapOnPhoto(_:)))
                    tapGesture.numberOfTapsRequired = 1
                    cell.messageBackground.isUserInteractionEnabled = true
                    cell.messageBackground.addGestureRecognizer(tapGesture)
                    tapGesture.delegate = self as? UIGestureRecognizerDelegate;
                    cell.messageBackground.tag = indexPath.row;
                    
                } else {
                    cell.messageBackground.image = UIImage.init(named: "loading")
//                    cell.messageBackground.image = self.items[indexPath.row].content as? UIImage
//                    cell.message.isHidden = true

                
                     self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.tableView .reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                                
//                                self.tableView.reloadData()
                            }
                        }
                    })
                    //
                }
            case .location:
                cell.messageBackground.image = UIImage.init(named: "location")
                cell.message.isHidden = true
            }
          
            let  timeStr : String = self.dateToTimeConverter(date: self.items[indexPath.row].date ) as String
            cell.timeL.text = timeStr

            if tableView.isEditing{
                cell.selectionStyle = UITableViewCellSelectionStyle.default
                
            } else{
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
            }

            return cell
        case .sender:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderForGroup", for: indexPath) as! SenderCell
            cell.clearCellData()//senderNL
//            cell.profilePic.image = self.currentUser?.profilePic
            cell.profilePic.image = UIImage (named: "alex")//profile pic
            cell.senderNL.text = currentUser?.name;
            cell.timeL.font = UIFont(name:"Helvetica", size: 10.0)

            switch self.items[indexPath.row].type {
            case .text:
                cell.message.isUserInteractionEnabled = true
//                cell.timeL.textColor = UIColor.init(red: 76/255.0, green: 67/255.0, blue: 67/255.0, alpha: 1)
                cell.timeL.textColor = UIColor.lightGray
//
//                let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
//                cell.addGestureRecognizer(gestureRecognizer)
//                cell.isUserInteractionEnabled = true
                
//                var longGesture = UILongPressGestureRecognizer()
//                longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ChatVC.handleTextLongPress(_:)))
//                longGesture.minimumPressDuration = 1
//                cell.addGestureRecognizer(longGesture)
//                longGesture.delegate = self as? UIGestureRecognizerDelegate;
                
                cell.timeL.backgroundColor = UIColor.clear
                cell.message.text = self.items[indexPath.row].content as! String
            case .photo:
                cell.timeL.backgroundColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.18)
                cell.timeL.textColor = UIColor.lightGray
                cell.message.isUserInteractionEnabled = false

//                var longGesture = UILongPressGestureRecognizer()
//                longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ChatVC.handlePhotoLongPress(_:)))
//                longGesture.minimumPressDuration = 1
//                cell.addGestureRecognizer(longGesture)
//                longGesture.delegate = self as? UIGestureRecognizerDelegate;
                
                
                

                if let image = self.items[indexPath.row].image {
                    cell.messageBackground.image = image
                    cell.message.isHidden = true
//                    cell.setLongPressGestureForImage(message:self.items[indexPath.row])
                    
                    var tapGesture = UITapGestureRecognizer()
                    tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTapOnPhoto(_:)))
                    tapGesture.numberOfTapsRequired = 1
                    cell.messageBackground.isUserInteractionEnabled = true
                    cell.messageBackground.addGestureRecognizer(tapGesture)
                    tapGesture.delegate = self as? UIGestureRecognizerDelegate;
                    cell.messageBackground.tag = indexPath.row;
                    
                } else {
                    cell.messageBackground.image = UIImage.init(named: "loading")
//                    cell.messageBackground.image = self.items[indexPath.row].content as? UIImage
//                    cell.message.isHidden = true

              //
                     self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.tableView .reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)

//                                self.tableView.reloadData()
                            }
                        }
                    }) //
                }
            case .location:
                cell.messageBackground.image = UIImage.init(named: "location")
                cell.message.isHidden = true
                
            }
            if tableView.isEditing{
                cell.selectionStyle = UITableViewCellSelectionStyle.default

            } else{
                cell.selectionStyle = UITableViewCellSelectionStyle.none

            }

            let  timeStr : String = self.dateToTimeConverter(date: self.items[indexPath.row].date ) as String

            cell.timeL.text = timeStr
            
            return cell
        }//*/
    }
    
    
    
    // MARK: - UIGestureRecognizer
    @objc func handleLongPressGesture(_ recognizer: UIGestureRecognizer) {
        
        let targetRectangle = CGRect(x: 100, y: 100, width: 100, height: 100)
        UIMenuController.shared.setTargetRect(targetRectangle, in: view)
        let menuItem = UIMenuItem(title: "Custom Action", action: #selector(ChatVC.customAction(_:)))
        UIMenuController.shared.menuItems = [menuItem]
        UIMenuController.shared.setMenuVisible(true, animated: true)
//
//        guard recognizer.state == .recognized else { return }
//
//        if let recognizerView = recognizer.view,
//            let recognizerSuperView = recognizerView.superview, recognizerView.becomeFirstResponder()
//        {
//            let menuController = UIMenuController.shared
//            menuController.setTargetRect(recognizerView.frame, in: recognizerSuperView)
//            menuController.setMenuVisible(true, animated:true)
//        }
    }
//    var canBecomeFirstResponder: Bool {
//        return true
//    }
//
//    func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        var result = false
//        if Selector("copy:") == action || Selector("customAction:") == action {
//            result = true
//        }
//        return result
//    }
//
//    // UIMenuController Methods
//    // Default copy method
//    @objc func copy(_ sender: Any?) {
//        print("Copy")
//    }
    
    // Our custom method
    @objc func customAction(_ sender: Any?) {
        print("Custom Action")
    }

    
    //3.Here we are enabling copy action
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(UIResponderStandardEditActions.copy(_:)))
        
    }
    // MARK: - UIResponderStandardEditActions
    override func copy(_ sender: Any?) {
        //4.copy current Text to the paste board
        UIPasteboard.general.string = "text"
    }
    
   /* func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 36;
        }else{
            let dateStr = items.sections[section]
            let priSecDateStr = items.sections[section - 1]
            
            let isDayChange = self.dayDifferenceFrom(dateStr: dateStr as NSString, priSecDate: priSecDateStr as NSString)
            if isDayChange {
                return 1.0
            }else{
                return 36
            }
        }
     

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items.sections[section]
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! CustomHeaderCell
        headerCell.backgroundColor = UIColor.clear
        headerCell.headerLabel.text = self.dateFormatterWithDays(dateStr: items.sections[section] as NSString) as String

        return headerCell;
    }
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.inputTextField.resignFirstResponder()
        let row = indexPath.row
        let section = indexPath.section
        if tableView.isEditing {
//            switch self.items[indexPath.row].owner {
//
//            case .receiver:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
//                cell.selectionStyle = UITableViewCellSelectionStyle.default
//            case .sender:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
//                cell.selectionStyle = UITableViewCellSelectionStyle.default
//            }
            self.selectedChatArray.append(self.items[indexPath.row])
            
            
        }else{
//            switch self.items[indexPath.row].owner {
//
//            case .receiver:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
//                cell.selectionStyle = UITableViewCellSelectionStyle.none
//            case .sender:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
//                cell.selectionStyle = UITableViewCellSelectionStyle.none
//            }
            
            self.inputTextField.resignFirstResponder()
            switch self.items[indexPath.row].type {
            case .photo:
                if let photo = self.items[indexPath.row].image {
                    let info = ["viewType" : ShowExtraView.preview, "pic": photo] as [String : Any]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
                    self.inputAccessoryView?.isHidden = false///
                }
            case .location:
                let coordinates = (self.items[indexPath.row].content as! String).components(separatedBy: ":")
                let location = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(coordinates[0])!, longitude: CLLocationDegrees(coordinates[1])!)
                let info = ["viewType" : ShowExtraView.map, "location": location] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
                self.inputAccessoryView?.isHidden = false//
            default: break
            }
        }
       
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {

            self.selectedChatArray.removeLast()
//            switch self.items[indexPath.row].owner {
//
//            case .receiver:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
//                cell.selectionStyle = UITableViewCellSelectionStyle.default
//            case .sender:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
//                cell.selectionStyle = UITableViewCellSelectionStyle.default
//            }
//            self.selectedChatArray.r(self.items[indexPath.row])
        }else{
//            switch self.items[indexPath.row].owner {
//
//            case .receiver:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
//                cell.selectionStyle = UITableViewCellSelectionStyle.none
//            case .sender:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
//                cell.selectionStyle = UITableViewCellSelectionStyle.none
//            }

        }
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
////        let row = indexPath.row
////        let section = indexPath.section
//
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            // delete data and row
////            self.items.remove(at: indexPath.row)
////            tableView.deleteRows(at: [indexPath], with: .fade)
////            .items.messages[section][row]
//        }
//    }
    
    @objc func handleTapOnPhoto(_ sender: UITapGestureRecognizer) {
//        let view = sender.view;
        isFromImage = 0
        let location = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at:location)
        switch self.items[(indexPath?.row)!].type {
        case .text:
            break
        case .photo:
            isFromImage = 1
            if let cell = tableView.cellForRow(at: indexPath!) as? ReceiverCell{
                let image = cell.messageBackground?.image
                self.performSegue(withIdentifier: "_toImageDetail", sender: image)
                animator.cellImageView = cell.messageBackground
            }else{
                if let cell = tableView.cellForRow(at: indexPath!) as? SenderCell{
                    let image = cell.messageBackground?.image
                    self.performSegue(withIdentifier: "_toImageDetail", sender: image)
                    animator.cellImageView = cell.messageBackground
                }else{
                    self .performSegue(withIdentifier: "ShowFullImage", sender: indexPath)
                    
                }

            }
//            let image = self.items[(indexPath?.row)!].image
//            self.performSegue(withIdentifier: "_toImageDetail", sender: image)
//            animator.cellImageView = cell.imgView
//            self .performSegue(withIdentifier: "ShowFullImage", sender: indexPath)


        case .location:
            break
        }

//        if let indexPath :NSIndexPath = self.tableView.indexPathForRow(at: location) {
//            self .performSegue(withIdentifier: "ShowFullImage", sender: indexPath)
//
//         }else{
//            print("not working")
//
//        }
        
    }
    
    @objc func handlePhotoLongPress(_ sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at:location)
        switch self.items[(indexPath?.row)!].type {
        case .text:
            break
        case .photo:
            let actionSheet = UIAlertController.init()
            
            actionSheet .addAction(UIAlertAction (title: "Save", style: UIAlertActionStyle.default, handler: { (action) in
                if let image = self.items[(indexPath?.row)!].image {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                }

            }))
            actionSheet .addAction(UIAlertAction (title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
                
            }))
            self.present(actionSheet, animated: true, completion: nil)
            
        case .location:
            break
        }

        
//        let actionSheet = UIAlertController.init()
//
//        actionSheet .addAction(UIAlertAction (title: "Forword", style: UIAlertActionStyle.default, handler: { (action) in
//
//        }))
//        actionSheet .addAction(UIAlertAction (title: "Reply", style: UIAlertActionStyle.default, handler: { (action) in
//
//        }))
//        actionSheet .addAction(UIAlertAction (title: "Delete", style: UIAlertActionStyle.destructive, handler: { (action) in
//
//        }))
//        actionSheet .addAction(UIAlertAction (title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
//
//        }))
//        self.present(actionSheet, animated: true, completion: nil)
//
        
        
    }
//
    @objc func handleTextLongPress(_ sender: UILongPressGestureRecognizer) {
     
        let actionSheet = UIAlertController.init()
        actionSheet .addAction(UIAlertAction (title: "Edit", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        actionSheet .addAction(UIAlertAction (title: "Copy", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        actionSheet .addAction(UIAlertAction (title: "Forword", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        actionSheet .addAction(UIAlertAction (title: "Reply", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        actionSheet .addAction(UIAlertAction (title: "Delete", style: UIAlertActionStyle.destructive, handler: { (action) in
//            self.tableView.isEditing = true;
        }))
        actionSheet .addAction(UIAlertAction (title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowFullImage") {
            
            
            
            let vc = segue.destination as! ImageDetailVC
            let indexPath = sender as! IndexPath
            let row = indexPath.row
            let section = indexPath.section
            
            vc.selectedImage = self.items[indexPath.row].image
//            vc.selectedImage = self.items.messages[section][row].content as? UIImage
            
        }else if segue.identifier == "_toImageDetail"{
            guard let dvc = segue.destination as? ImageDetailViewController else{return}
            dvc.image = sender as? UIImage
            dvc.transitioningDelegate = animator
            dvc.modalPresentationStyle = .overCurrentContext
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.composeMessage(type: .photo, content: pickedImage)
        } else {
            let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.composeMessage(type: .photo, content: pickedImage)
        }
        
        
        self.callPushNotificationAPI(text: "Image", token: deviceToken)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        if let lastLocation = locations.last {
            if self.canSendLocation {
                let coordinate = String(lastLocation.coordinate.latitude) + ":" + String(lastLocation.coordinate.longitude)
//                let date = NSDate() as Date

//                if isSender{
//                    let message = Message.init(type: .location, content: coordinate, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false, date: date as String)
//                    items.append(message)
//                }else{
//                    let message = Message.init(type: .location, content: coordinate, owner: .receiver, timestamp: Int(Date().timeIntervalSince1970), isRead: false, date: date as String)
//                    items.append(message)
//                }
                

//                Message.send(message: message, toID: self.currentUser!.id, completion: {(_) in
//                })
                self.canSendLocation = false
            }
        }
    }

    
    
    // timeStamp formatter
    func timeStampTocurrentTimeConverter(timeStamp_: Int) -> NSString {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp_)/1000)//Double(timeStamp_)!/1000
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "hh:mm a" //Specify your format that you want //yyyy-MM-dd HH:mm
        let strDate = dateFormatter.string(from: date)
        return strDate as NSString
    }
  
    // date formatter
    func dateToTimeConverter(date: String) -> NSString {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
//        let myString = formatter.string(from: date as Date)
        // convert your string to date
        let yourDate = formatter.date(from: date)//myString
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "hh:mm a"//MMM-dd @hh:mm a
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
//        print(myStringafd)
        return myStringafd as NSString
        
    }
    
//    func caompareDateFormatter(dateStr: String) -> NSString {
//        let formatter = DateFormatter()
//        // initially set the format based on your datepicker date
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let date = NSDate() as Date
//
//        let myString = formatter.string(from: date as Date)
//        // convert your string to date
//        let yourDate = formatter.date(from: dateStr)//myString
//        //then again set the date format whhich type of output you need
//        formatter.dateFormat = "hh:mm a"//MMM-dd @hh:mm a
//        // again convert your date to string
//        let myStringafd = formatter.string(from: yourDate!)
//
//        //        print(myStringafd)
//        return myStringafd as NSString
//
//    }
    
    func dayDifferenceFrom(dateStr : NSString ,priSecDate : NSString) -> Bool
    {
        
        let formatter = DateFormatter()
        
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // convert your string to date
        let date = formatter.date(from: dateStr as String)//myString
        let priSecDte = formatter.date(from: priSecDate as String)//myString
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateStr1 = formatter.string(from: date!)
        let priSecDate1 = formatter.string(from: priSecDte!)

        let date1 = formatter.date(from: dateStr1 as String)//myString
        let priSecDte1 = formatter.date(from: priSecDate1 as String)//myString
    
        if date1 == priSecDte1 {
             return true
        }else{
            return false
        }
        
    }
    func dateFormatterWithDays(dateStr : NSString) -> NSString
    {
        let calendar = NSCalendar.current
        let formatter = DateFormatter()
        
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // convert your string to date
        let date = formatter.date(from: dateStr as String)//myString
        
        if calendar.isDateInYesterday(date!) { return "Yesterday" }
        else if calendar.isDateInToday(date!) { return "Today" }
        else if calendar.isDateInTomorrow(date!) { return "Tomorrow" }
        else {
            formatter.dateFormat = "dd MMM yyyy"
            return formatter.string(from: date!) as NSString
//            let startOfNow = calendar.startOfDay(for: Date())
//            let startOfTimeStamp = calendar.startOfDay(for: date!)
//            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
//            let day = components.day!
//            if day < 1 { return "\(abs(day)) days ago" as NSString }
//            else { return "In \(day) days" as NSString }
        }
        
    }
//    func displayImageOnFullScreen(image : UIImage) -> Void{
//        let imageFullView  = UIView.init()
//        imageFullView.frame = UIView(frame: CGRect(x: 0, y: 0, width:, height: ))
//
//        
//    }
    
    
    func currentDateToTimeConverter() -> NSString {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate() as Date

        let myString = formatter.string(from: date)
       
        return myString as NSString
        
    }
    //MARK: ViewController lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputBar.backgroundColor = UIColor.clear
        self.view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        Message.markMessagesRead(forUserID: self.currentUser!.id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
//        if indexPathRow == 3 {
//            self.fetchAllData()
////            self.fetchData()
////
//        }else if indexPathRow == 5 {
//            //            self.fetchAllData()
//            self.fetchSimpleChatDataData()
//
//        }else{
            self.fetchData()

//        }
    }
    
    
    
    func callPushNotificationAPI(text : String,token : String) {
 
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAA7UIJ0II:APA91bGreHloIQ53uHPyKWeHZxGMN2IIKZDU9oPq5bgeZ4jAU7cshvBelEHomsG7pY1-Smh6bUIKP9R3z24Nbnw9MIeUqv30fkLIvyQkPfeF7sjm9c4sLdaC1TEhxey5vv1ZzxUGuBht", forHTTPHeaderField: "Authorization")
        
//        5s = "diVm8rp6ajY:APA91bEs7_8ZMUGt71P-fLBYvKoP5J1RUf9Q2WzwWOL22DfM8yP67dvKuHhuAFVDIUFzdLL2gUZNaNReiVVvK4Vc19umM35dHG_ssmZivOd1xohUzY2y6S2D-4n5PmmMdFWpeDhHUBbS"
//        6s = eKg97eJVmVk:APA91bF9fgODg0XDrK5Gix7Yax5vXieDLeNqmiSGtwyA6vbqa_xVt9fICWx7cocEox99-7BSMti3uG64V-R-rcAq8pG22DazxpjcFSByiDpPxL1yg3KgwdDhpniYN5jLplXLI-nFRXiY
        request.httpMethod = "POST"
        let soapMessage = String.init(format: "{ \"data\": {\"title\" : \"you got New message from %@\",\"body\"  : \"%@\",\"icon\"  : \"not icon\"},\"notification\":  {\"title\" : \"You got New message from %@\",\"body\"  : \"%@\"},\"to\" : \"%@\"}",(currentUser?.name)!,text,(currentUser?.name)!,text,token)/////  \"sound\": \"default\",

        request.httpBody = soapMessage.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
      
 
    }
    
    /*
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.setToolbarHidden(true, animated: true)
                print("Hide")
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.setToolbarHidden(false, animated: true)
                print("Unhide")
            }, completion: nil)
        }
    }
*/
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     /*   activityIndicator.scrollViewDidScroll(scrollView: scrollView) {
            DispatchQueue.global(qos: .utility).async {
                for i in 0..<1 {
                    print("!!!!!!!!! \(i)")
                    sleep(1)
                }
                DispatchQueue.main.async {
                    //                    if self.reminders.count >= 10 {
//                    self.feathRemindersData(self.fetchOffSet)
//                    self.reminderTbl.reloadData()
                    //                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.loadMoreActionFinshed(scrollView: scrollView)
                }
            }
        }*/
    }
}


class LoadMoreActivityIndicator {
    
    let spacingFromLastCell: CGFloat
    let spacingFromLastCellWhenLoadMoreActionStart: CGFloat
    let activityIndicatorView: UIActivityIndicatorView
    weak var tableView: UITableView!
    
    private var defaultY: CGFloat {
        return tableView.contentSize.height + spacingFromLastCell
    }
    
    init (tableView: UITableView, spacingFromLastCell: CGFloat, spacingFromLastCellWhenLoadMoreActionStart: CGFloat) {
        self.tableView = tableView
        self.spacingFromLastCell = spacingFromLastCell
        self.spacingFromLastCellWhenLoadMoreActionStart = spacingFromLastCellWhenLoadMoreActionStart
        let size:CGFloat = 40
        let frame = CGRect(x: (tableView.frame.width-size)/2, y: tableView.contentSize.height + spacingFromLastCell, width: size, height: size)
        activityIndicatorView = UIActivityIndicatorView(frame: frame)
        activityIndicatorView.color = .black
        activityIndicatorView.isHidden = false
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        tableView.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = isHidden
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isHidden: Bool {
        if tableView.contentSize.height < tableView.frame.size.height {
            return true
        } else {
            return false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView, loadMoreAction: ()->()) {
        let offsetY = scrollView.contentOffset.y
        activityIndicatorView.isHidden = isHidden
        if !isHidden && offsetY >= 0 {
            let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
            let offsetDelta = offsetY - contentDelta
            
            let newY = defaultY-offsetDelta
            if newY < tableView.frame.height {
                activityIndicatorView.frame.origin.y = newY
            } else {
                if activityIndicatorView.frame.origin.y != defaultY {
                    activityIndicatorView.frame.origin.y = defaultY
                }
            }
            
            if !activityIndicatorView.isAnimating {
                if offsetY > contentDelta && offsetDelta >= spacingFromLastCellWhenLoadMoreActionStart && !activityIndicatorView.isAnimating {
                    activityIndicatorView.startAnimating()
                    loadMoreAction()
                }
            }
            
            if scrollView.isDecelerating {
                if activityIndicatorView.isAnimating && scrollView.contentInset.bottom == 0 {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        if let bottom = self?.spacingFromLastCellWhenLoadMoreActionStart {
                            scrollView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0)
                        }
                    }
                }
            }
        }
    }
    
    func loadMoreActionFinshed(scrollView: UIScrollView) {
        
        let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetDelta = scrollView.contentOffset.y - contentDelta
        if offsetDelta >= 0 {
            // Animate hiding when activity indicator displaying
            UIView.animate(withDuration: 0.3) {
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
        } else {
            // Hiding without animation when activity indicator displaying
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = false
    }
}


