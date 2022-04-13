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
            if let app = app {
                SyncContentView(app: app)
                    .frame(minWidth: 800, minHeight: 600)
            } else {
                Text("Local")
            }
        }.commands { GoTripMacCommands() }
    }
}
