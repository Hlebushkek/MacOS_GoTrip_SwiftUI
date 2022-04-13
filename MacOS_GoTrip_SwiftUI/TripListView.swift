//
//  TripList.swift
//  MacOS_GoTrip_SwiftUI
//
//  Created by Gleb Sobolevsky on 26.03.2022.
//

import SwiftUI
import RealmSwift
import MapKit


let app: RealmSwift.App? = RealmSwift.App(id: "gotripios-pxcep")
 
struct TripListView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedFilter: TripType?
    @State private var showFavoritesOnly = false
    var trips: [TripInfoModel] = []
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    LogoutButton()
                    Spacer()
                    AddTripButton()
                }.padding(.horizontal, 10)
                
                List {
                    ForEach(trips) { trip in
                        NavigationLink {
                            TripDetailedView(trip)
                        } label: {
                            TripCell(trip: trip)
                        }
                        .tag(trip._id.stringValue)
                    }
                }
                .frame(minWidth: 160)
                .padding(.vertical, 4)
                .toolbar {
                    ToolbarItem {
                        Menu {
                            Picker("Sort by type", selection: $selectedFilter) {
                                Text("Airplane")
                                Text("Train")
                                Text("Bus")
                                Text("Car")
                            }
                            .pickerStyle(.inline)
                            
                            Toggle(isOn: $showFavoritesOnly) {
                                Label("Favorites only", systemImage: "star.fill")
                            }
                        } label: {
                            Label("Filter", systemImage: "slider.horizontal.3")
                        }
                    }
                }
            }
            
            Text("Select trip")
        }
    }
}

struct TripCell: View {
    var trip: TripInfoModel
    
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
        .cornerRadius(5)
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
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            if isLoggingIn {
                ProgressView()
            }
            if let error = error {
                Text("Error: \(error.localizedDescription)")
            }
            TextField("Email", text: $email)
                .frame(width: 160, height: 20)
            SecureField("Password", text: $password)
                .frame(width: 160, height: 20)
            Button("Log in") {
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
    }
}
struct AddTripButton: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("Add trip") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            AddTripView()
                .frame(minWidth: 200, minHeight: 200)
        }
    }
}

class AppState: ObservableObject {
    @Published var userID: String?
}
