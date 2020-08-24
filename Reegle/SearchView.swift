//
//  SearchView.swift
//  Reegle
//
//  Created by Kevin Dion on 2020-08-09.
//  Copyright © 2020 redbastie. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var settings: Settings
    @ObservedObject var searchModel = SearchModel()
    @ObservedObject private var keyboardObserver = KeyboardObserver()
    @State var showResults: Bool = false
    @State var showSettings: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                        
                        SearchTextField(text: $searchModel.query, showResults: $showResults)
                            .frame(height: 40)
                        
                        if (searchModel.query != "") {
                            Button(action: {
                                self.searchModel.query = ""
                            }, label: {
                                Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
                                    .frame(width: 40, height: 40)
                            })
                        }
                    }
                    .padding(.leading, 12)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .padding()
                
                NavigationLink(destination: ResultView(query: searchModel.query), isActive: $showResults) {
                    EmptyView()
                }
                
                if (searchModel.query == "") {
                    if (settings.queryHistories.isEmpty) {
                        VStack {
                            Spacer()
                            
                            Image(systemName: "tray")
                                .font(.system(size: 32))
                                .foregroundColor(.secondary)
                                .padding(.bottom)
                            
                            Text("Your search history is empty.")
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        .padding(.bottom, keyboardObserver.keyboardHeight)
                        .animation(.easeInOut(duration: 0.3))
                    }
                    else {
                        List(settings.queryHistories, id: \.self) { queryHistory in
                            NavigationLink(destination: ResultView(query: queryHistory)) {
                                Text(queryHistory)
                            }
                        }
                        .padding(.bottom, keyboardObserver.keyboardHeight)
                        .animation(.easeInOut(duration: 0.3))
                    }
                }
                else {
                    List(searchModel.suggestedQueries, id: \.self) { suggestedQuery in
                        NavigationLink(destination: ResultView(query: suggestedQuery)) {
                            Text(suggestedQuery)
                        }
                    }
                    .padding(.bottom, keyboardObserver.keyboardHeight)
                    .animation(.easeInOut(duration: 0.3))
                }
            }
            .sheet(isPresented: $showSettings, content: {
                SettingsView().environmentObject(self.settings)
            })
            .navigationBarTitle("Reegle", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showSettings.toggle()
                }, label: {
                    Text("Settings")
                })
            )
        }
    }
}
