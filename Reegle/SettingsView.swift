//
//  SettingsView.swift
//  Reegle
//
//  Created by Kevin Dion on 2020-08-09.
//  Copyright © 2020 redbastie. All rights reserved.
//

import SwiftUI
//import StoreKit

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) private var presentationMode
    let openResultsWithOptions = ["Safari", "Reddit", "Apollo"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $settings.openResultsWith, label: Text("Open Results With")) {
                        ForEach(openResultsWithOptions, id: \.self) { openResultsWithOption in
                            Text(openResultsWithOption).tag(openResultsWithOption)
                        }
                    }
                }
//                Section {
//                    Button(action: {
//                        SKStoreReviewController.requestReview()
//                    }, label: {
//                        Text("Review This App")
//                    })
//                    Button(action: {
//                        //
//                    }, label: {
//                        Text("Tip The Developer")
//                    })
//                }
                Section {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                    })
                }
                Section {
                    Button(action: {
                        self.settings.queryHistories.removeAll()
                    }, label: {
                        HStack {
                            Text("Clear Search History").foregroundColor(.red)
                            Spacer()
                            Text(String(self.settings.queryHistories.count)).foregroundColor(.secondary)
                        }
                    })
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}
