//
//  Notification.swift
//  DemoPoppup
//
//  Created by gray buster on 6/23/18.
//  Copyright © 2018 gray buster. All rights reserved.
//

import Foundation

public struct NotificationPost:Codable {
    let Id: Int?
    let Title: String?
    let Message: String
    let Error: Bool
    let Object: String?
    
    private enum CodingKeys: String,CodingKey {
        case Id = "ID"
        case Title = "Title"
        case Message = "Message"
        case Error = "Error"
        case Object = "Object"
    }
}

struct Post:Codable {
    
    let body: String
    let id: Int
    let title: String
    let userId: Int
}
