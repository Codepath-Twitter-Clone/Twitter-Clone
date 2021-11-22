//
//  FeedViewModel.swift
//  Twitter
//
//  Created by user204085 on 11/21/21.
//

import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var tweets = [Tweet]()
    
    init() {
        fetchTweets()
    }
    
// ** Uncomment this function to fetch tweets as we did in course ** //
    
//    func fetchTweets() {
//        COLLECTION_TWEETS.getDocuments { snapshot, _ in
//            guard let documents = snapshot?.documents else { return }
//            self.tweets = documents.map({ Tweet(dictionary: $0.data()) })
//        }
//    }

// ** This function fetches tweets from people that the user follows ** //
    
    func fetchTweets() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        var tweets = [Tweet]()
        COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
                        
            documents.forEach { document in
                COLLECTION_TWEETS.document(document.documentID).getDocument { snapshot, _ in
                    guard let data = snapshot?.data() else { return }
                    tweets.append(Tweet(dictionary: data))
                    
                    if tweets.count == documents.count {
                        self.tweets = tweets.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
                    }
                }
            }
        }
    }
}
