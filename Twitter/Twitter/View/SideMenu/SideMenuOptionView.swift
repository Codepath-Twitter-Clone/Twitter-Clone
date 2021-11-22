//
//  ProfileActionButtonView.swift
//  Twitter
//
//  Created by user204085 on 11/21/21.
//


import SwiftUI

struct SideMenuOptionView: View {
    let option: SideMenuViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: option.imageName)
                .foregroundColor(.gray)
                .font(.system(size: 24))

            Text(option.description)
                .foregroundColor(.black)

            Spacer()
        }
    }
}
