//
//  XDismissButton.swift
//  SUWeather
//
//  Created by Doni on 04/08/23.
//

import SwiftUI

struct XDismissButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(Color(.white))
                .opacity(0.6)
            
            Image(systemName: "xmark")
                .imageScale(.small)
                .frame(width: 44, height: 44)
                .foregroundColor(.gray)
        }
    }
}
