//
//  LeaderBoardManager.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 29/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import UIKit

class LeaderBoardManager {
    static let sharedInstance = LeaderBoardManager()
    private init() {}
    let domainName = "https://catgamebackend.appspot.com/"
    
    func postScore(_ score: Int, level: Int) {
        print("Attempting to post score")
        var request = URLRequest(url: URL(string: domainName + "new/level/\(level)")!)
        request.httpMethod = "POST"
        let nickname = UserData.shared.nickName
        let postString = "nickname=\(nickname)&score=\(score)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error ?? "no error" as! Error)")
                return
            }
    
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
            }
    
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    func highScoreForLevel(_ level: Int, completion: @escaping ([[String:Any]]?) -> Void) {
        let urlString = domainName + "score/level/\(level)"
        
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json)
                
                guard let highScoreArray = json as? [[String: Any]] else {
                    fatalError("We couldn't cast the JSON to an array of dictionaries")
                }
                
                completion(highScoreArray)
                
            } catch {
                print("error serializing JSON: \(error)")
                
                completion(nil)
            }

        })
        
        task.resume()
    }
    
    
//    func postJson() {
//        let data = ActionTracker.tracker.getData()
//        let url = URL(string: "https://usertracker-164618.appspot.com/")!
//        //let url = URL(string: "http:localhost:8080")!
//        let session = URLSession.shared
//        var request = URLRequest(url: url)
//        
//        request.httpMethod = "POST"
//        request.addValue("/json/", forHTTPHeaderField: "Content-Type")
//        request.addValue("/json/", forHTTPHeaderField: "Accept")
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//            request.httpBody = jsonData
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        let task = session.dataTask(with: request as URLRequest,
//                                    completionHandler: { data, response, error in
//                                        //print(response!)
//                                        //print(data!)
//        })
//        task.resume()
//    }
//    
//    func jsonToData(jsonData: Data) {
//        
//        do {
//            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
//            guard let issues = json as? [String: AnyObject] else {
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                return
//            }
//            for (key, _) in issues {
//                print("\(key)")
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//    }
//    
//    func getJson(data: [String:Any]) {
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//            print(" This is Json data:")
//            jsonToData(jsonData: jsonData)
//            
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
}

//func simplePost() {
//    var request = URLRequest(url: URL(string: "https://usertracker-164618.appspot.com")!)
//    request.httpMethod = "POST"
//    let postString = "name=isabel&username=ijlee"
//    request.httpBody = postString.data(using: .utf8)
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        guard let data = data, error == nil else {                                                 // check for fundamental networking error
//            //print("error=\(error)")
//            return
//        }
//
//        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//            print("statusCode should be 200, but is \(httpStatus.statusCode)")
//            //print("response = \(response)")
//        }
//
//        let responseString = String(data: data, encoding: .utf8)
//        print("responseString = \(String(describing: responseString))")
//    }
//    task.resume()
//}
