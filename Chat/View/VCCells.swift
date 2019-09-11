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


import Foundation
import UIKit

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

class SenderCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: RoundedImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var messageBackground: UIImageView!
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var senderImgH: NSLayoutConstraint!
    @IBOutlet weak var senderImgW: NSLayoutConstraint!
    @IBOutlet weak var senderMessageW: NSLayoutConstraint!
    @IBOutlet weak var senderMessageH: NSLayoutConstraint!
    
    @IBOutlet weak var senderNL: UILabel!
    
    func clearCellData()  {
        self.message.text = nil
        self.timeL.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.senderImgH.constant = 250
            self.senderImgW.constant = 200
            self.senderMessageH.constant = 250
            self.senderMessageW.constant = 200

        }
//        self.message.isUserInteractionEnabled = false
        
       
        
//        self.layoutIfNeeded()

        
    }
    
    func setLongPressGestureForImage(message : Message) -> Void {
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        self.messageBackground.addGestureRecognizer(gestureRecognizer)
        self.messageBackground.isUserInteractionEnabled = true
    }
    
    // MARK: - UIGestureRecognizer
    @objc func handleLongPressGesture(_ recognizer: UIGestureRecognizer) {
        var frame : CGRect = messageBackground.frame
        frame.origin.x = (messageBackground.frame.size.width / 2) - 50
        frame.origin.y = 10
        frame.size.width = 100
        frame.size.height = 100

//        let targetRectangle = CGRect(x: 100, y: 0, width: 100, height: 100)
        UIMenuController.shared.setTargetRect(frame, in: self)
//        let menuItem = UIMenuItem(title: "Custom Action", action: #selector(self.customAction(_:)))
//        UIMenuController.shared.menuItems = [menuItem]
        UIMenuController.shared.setMenuVisible(true, animated: true)
      
    }

    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            var result = false
        if #selector(UIResponderStandardEditActions.copy(_:)) == action || #selector(SenderCell.customAction(_:)) == action {
                result = true
            }
            return result
        }
    
        // UIMenuController Methods
        // Default copy method
    @objc override func copy(_ sender: Any?) {
            print("Copy")
        }
    
//     Our custom method
    @objc func customAction(_ sender: Any?) {
        print("Custom Action")
    }
//
//
//    //3.Here we are enabling copy action
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return (action == #selector(UIResponderStandardEditActions.copy(_:)))
//
//    }
//    // MARK: - UIResponderStandardEditActions
//    override func copy(_ sender: Any?) {
//        //4.copy current Text to the paste board
//        UIPasteboard.general.string = "text"
//    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
////        let bgColorView = UIView()
////        bgColorView.backgroundColor = UIColor.init(red: 210/255, green: 235/255, blue: 152/255, alpha:1 )
////        self.selectedBackgroundView = bgColorView
//        // Configure the view for the selected state
//    }

}

class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var messageBackground: UIImageView!
    @IBOutlet weak var receiverImgH: NSLayoutConstraint!
    @IBOutlet weak var receiverImgW: NSLayoutConstraint!
    @IBOutlet weak var receiverMessageW: NSLayoutConstraint!
    @IBOutlet weak var receiverMessageH: NSLayoutConstraint!
    
    func clearCellData()  {
        self.message.text = nil
        self.timeL.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
//        250//300
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.receiverImgH.constant = 250
            self.receiverImgW.constant = 200
            self.receiverMessageH.constant = 250
            self.receiverMessageW.constant = 200
            
        }
        self.message.isUserInteractionEnabled = false
//        self.layoutIfNeeded()

    }
    
    func setLongPressGestureForImage(message : Message) -> Void {
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        self.messageBackground.addGestureRecognizer(gestureRecognizer)
        self.messageBackground.isUserInteractionEnabled = true
    }
    
    // MARK: - UIGestureRecognizer
    @objc func handleLongPressGesture(_ recognizer: UIGestureRecognizer) {
        
        var frame : CGRect = messageBackground.frame
        frame.origin.x = messageBackground.frame.origin.x + (messageBackground.frame.size.width / 2) - 50
        frame.origin.y = 10
        frame.size.width = 100
        frame.size.height = 100
        self.becomeFirstResponder()

        let showSaveItem = UIMenuItem(title: "Save", action: #selector(showPass(_:)))
        UIMenuController.shared.menuItems?.removeAll()
        UIMenuController.shared.menuItems = [showSaveItem]
        UIMenuController.shared.update()
        
//        if selected {
            let menu = UIMenuController.shared
            menu.menuItems?.removeAll()
        
            menu.setTargetRect(self.contentView.frame, in: self.contentView.superview!)
            menu.setMenuVisible(true, animated: true)
//        }
        
//        UIMenuController.shared.setTargetRect(frame, in: self)
//        UIMenuController.shared.setMenuVisible(true, animated: true)
//
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        var result = false
        if #selector(showPass(_:)) == action{
            result = true
        }
//        if #selector(UIResponderStandardEditActions.copy(_:)) == action || #selector(SenderCell.customAction(_:)) == action {
//            result = true
//        }
        return result
    }
    @objc func showPass(_ send:AnyObject){
        print("hello")
    }
   
    

    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
////        let bgColorView = UIView()
////        bgColorView.backgroundColor = UIColor.init(red: 0/255, green: 152/255, blue: 227/255, alpha:0.66 )//0098E3
////        self.selectedBackgroundView = bgColorView
//        
//        // Configure the view for the selected state
//    }

}

class ListCell: UITableViewCell {
    
    @IBOutlet weak var userIMG: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var detailL: UILabel!
    @IBOutlet weak var countL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    
    
    func clearCellData()  {
        self.titleL.text = nil
        self.detailL.text = nil
        self.countL.text = nil
//        self.message.isHidden = false
       // self.userIMG.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
//        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
//        self.messageBackground.layer.cornerRadius = 15
//        self.messageBackground.clipsToBounds = true
//        //        250//300
//        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
//            self.receiverImgH.constant = 250
//            self.receiverImgW.constant = 200
//            self.receiverMessageH.constant = 250
//            self.receiverMessageW.constant = 200
//            
//        }
        //        self.layoutIfNeeded()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //        let bgColorView = UIView()
        //        bgColorView.backgroundColor = UIColor.init(red: 0/255, green: 152/255, blue: 227/255, alpha:0.66 )//0098E3
        //        self.selectedBackgroundView = bgColorView
        
        // Configure the view for the selected state
    }
    
}

class MessageCell: UITableViewCell {
    
    var timeLabel: UILabel?
    var textView: UITextView?
    var bubbleImage: UIImageView?
    var message: Message?

    
//    func clearCellData()  {
//        self.timeLabel?.text = nil
//        self.textView?.text = ""
//        self.bubbleImage?.image = nil
//    }
    func height() -> Int {
        return Int(bubbleImage!.frame.size.height)
        
//        return bubbleImage!.frame.size.height
    }
//    func updateMessageStatus() {
//        buildCell()
//        //Animate Transition
//        statusIcon.alpha = 0
//        UIView.animate(withDuration: 0.5, animations: {() -> Void in
//            statusIcon.alpha = 1
//        })
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.selectionStyle = .none
        self.commonInit()
    }
    func commonInit() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.accessoryType = .none
        
        self.bubbleImage = UIImageView.init()
        self.textView = UITextView.init()
        self.timeLabel = UILabel.init()

//        self.timeLabel?.text = nil
//        self.textView?.text = ""
//        self.bubbleImage?.image = nil
//        self.contentView.addSubview(bubbleImage!)
//        self.contentView.addSubview(textView!)
//        self.contentView.addSubview(timeLabel!)

    }

    override func prepareForReuse() {
        super .prepareForReuse()
//        textView?.text = ""
//        timeLabel?.text = ""
//        bubbleImage?.image = nil
    }

    
    func setMessage(message : Message) -> Void {
        self.message = message
        buildCell()
//        message.heigh = self.height()
    }
    func buildCell() {
        bubbleImage?.removeFromSuperview()
        textView?.removeFromSuperview()
        timeLabel?.removeFromSuperview()

        self.setTextView()
        self.setTimeLabel()
        self.setBubble()
        
        textView?.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(bubbleImage!)
        self.contentView.addSubview(textView!)
        self.contentView.addSubview(timeLabel!)
        textView?.isUserInteractionEnabled = false
//        textView?.isHidden = false
//        timeLabel?.isHidden = false
//        bubbleImage?.isHidden = false

        self.setNeedsLayout()
    }
    
   // #pragma mark - TextView
    func setTextView() {
        let max_witdh : CGFloat = 0.7 * self.contentView.frame.size.width
        let max_height : CGFloat = CGFloat(MAXFLOAT)
        let max_heightINT : Int = Int(MAXFRAG)
        textView = UITextView(frame: CGRect(x: 0, y: 0, width:Int(max_witdh), height: Int(MAXFRAG)))
        
        textView?.font = UIFont(name:"Helvetica", size: 17.0)
        textView?.backgroundColor = UIColor.clear
        textView?.isUserInteractionEnabled = false
        textView?.text = self.message?.content as! String
        textView?.sizeToFit()
        
        var textView_x : CGFloat = 0
        var textView_y : CGFloat = 0
        let textView_w : CGFloat = (textView?.frame.size.width)!
        let textView_h : CGFloat = (textView?.frame.size.height)!
        var autoresizing = UIViewAutoresizing(rawValue: 0)
        
        
        
        switch self.message?.owner {
        case .timeHeader?:
            break
          
        case .receiver?:
            
            textView_x = self.contentView.frame.size.width - textView_w - 20
            textView_y = -3
            autoresizing = .flexibleLeftMargin
            textView_x -= self.isSingleLineCase() ? 65.0 : 0.0

            break
        
        case .sender?:
            
           
                textView_x = 20;
                textView_y = -1;
                autoresizing = .flexibleRightMargin

               
            break

        case .none:
            break
            
        }
        
        
        textView?.autoresizingMask = autoresizing;
        self.textView = UITextView(frame: CGRect(x: Int(textView_x), y: Int(textView_y), width:Int(textView_w), height: Int(textView_h)))
//        self.contentView.addSubview(textView!)

        print(textView_h)
    }
 //   #pragma mark - TimeLabel
    func setTimeLabel() {
        timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width:52, height:14))
        timeLabel?.textColor = UIColor.lightGray
        timeLabel?.font = UIFont(name:"Helvetica", size: 12.0)
        timeLabel?.isUserInteractionEnabled = false
        timeLabel?.alpha = 0.7
        timeLabel?.textAlignment = NSTextAlignment.right
        
        //Set Text to Label
//        let formatter = DateFormatter()
//        formatter.dateStyle = DateFormatter.Style.none
//        formatter.timeStyle = DateFormatter.Style.short
//        formatter.doesRelativeDateFormatting = true
        self.timeLabel?.text = self.dateToTimeConverter(date: (message?.date)!) as String
        //Set position
        
        var time_x : CGFloat = 0
        var time_y : CGFloat = textView!.frame.size.height - 10
        switch self.message?.owner {
        case .timeHeader?:
            break
            
        case .receiver?:
            time_x = (textView?.frame.origin.x)! + (textView?.frame.size.width)! - (timeLabel?.frame.size.width)! - 20;

            break
            
        case .sender?:
            time_x = max((textView?.frame.origin.x)! + (textView?.frame.size.width)! - (timeLabel?.frame.size.width)!, (textView?.frame.origin.x)!)

            break
            
        case .none:
            break
            
        }
        
        if isSingleLineCase() {
            time_x = (textView?.frame.origin.x)! + (textView?.frame.size.width)! - 5;
            time_y -= 10;
        }
        let frameTL : CGRect =  CGRect(x: time_x, y: time_y, width:timeLabel!.frame.size.width, height:timeLabel!.frame.size.height)
        timeLabel?.frame = frameTL
        timeLabel?.autoresizingMask = (textView?.autoresizingMask)!;
       // print(time_x)
       
//        self.contentView.addSubview(timeLabel!)

    }
    func dateToTimeConverter(date: String) -> NSString {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let yourDate = formatter.date(from: date)//myString
        formatter.dateFormat = "hh:mm a"//MMM-dd @hh:mm a
        let myStringafd = formatter.string(from: yourDate!)
        
        return myStringafd as NSString
        
    }
    
    func isSingleLineCase() -> Bool {
        var delta_x : CGFloat = 65.0
        switch self.message?.owner {
        case .timeHeader?:
            break
        case .receiver?:
             delta_x = 65.0
            break
        case .sender?:
             delta_x = 44.0
            break
            
        case .none:
            break
            
        }
        let textView_height: CGFloat = textView!.frame.size.height
        let textView_width: CGFloat = textView!.frame.size.width
        let view_width: CGFloat = contentView.frame.size.width
        //Single Line Case
        return (textView_height <= 45 && textView_width + delta_x <= 0.8 * view_width) ? true : false

    }
   // #pragma mark - Bubble
    
    func setBubble(){
        //Margins to Bubble
        let marginLeft: CGFloat = 5
        let marginRight: CGFloat = 2
        //Bubble positions
        var bubble_x: CGFloat = 0.0
        let bubble_y: CGFloat = 0
        var bubble_width: CGFloat = 0.0
        var bubble_height: CGFloat = min((textView?.frame.size.height)! + 8, (timeLabel?.frame.origin.y)! + (timeLabel?.frame.size.height)! + 6)
       
        switch self.message?.owner {
        case .timeHeader?:
            break
        case .receiver?:
            
            
            switch self.message?.type {
            case .text?:
                bubble_x = min((textView?.frame.origin.x)! - marginLeft, (timeLabel?.frame.origin.x)! - 2 * marginLeft)
                let image: UIImage = UIImage(named: "BubbleOutgoing")!
                bubbleImage?.image = image.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                //            self.bubbleImage?.image = self.imageNamed(imageName: "bubbleSomeone").stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                bubble_width = self.contentView.frame.size.width - bubble_x - marginRight
                //            bubble_width -=
                break
            case .photo?:
                
                bubble_x = min((textView?.frame.origin.x)! - marginLeft, (timeLabel?.frame.origin.x)! - 2 * marginLeft)
                let image: UIImage = UIImage(named: "BubbleOutgoing")!
                bubbleImage?.image = image.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                //            self.bubbleImage?.image = self.imageNamed(imageName: "bubbleSomeone").stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                bubble_width = self.contentView.frame.size.width - bubble_x - marginRight - 10
//                bubble_height = bubble_height - 10 //for image
                bubbleImage?.layer.cornerRadius = 5
                bubbleImage?.clipsToBounds = true

                //            bubble_width -=
                break
            
            case .some(.location):
                break
            case .none:
                break
            }
            
            
        case .sender?:

            
            switch self.message?.type {
            case .text?:
                bubble_x = marginRight
                let image: UIImage = UIImage(named: "BubbleIncoming")!
                bubbleImage?.image = image.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                
                //            bubbleImage?.image = self.imageNamed(imageName: "bubbleMine").stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                bubble_width = max((textView?.frame.origin.x)! + (textView?.frame.size.width)! + marginLeft, (timeLabel?.frame.origin.x)! + (timeLabel?.frame.size.width)! + 2 * marginLeft)
                break
            case .photo?:
                
                bubble_x = marginRight + 10
                let image: UIImage = UIImage(named: "BubbleIncoming")!
                bubbleImage?.image = image.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                
                //            bubbleImage?.image = self.imageNamed(imageName: "bubbleMine").stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                bubble_width = max((textView?.frame.origin.x)! + (textView?.frame.size.width)! + marginLeft, (timeLabel?.frame.origin.x)! + (timeLabel?.frame.size.width)! + 2 * marginLeft) - 10
                bubbleImage?.clipsToBounds = true
//                bubble_height = bubble_height - 10 //for image

                bubbleImage?.layer.cornerRadius = 5
                //            bubble_width -=
                break
                
            case .some(.location):
                break
            case .none:
                break
            }
            
           
            
        case .none:
            break
            
        }

        let frameTL : CGRect =  CGRect(x: bubble_x, y: bubble_y, width:bubble_width, height: bubble_height)
        message?.heigh = bubble_height
        self.bubbleImage?.frame = frameTL
        self.bubbleImage?.autoresizingMask = (textView?.autoresizingMask)!;
        print(bubble_height)
//        self.contentView.addSubview(bubbleImage!)
     
        

    }

  //  #pragma mark - UIImage Helper
    func imageNamed(imageName : String) -> UIImage {
        return UIImage(named: imageName, in: Bundle(for: type(of: self)), compatibleWith: nil)!
    }

    
}



class GroupSenderCell: UITableViewCell {
    
    var timeLabel: UILabel?
    var nameLabel: UILabel?
    var textView: UITextView?
    var bubbleImage: UIImageView?
    var message: Message?
    
    
    //    func clearCellData()  {
    //        self.timeLabel?.text = nil
    //        self.textView?.text = ""
    //        self.bubbleImage?.image = nil
    //    }
    func height() -> Int {
        return Int(bubbleImage!.frame.size.height)
        
        //        return bubbleImage!.frame.size.height
    }
    //    func updateMessageStatus() {
    //        buildCell()
    //        //Animate Transition
    //        statusIcon.alpha = 0
    //        UIView.animate(withDuration: 0.5, animations: {() -> Void in
    //            statusIcon.alpha = 1
    //        })
    //    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.selectionStyle = .none
        self.commonInit()
    }
    func commonInit() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.accessoryType = .none
        
        self.bubbleImage = UIImageView.init()
        self.textView = UITextView.init()
        self.timeLabel = UILabel.init()
        self.nameLabel = UILabel.init()

        //        self.timeLabel?.text = nil
        //        self.textView?.text = ""
        //        self.bubbleImage?.image = nil
        //        self.contentView.addSubview(bubbleImage!)
        //        self.contentView.addSubview(textView!)
        //        self.contentView.addSubview(timeLabel!)
        
    }
    
    override func prepareForReuse() {
        super .prepareForReuse()
        //        textView?.text = ""
        //        timeLabel?.text = ""
        //        bubbleImage?.image = nil
    }
    
    
    func setMessage(message : Message) -> Void {
        self.message = message
        buildCell()
        //        message.heigh = self.height()
    }
    func buildCell() {
        bubbleImage?.removeFromSuperview()
        textView?.removeFromSuperview()
        timeLabel?.removeFromSuperview()
        nameLabel?.removeFromSuperview()

        self.setTextView()
        self.setTimeLabel()
        self.setBubble()
        self.setName()

        textView?.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(bubbleImage!)
        self.contentView.addSubview(textView!)
        self.contentView.addSubview(timeLabel!)
        self.contentView.addSubview(nameLabel!)

        textView?.isUserInteractionEnabled = false
        //        textView?.isHidden = false
        //        timeLabel?.isHidden = false
        //        bubbleImage?.isHidden = false
        
        self.setNeedsLayout()
    }
    
    // #pragma mark - NameLabel
    func setName() {
        let max_witdh : CGFloat = 0.7 * self.contentView.frame.size.width
        nameLabel = UILabel(frame: CGRect(x: 20, y: 4, width:Int(max_witdh), height:14))
        nameLabel?.textColor = UIColor.darkGray
        nameLabel?.font = UIFont(name:"Helvetica", size: 13.0)
        nameLabel?.isUserInteractionEnabled = false
        nameLabel?.alpha = 1.0
        nameLabel?.textAlignment = NSTextAlignment.left
        
    }
    // #pragma mark - TextView
    func setTextView() {
        let max_witdh : CGFloat = 0.7 * self.contentView.frame.size.width
        let max_height : CGFloat = CGFloat(MAXFLOAT)
        let max_heightINT : Int = Int(MAXFRAG)
        textView = UITextView(frame: CGRect(x: 0, y: 0, width:Int(max_witdh), height: Int(MAXFRAG)))
        
        textView?.font = UIFont(name:"Helvetica", size: 17.0)
        textView?.backgroundColor = UIColor.clear
        textView?.isUserInteractionEnabled = false
        textView?.text = self.message?.content as! String
        textView?.sizeToFit()
        
        var textView_x : CGFloat = 0
        var textView_y : CGFloat = 0
        let textView_w : CGFloat = (textView?.frame.size.width)!
        let textView_h : CGFloat = (textView?.frame.size.height)!
        var autoresizing = UIViewAutoresizing(rawValue: 0)
        
        
        
        switch self.message?.owner {
        case .timeHeader?:
            break
            
        case .receiver?:
            
            textView_x = self.contentView.frame.size.width - textView_w - 20
            textView_y = -3
            autoresizing = .flexibleLeftMargin
            textView_x -= self.isSingleLineCase() ? 65.0 : 0.0
            
            break
            
        case .sender?:
            
            
            textView_x = 20;
            textView_y = 14;//-1 //name add
            autoresizing = .flexibleRightMargin
            
            
            break
            
        case .none:
            break
            
        }
        
        
        textView?.autoresizingMask = autoresizing;
        self.textView = UITextView(frame: CGRect(x: Int(textView_x), y: Int(textView_y), width:Int(textView_w), height: Int(textView_h)))
        //        self.contentView.addSubview(textView!)
        
        print(textView_h)
    }
    //   #pragma mark - TimeLabel
    func setTimeLabel() {
        timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width:52, height:14))
        timeLabel?.textColor = UIColor.lightGray
        timeLabel?.font = UIFont(name:"Helvetica", size: 12.0)
        timeLabel?.isUserInteractionEnabled = false
        timeLabel?.alpha = 0.7
        timeLabel?.textAlignment = NSTextAlignment.right
        
        //Set Text to Label
        //        let formatter = DateFormatter()
        //        formatter.dateStyle = DateFormatter.Style.none
        //        formatter.timeStyle = DateFormatter.Style.short
        //        formatter.doesRelativeDateFormatting = true
        self.timeLabel?.text = self.dateToTimeConverter(date: (message?.date)!) as String
        //Set position
        
        var time_x : CGFloat = 0
        var time_y : CGFloat = textView!.frame.size.height - 10
        switch self.message?.owner {
        case .timeHeader?:
            break
            
        case .receiver?:
            time_x = (textView?.frame.origin.x)! + (textView?.frame.size.width)! - (timeLabel?.frame.size.width)! - 20;
            
            break
            
        case .sender?:
            time_x = max((textView?.frame.origin.x)! + (textView?.frame.size.width)! - (timeLabel?.frame.size.width)!, (textView?.frame.origin.x)!)
            time_y  = textView!.frame.size.height - 10 + 12// 14 <= for name label

            break
            
        case .none:
            break
            
        }
        
        if isSingleLineCase() {
            time_x = (textView?.frame.origin.x)! + (textView?.frame.size.width)! - 5;
            time_y -= 10;
        }
        let frameTL : CGRect =  CGRect(x: time_x, y: time_y, width:timeLabel!.frame.size.width, height:timeLabel!.frame.size.height)
        timeLabel?.frame = frameTL
        timeLabel?.autoresizingMask = (textView?.autoresizingMask)!;
        // print(time_x)
        
        //        self.contentView.addSubview(timeLabel!)
        
    }
    func dateToTimeConverter(date: String) -> NSString {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let yourDate = formatter.date(from: date)//myString
        formatter.dateFormat = "hh:mm a"//MMM-dd @hh:mm a
        let myStringafd = formatter.string(from: yourDate!)
        
        return myStringafd as NSString
        
    }
    
    func isSingleLineCase() -> Bool {
        var delta_x : CGFloat = 65.0
        switch self.message?.owner {
        case .timeHeader?:
            break
        case .receiver?:
            delta_x = 65.0
            break
        case .sender?:
            delta_x = 44.0
            break
            
        case .none:
            break
            
        }
        let textView_height: CGFloat = textView!.frame.size.height
        let textView_width: CGFloat = textView!.frame.size.width
        let view_width: CGFloat = contentView.frame.size.width
        //Single Line Case
        return (textView_height <= 45 && textView_width + delta_x <= 0.8 * view_width) ? true : false
        
    }
    // #pragma mark - Bubble
    
    func setBubble(){
        //Margins to Bubble
        let marginLeft: CGFloat = 5
        let marginRight: CGFloat = 2
        //Bubble positions
        var bubble_x: CGFloat = 0.0
        let bubble_y: CGFloat = 0
        var bubble_width: CGFloat = 0.0
        let bubble_height: CGFloat = min((textView?.frame.size.height)! + 8 + 12, (timeLabel?.frame.origin.y)! + (timeLabel?.frame.size.height)! + 6 + 10)
        
        switch self.message?.owner {
        case .timeHeader?:
            break
        case .receiver?:
            
            
            switch self.message?.type {
            case .text?:
                bubble_x = min((textView?.frame.origin.x)! - marginLeft, (timeLabel?.frame.origin.x)! - 2 * marginLeft)
                let image: UIImage = UIImage(named: "BubbleOutgoing")!
                bubbleImage?.image = image.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                //            self.bubbleImage?.image = self.imageNamed(imageName: "bubbleSomeone").stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                bubble_width = self.contentView.frame.size.width - bubble_x - marginRight
                //            bubble_width -=
                break
            case .photo?:
                
                bubble_x = min((textView?.frame.origin.x)! - marginLeft, (timeLabel?.frame.origin.x)! - 2 * marginLeft)
                let image: UIImage = UIImage(named: "BubbleOutgoing")!
                bubbleImage?.image = image.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                //            self.bubbleImage?.image = self.imageNamed(imageName: "bubbleSomeone").stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                bubble_width = self.contentView.frame.size.width - bubble_x - marginRight - 10
                //                bubble_height = bubble_height - 10 //for image
                bubbleImage?.layer.cornerRadius = 5
                bubbleImage?.clipsToBounds = true
                
                //            bubble_width -=
                break
                
            case .some(.location):
                break
            case .none:
                break
            }
            
            
        case .sender?:
            
            
            switch self.message?.type {
            case .text?:
                bubble_x = marginRight
                let image: UIImage = UIImage(named: "BubbleIncoming")!
                bubbleImage?.image = image.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                
                //            bubbleImage?.image = self.imageNamed(imageName: "bubbleMine").stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                bubble_width = max((textView?.frame.origin.x)! + (textView?.frame.size.width)! + marginLeft, (timeLabel?.frame.origin.x)! + (timeLabel?.frame.size.width)! + 2 * marginLeft)
                break
            case .photo?:
                
                bubble_x = marginRight + 10
                let image: UIImage = UIImage(named: "BubbleIncoming")!
                bubbleImage?.image = image.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                
                //            bubbleImage?.image = self.imageNamed(imageName: "bubbleMine").stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
                bubble_width = max((textView?.frame.origin.x)! + (textView?.frame.size.width)! + marginLeft, (timeLabel?.frame.origin.x)! + (timeLabel?.frame.size.width)! + 2 * marginLeft) - 10
                bubbleImage?.clipsToBounds = true
                //                bubble_height = bubble_height - 10 //for image
                
                bubbleImage?.layer.cornerRadius = 5
                //            bubble_width -=
                break
                
            case .some(.location):
                break
            case .none:
                break
            }
            
            
            
        case .none:
            break
            
        }
        
        let frameTL : CGRect =  CGRect(x: bubble_x, y: bubble_y, width:bubble_width, height: bubble_height)
        message?.heigh = bubble_height
        self.bubbleImage?.frame = frameTL
        self.bubbleImage?.autoresizingMask = (textView?.autoresizingMask)!;
        print(bubble_height)
        //        self.contentView.addSubview(bubbleImage!)
        
        
        
    }
    
    //  #pragma mark - UIImage Helper
    func imageNamed(imageName : String) -> UIImage {
        return UIImage(named: imageName, in: Bundle(for: type(of: self)), compatibleWith: nil)!
    }
    
    
}

/*
 class ConversationsTBCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func clearCellData()  {
        self.nameLabel.font = UIFont(name:"AvenirNext-Regular", size: 17.0)
        self.messageLabel.font = UIFont(name:"AvenirNext-Regular", size: 14.0)
        self.timeLabel.font = UIFont(name:"AvenirNext-Regular", size: 13.0)
        self.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
        self.messageLabel.textColor = UIColor.rbg(r: 111, g: 113, b: 121)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePic.layer.borderWidth = 2
        self.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
    }
    
}

class ContactsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var profilePic: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
*/



