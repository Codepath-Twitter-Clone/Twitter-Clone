//
//  LazyView.swift
//  TwitterSwiftUITutorial
//
//  Created by Stephen Dowless on 12/2/20.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping() -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}
