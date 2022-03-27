//
//  TripList.swift
//  MacOS_GoTrip_SwiftUI
//
//  Created by Gleb Sobolevsky on 26.03.2022.
//

import SwiftUI
import RealmSwift


let app: RealmSwift.App? = RealmSwift.App(id: "gotripios-pxcep")
 
struct TripListView: View {
    @EnvironmentObject var appState: AppState
    @State var selectedID: String? = nil
    var trips: [TripInfoModel] = []
    
    var body: some View {
        LogoutButton()
        List {
            ForEach(trips) { trip in
                TripCell(trip: trip, selectedID: self.$selectedID)
            }
        }
        .padding(.vertical, 4)
    }
}

struct TripCell: View {
    var trip: TripInfoModel
    @Binding var selectedID: String?
    
    var body: some View {
        HStack {
            Image("Vancouver")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
                .cornerRadius(5)
                .padding(5)

            VStack(alignment: .leading) {
                Text(trip.placeFrom)
                    .bold()

                Text(trip.placeTo)
                    .bold()
            }
            
            Spacer()
            
            if true {
                Image(systemName: "star.fill")
                    .padding(.trailing, 4)
                    .imageScale(.medium)
                    .foregroundColor(.yellow)
                    
            }
        }
        .background(selectedID == trip._id.stringValue ? .blue : .clear)
        .contentShape(Rectangle())
        .cornerRadius(5)
        .padding(.bottom, 10)
        .onTapGesture {
            self.selectedID = trip._id.stringValue
        }
    }
}

struct SyncContentView: View {
    @ObservedObject var app: RealmSwift.App
    
    var body: some View {
        if app.currentUser != nil {
            OpenSyncedRealmView().environment(\.partitionValue, "123")
        } else {
            LoginView()
        }
    }
}

struct OpenSyncedRealmView: View {
    @AsyncOpen(appId: "gotripios-pxcep", partitionValue: "", timeout: 4000) var asyncOpen
    
    var body: some View {
        
        switch asyncOpen {
        case .connecting:
            ProgressView()
        case .waitingForUser:
            ProgressView("Waiting for user to log in...")
        case .open(let userRealm):
            TripListView(trips: Array(userRealm.objects(TripInfoModel.self))).environment(\.realm, userRealm)
        case .progress(let progress):
            ProgressView(progress)
        case .error(let error):
            Text("Error \(error.localizedDescription)")
        }
    }
}

struct LoginView: View {
    @State var error: Error?
    @State var isLoggingIn = false
    
    var body: some View {
        VStack {
            if isLoggingIn {
                ProgressView()
            }
            if let error = error {
                Text("Error: \(error.localizedDescription)")
            }
            Button("Log in anonymously") {
                isLoggingIn = true
                app!.login(credentials: .emailPassword(email: "volsoor@gmail.com", password: "hleb123")) { result in
                    isLoggingIn = false
                    if case let .failure(error) = result {
                        print("Failed to log in: \(error.localizedDescription)")
                        self.error = error
                        return
                    }
                    print("Logged in")
                }
            }.disabled(isLoggingIn)
        }
    }
}

struct LogoutButton: View {
    @State var isLoggingOut = false
    var body: some View {
        Button("Log Out") {
            guard let user = app!.currentUser else {
                return
            }
            isLoggingOut = true
            user.logOut() { error in
                isLoggingOut = false
                print("Logged out")
            }
        }
        .disabled(app!.currentUser == nil || isLoggingOut)
        .padding(.top, 8)
    }
}

class AppState: ObservableObject {
    @Published var userID: String?
}
