//
//  TripList.swift
//  MacOS_GoTrip_SwiftUI
//
//  Created by Gleb Sobolevsky on 26.03.2022.
//

import SwiftUI
 
struct TripListView: View {
    var body: some View {
        Text("List")
        HStack {
            Image("Torronto")
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(5)
            VStack(alignment: .leading) {
                Text("landmark.name")
                    .bold()
                Text("landmark.park")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()

            if true {
                Image(systemName: "star.fill")
                    .imageScale(.medium)
                    .foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
    }
}
