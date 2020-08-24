//
//  ResultView.swift
//  Reegle
//
//  Created by Kevin Dion on 2020-08-09.
//  Copyright © 2020 redbastie. All rights reserved.
//

import SwiftUI
import SwiftSoup

struct ResultView: View {
    @EnvironmentObject var settings: Settings
    var query: String
    @State var start: Int = 0
    @State var resultItems: [ResultItem] = [ResultItem]()
    @State var showFailedToOpenAlert: Bool = false
    
    var body: some View {
        List(resultItems, id: \.link) { resultItem in
            Button(action: {
                let url = URL(string: resultItem.replacedLink(self.settings.openResultsWith))!
                
                UIApplication.shared.open(url, options: [:], completionHandler: {success in
                    if (!success) {
                        self.showFailedToOpenAlert.toggle()
                    }
                })
            }, label: {
                VStack(alignment: .leading) {
                    Text(resultItem.title)
                        .padding(.bottom, 6)
                    
                    Text(resultItem.subreddit())
                        .font(.subheadline)
                        .opacity(0.5)
                        .padding(.bottom, 6)
                    
                    Text(resultItem.snippet)
                        .font(.subheadline)
                        .opacity(0.75)
                }
                .padding([.top, .bottom], 6)
            })
            .onAppear {
                if (self.resultItems.last == resultItem) {
                    self.loadItems()
                }
            }
        }
        .padding(.bottom, 6)
        .onAppear {
            if let index = self.settings.queryHistories.firstIndex(where: { $0.lowercased() == self.query.lowercased() }) {
                self.settings.queryHistories.remove(at: index)
            }
            
            self.settings.queryHistories.insert(self.query, at: 0)
            
            self.loadItems()
        }
        .alert(isPresented: $showFailedToOpenAlert) {
            Alert(
                title: Text("Oops!"),
                message: Text(
                    settings.openResultsWith + " is not installed on your phone. " +
                    "Install this app or change 'Open Results With' in settings."
                ),
                dismissButton: .default(Text("Got it!"))
            )
        }
        .navigationBarTitle(query)
    }
    
    func loadItems() {
        let redditQuery = "site:reddit.com " + query
        let encodedQuery = redditQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        var url = "https://www.google.com/search"
        url += "?q=" + encodedQuery!
        url += "&start=" + String(start)
        let requestUrl = URL(string: url)
        let request = URLRequest(url: requestUrl!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let html: String = String(data: data!, encoding: .ascii)!
                let doc: Document = try SwiftSoup.parse(html)
                let divs: Elements = try doc.select("#main > div > div > div > div")
                
                for div: Element in divs.array() {
                    let anchors: Elements = try div.select("div > div > a")
                    let titles: Elements = try div.select("div > div > a > div > div")
                    let snippets: Elements = try div.select("div > div > div> span")
                    
                    if (anchors.count > 0 && titles.count > 0 && snippets.count > 0) {
                        let anchor: Element = anchors.first()!
                        let link: String = try anchor.attr("href")
                        let titleElement: Element = titles.first()!
                        let title: String = try titleElement.text()
                        
                        if (self.isValidResult(link: link, title: title)) {
                            self.resultItems.append(ResultItem(
                                link: link,
                                title: title,
                                snippet: try snippets.text())
                            )
                        }
                    }
                }
            } catch {
                //
            }
        }.resume()
        
        start += 10
    }
    
    func isValidResult(link: String, title: String) -> Bool {
        return !link.isEmpty && link.count > 1 && !title.isEmpty
    }
}
