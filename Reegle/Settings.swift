//
//  Settings.swift
//  Reegle
//
//  Created by Kevin Dion on 2020-08-12.
//  Copyright © 2020 redbastie. All rights reserved.
//

import SwiftUI

class Settings: ObservableObject {
    @Published var queryHistories: [String] {
        didSet {
            UserDefaults.standard.set(queryHistories, forKey: "queryHistories")
        }
    }
    @Published var openResultsWith: String {
        didSet {
            UserDefaults.standard.set(openResultsWith, forKey: "openResultsWith")
        }
    }
    
    init() {
        self.queryHistories = UserDefaults.standard.array(forKey: "queryHistories") as? [String] ?? []
        self.openResultsWith = UserDefaults.standard.string(forKey: "openResultsWith") ?? "Safari"
    }
}
