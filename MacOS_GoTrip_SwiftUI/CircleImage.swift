//
//  CircleImage.swift
//  MacOS_GoTrip_SwiftUI
//
//  Created by Gleb Sobolevsky on 26.03.2022.
//

import SwiftUI

struct CircleImage: View {
    let imgName: String
    
    var body: some View {
        Image(imgName)
            .resizable(resizingMode: .stretch)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.white, lineWidth: 5))
    }
}
