//
//  MacOS_GoTrip_SwiftUIApp.swift
//  MacOS_GoTrip_SwiftUI
//
//  Created by Gleb Sobolevsky on 26.03.2022.
//

import SwiftUI
import MapKit

@main
struct MacOS_GoTrip_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TripListView()
                TripDetailedView(TripModel(
                    City(name: "Vancouver", coordinate: CLLocationCoordinate2D(latitude: 49.260413, longitude: -123.113946)),
                    City(name: "Torronto", coordinate: CLLocationCoordinate2D(latitude: 43.651605, longitude: -79.383125))
                ))
            }
        }
    }
}
