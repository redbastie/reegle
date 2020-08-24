//
//  ResultItem.swift
//  Reegle
//
//  Created by Kevin Dion on 2020-08-12.
//  Copyright © 2020 redbastie. All rights reserved.
//

import SwiftUI

struct ResultItem: Equatable {
    var link: String
    var title: String
    var snippet: String
    
    func subreddit() -> String {
        let array = self.link.components(separatedBy: "/")
        
        return "r/" + array[4]
    }
    
    func replacedLink(_ openResultsWith: String) -> String {
        if (openResultsWith == "Reddit") {
            return self.link.replacingOccurrences(of: "https://", with: "reddit://")
        }
        else if (openResultsWith == "Apollo") {
            return self.link.replacingOccurrences(of: "https://", with: "apollo://")
        }
        
        return self.link
    }
}
