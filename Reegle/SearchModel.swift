//
//  SearchModel.swift
//  Reegle
//
//  Created by Kevin Dion on 2020-08-09.
//  Copyright © 2020 redbastie. All rights reserved.
//

import SwiftUI
import Combine

class SearchModel: ObservableObject {
    @Published var query: String = "" {
        didSet {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let url = URL(string: "https://suggestqueries.google.com/complete/search?client=chrome&q=" + encodedQuery!)
            let request = URLRequest(url: url!)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! NSArray
                    
                    DispatchQueue.main.async {
                        self.suggestedQueries = json[1] as! [String]
                    }
                } catch {
                    //
                }
            }.resume()
        }
    }
    @Published var suggestedQueries: [String] = []
}
