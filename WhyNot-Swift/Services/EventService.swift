//
//  EventService.swift
//  WhyNot-Swift
//
//  Created by Nassim Morouche on 15/05/2019.
//  Copyright © 2019 Nassim Morouche. All rights reserved.
//

import Foundation
import Alamofire

public class EventService {
    
    public static let `default` = EventService()
    private let baseurl: String
    private init(){
        self.baseurl = "http://localhost:3000/events"
    }
    let headers: HTTPHeaders = [
        "x-access-token": Session.default.token,
        "Content-Type": "application/json"
    ]
    
    public func getEvents(completion: @escaping ([Event]) -> Void) {
        Alamofire.request(baseurl + "/", headers: headers).responseJSON { (res) in
            guard let result = res.value as? [String:Any],
                let events = result["events"] as? [[String:Any]] else { return }
            let eventsResult = events.compactMap({ (elem) -> Event? in
                return Event(json: elem)
            })
            completion(eventsResult)
        }
    }
    
    public func insertEvent(params: [String:Any],completion: @escaping (Int) -> Void) {
        Alamofire.request(baseurl + "/", method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (res) in
            guard let code = res.result.value as? [String:Any],
                let statusCode = res.response?.statusCode else { return }
            if(statusCode == 200) {
                completion(statusCode)
            } else {
                guard let error = code["error"] as? String else { return }
                completion(statusCode)
            }
        }
    }
    
    public func editEvent(title:String,date:String,adress:String,image:String,description:String,completion: @escaping (Any) -> Void) {
        let param = [
            "title":title,
            "description":description,
            "date":date,
            "adress":adress,
            "image":image
        ]
        Alamofire.request(baseurl + "/",method: .post,parameters: param,encoding: JSONEncoding.default, headers: headers).responseJSON { (res) in
            guard let code = res.result.value as? [String:Any] else {return}
            let result = code["error"]
            completion(result)
        }
    }

}
