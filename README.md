# Twitter

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
The team is building an MVP version of Twitter with strictly Swift UI using the MVVM architecture. We will be building this completely from scratch, starting with the User Interface skeleton, and working our way up to integrating our API with Firebase and data models. We will be building all the core components of a social network. This includes following users, uploading/liking tweets, direct messaging, creating a user profile, and registering users.

### App Evaluation
- Social
- UI/UX for mobile iOS experience
- A service for friends, family, and coworkers to stay connected through the exchange of quick, frequent messages
- 353 million active users
- Twitter audience most receptive, valuable for its influence, and brand conscious
- Very mature technology

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [x] Following users
* [x] Viewing tweets
* [x] Uploading/liking/commenting tweets
* [x] Implement user profile
* [x] Log-in/sign-up users
* [x] Search users

**Optional Nice-to-have Stories**

* [x] Direct messaging
* [x] Edit user profile

### 2. Screen Archetypes

* Login
   * Login
* Signup
   * Signup
* Main
   * Viewing tweets
   * Following users
   * liking tweets
* Profile
   * Creating/editing a user profile
* Post
   * Uploading tweets
* Tweet
   * Viewing tweets details
   * Viewing tweets comments
   * Commenting tweets
   * Following users
   * liking tweets

### 3. Navigation

**Tab Navigation** (Tab to Screen)
* No tab navigation needed.

**Flow Navigation** (Screen to Screen)

* Login
   * Main
* Signup
   * Login
* Main
   * Post
   * Profile
   * Tweet
* Profile
   * Main
* Post
   * Tweet
* Tweet
   * Main

## Schema 
### Models
#### User

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | id                | String       | unique id for the user |
   | username          | String       | username |
   | profileImageUrl   | String       | URL to profile image |
   | fullname          | String       | full name |
   | email             | String       | email |
   | stats             | UserStats    | user statistics |
   | bio               | String       | bio |
   | isFollowed        | Bool         | if the user is already followed |
   | isCurrentUser     | Bool         | if this instance is current user |

#### UserStats
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | followers           | Int   | number of followers |
   | following           | Int   | number of owner's followings |

#### Tweet

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | id                | String       | unique id for the user |
   | username          | String       | username |
   | profileImageUrl   | String       | URL to profile image |
   | fullname          | String       | full name |
   | caption           | String       | caption |
   | likes             | Int          | user statistics |
   | uid               | String       | unique id for the message |
   | timeStamp         | TimeStamp    | time of tweet |
   | replyingTo        | String       | receiver ID |

#### Message
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | id                | String       | unique id for the message |
   | user              | User         | user |
   | toId              | String       | receiver ID |
   | fromId            | String       | sender ID |
   | isFromCurrentUser | Bool         | if sender is current user |
   | timeStamp         | TimeStamp    | time of message |
   
### Networking
- Login
  - (Get) get user info
  ```swift
      func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to login: \(error.localizedDescription)")
                return
            }
            
            self.userSession = result?.user
            self.fetchUser()
        }
    }
  ```
- Signup
  - (Post) post user info
     ```swift
        func registerUser(email: String, password: String, username: String,
                      fullname: String, profileImage: UIImage) {
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(filename)
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
                        
            storageRef.downloadURL { url, _ in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("DEBUG: Error \(error.localizedDescription)")
                        return
                    }
                    
                    guard let user = result?.user else { return }
                    
                    let data = ["email": email,
                                "username": username.lowercased(),
                                "fullname": fullname,
                                "profileImageUrl": profileImageUrl,
                                "uid": user.uid]
                    
                    Firestore.firestore().collection("users").document(user.uid).setData(data) { _ in
                        self.userSession = user
                        self.fetchUser()
                    }
                }
            }
        }
      }
    ```
- Main
  - (Get) get main page tweets
     ```swift
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
     ```
  - (Post) sign out
     ```swift
      func signOut() {
          userSession = nil
          user = nil
          try? Auth.auth().signOut()
      }
     ```
- Profile
  - (Get) get user details
     ```swift
      func fetchUserStats() {
        guard let user = self.user else { return }
        UserService.fetchUserStats(user: user) { stats in
            self.user?.stats = stats
        }
      }
     ```

- Post
  - (Post) post user tweet
     ```swift
    private func upload(caption: String, type: TweetUploadType) {
        guard let user = AuthViewModel.shared.user else { return }
        let docRef = documentReference(forUploadType: type)
        
        var data: [String: Any] = ["uid": user.id,
                                   "caption": caption,
                                   "fullname": user.fullname, "timestamp": Timestamp(date: Date()),
                                   "username": user.username,
                                   "profileImageUrl": user.profileImageUrl,
                                   "likes": 0,
                                   "id": docRef.documentID]
        
        switch type {
        case .reply(let tweet):
            data["replyingTo"] = tweet.username
            
            docRef.setData(data) { _ in
                let userRepliesRef = COLLECTION_USERS.document(user.id).collection("user-replies").document(docRef.documentID)
                userRepliesRef.setData(data) { _ in
                    self.isPresented = false
                    NotificationViewModel.uploadNotification(toUid: tweet.uid, type: .reply, tweet: tweet)
                }
            }
        case .tweet:
            docRef.setData(data) { _ in
                self.isPresented = false 
            }
        }
    }
     ```
- Tweet
  - (Post) tweet interactions like liking, following, commenting
     ```swift
    func likeTweet() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        let tweetLikesRef = COLLECTION_TWEETS.document(tweet.id).collection("tweet-likes")
        let userLikesRef = COLLECTION_USERS.document(uid).collection("user-likes")
        
        COLLECTION_TWEETS.document(tweet.id).updateData(["likes": tweet.likes + 1]) { _ in
            tweetLikesRef.document(uid).setData([:]) { _ in
                userLikesRef.document(self.tweet.id).setData([:]) { _ in
                    self.didLike = true
                    
                    NotificationViewModel.uploadNotification(toUid: self.tweet.uid, type: .like, tweet: self.tweet)
                }
            }
        }
    }
     ```
  - (Delete) revert actions like liking, following
     ```swift
    func unlikeTweet() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        let tweetLikesRef = COLLECTION_TWEETS.document(tweet.id).collection("tweet-likes")
        let userLikesRef = COLLECTION_USERS.document(uid).collection("user-likes")
        
        COLLECTION_TWEETS.document(tweet.id).updateData(["likes": tweet.likes - 1]) { _ in
            tweetLikesRef.document(uid).delete { _ in
                userLikesRef.document(self.tweet.id).delete { _ in
                    self.didLike = false
                    
                    NotificationViewModel.deleteNotification(toUid: self.tweet.uid, type: .like, tweetId: self.tweet.id)
                }
            }
        }
    }
     ```
  - (Get) get tweet details
     ```swift
      func fetchUserTweets() {
        COLLECTION_TWEETS.whereField("uid", isEqualTo: user.id).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.userTweets = documents.map({ Tweet(dictionary: $0.data()) })
        }
    }
     ```

<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/P1.gif">
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/P2.gif" >
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/P3.gif" >
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/P4.gif" >
