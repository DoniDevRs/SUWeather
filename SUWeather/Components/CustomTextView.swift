//
//  CustomTextView.swift
//  SUWeather
//
//  Created by Doni on 04/08/23.
//

import SwiftUI

struct CustomTextView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}
