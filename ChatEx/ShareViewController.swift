//
//  ShareViewController.swift
//  ChatEx
//
//  Created by Niid tech on 06/07/18.
//  Copyright © 2018 NiidTechnology. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController,UITableViewDelegate {

//    @IBOutlet weak var tableView: UITableView!
//    override func isContentValid() -> Bool {
//        // Do validation of contentText and/or NSExtensionContext attachments here
//        return true
//    }
//
//    @IBAction func pressCancelB(_ sender: Any) {
//    }
//    //MARK: Delegates
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    private func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
//       
//        return cell
//    }
    
    
    override func didSelectPost() {
        if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem{
            for ele in item.attachments!{
                let itemProvider = ele as! NSItemProvider
                
                if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg") {
                    itemProvider.loadItem(forTypeIdentifier: "public.jpeg", options: nil, completionHandler: { (item, error) in
                        
                        do {
                            var imgData: Data!
                            if let url = item as? URL{
                                imgData = try Data(contentsOf: url)
                            }
                            
                            if let img = item as? UIImage{
                                imgData = UIImagePNGRepresentation(img)
                            }
                            
                            let dict: [String : Any] = ["imgData" :  imgData, "name" : self.contentText]
                            let userDefault = UserDefaults(suiteName: "group.ChatAppDemo")
                            userDefault?.set(dict, forKey: "img")
                            userDefault?.synchronize()
                        }catch let err{
                            print(err)
                        }
                    })
                }else if itemProvider.hasItemConformingToTypeIdentifier("public.png") {
                    itemProvider.loadItem(forTypeIdentifier: "public.png", options: nil, completionHandler: { (item, error) in
                        
                        do {
                            var imgData: Data!
                            if let url = item as? URL{
                                imgData = try Data(contentsOf: url)
                            }
                            
                            if let img = item as? UIImage{
                                imgData = UIImagePNGRepresentation(img)
                            }
                            
                            let dict: [String : Any] = ["imgData" :  imgData, "name" : self.contentText]
                            let userDefault = UserDefaults(suiteName: "group.ChatAppDemo")
                            userDefault?.set(dict, forKey: "img")
                            userDefault?.synchronize()
                        }catch let err{
                            print(err)
                        }
                    })
                }
            
            }
        }
        
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
