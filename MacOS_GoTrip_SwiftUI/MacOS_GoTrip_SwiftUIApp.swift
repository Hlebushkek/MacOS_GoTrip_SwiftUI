//
//  MacOS_GoTrip_SwiftUIApp.swift
//  MacOS_GoTrip_SwiftUI
//
//  Created by Gleb Sobolevsky on 26.03.2022.
//

import SwiftUI
import MapKit
import RealmSwift

@main
struct MacOS_GoTrip_SwiftUIApp: SwiftUI.App {
    
    let app: RealmSwift.App? = RealmSwift.App(id: "gotripios-pxcep")
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                
                if let app = app {
                    SyncContentView(app: app)
                } else {
                    Text("Local")
                }
                
                TripDetailedView(TripModel(
                    City(name: "Vancouver", coordinate: CLLocationCoordinate2D(latitude: 49.260413, longitude: -123.113946)),
                    City(name: "Torronto", coordinate: CLLocationCoordinate2D(latitude: 43.651605, longitude: -79.383125))
                ))
            }
        }.commands { GoTripMacCommands() }
    }
}
