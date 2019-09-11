//
//  ServerAPIRequest.swift
//  Golf
//
//  Created by Niid tech on 26/02/18.
//  Copyright © 2018 NiidTechnology. All rights reserved.
//

import Foundation
class ServerAPIRequest
{
    
   
    func httpPostConnectionWithURL(urlString: String, parameter: String, completion: @escaping (_ success: [String : AnyObject],NSData,Int) -> Void) {
  
//      let urlString = "https://fcm.googleapis.com/v1/project/simplehat-d9561/messages:send HTTP/1.1"
        let url = NSURL(string: "https://fcm.googleapis.com/v1/project/simplehat-d9561/messages:send")
        
        let theRequest = NSMutableURLRequest(url: url! as URL)
        
        let msgLength = String(parameter.characters.count)
        
        theRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        theRequest.addValue("application/json", forHTTPHeaderField: "Accept")
//        theRequest.setValue("Bearer AIzaSyBP1gzO0pY4geYW9B6r9mi_tjgnI5p_kwU", forHTTPHeaderField: "Authorization")

        theRequest.setValue("AAAA7UIJ0II:APA91bGreHloIQ53uHPyKWeHZxGMN2IIKZDU9oPq5bgeZ4jAU7cshvBelEHomsG7pY1-Smh6bUIKP9R3z24Nbnw9MIeUqv30fkLIvyQkPfeF7sjm9c4sLdaC1TEhxey5vv1ZzxUGuBht", forHTTPHeaderField: "Authorization")//Bearer
        
//        Authorization: Bearer <valid Oauth 2.0 token for the service account of the Firebase project>

        theRequest.httpMethod = "POST"
        theRequest.httpBody = parameter.data(using: .utf8)

        let session = URLSession.shared
        //        var err: NSError?
        do
        {
            let task = session.dataTask(with: theRequest as URLRequest, completionHandler: {data, response, error -> Void in
                var statusCode : Int = 0
                if let httpResponse = response as? HTTPURLResponse {
                     statusCode = httpResponse.statusCode
                    print("Status code: (\(httpResponse.statusCode))")
                }
                
                if error != nil
                {
                    print("*****error \(String(describing: error))")
                    let responseString : [String : AnyObject] = [:]
                    completion(responseString,data! as NSData,statusCode)
                    
                }else{
                    if(data != nil)
                    {
//                        let responseString  = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
                        let responseString : [String : AnyObject] = [:]
                        completion(responseString,data! as NSData,statusCode)
                    }else{
                        let responseString : [String : AnyObject] = [:]
                        completion(responseString,data! as NSData,statusCode)
                        
//                        error
//                        let responseString  = nil
//                        completion(responseString)
                    }
                    
                }
                
            })
            task.resume()
        }
    }
    
    
    
    // only for testing
    func getDataFromJson(url: String, parameter: String, completion: @escaping (_ success: [String : AnyObject]) -> Void) {
        
        //@escaping...If a closure is passed as an argument to a function and it is invoked after the function returns, the closure is @escaping.
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString = parameter
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { Data, response, error in
            
            guard let data = Data, error == nil else {  // check for fundamental networking error
                
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {  // check for http errors
                
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print(response!)
                return
                
            }
            
            let responseString  = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
            completion(responseString)
            
            
            
        }
        task.resume()
    }
    
}


