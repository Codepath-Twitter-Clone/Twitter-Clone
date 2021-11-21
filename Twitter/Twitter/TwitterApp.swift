//
//  TwitterApp.swift
//  Twitter
//
//  Created by user204085 on 11/19/21.
//

import SwiftUI
import Firebase

@main
struct TwitterApp: App {
    
    init(){
        FirebaseApp.configure();
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
