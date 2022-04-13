//
//  AddTripView.swift
//  MacOS_GoTrip_SwiftUI
//
//  Created by Gleb Sobolevsky on 31.03.2022.
//

import SwiftUI
import RealmSwift

struct AddTripView: View {
    @State private var placeFrom = ""
    @State private var placeTo = ""
    @State private var priceStr = "0.00"
    @State private var selectedTypeStr = "Airplane"
    @State private var selectedType = TripType.Airplane
    @State private var selectedCurrency = CurrencyType.EUR
    let types = ["Airplane", "Train", "Bus", "Car"]
    
    @State private var showingSheet = false
    
    @ObservedRealmObject var newTrip: TripInfoModel = TripInfoModel()
    
    var body: some View {
        VStack {
            TextField("City from", text: $placeFrom)
                .frame(width: 100, height: 20)
            TextField("City to", text: $placeTo)
                .frame(width: 100, height: 20)
            
            HStack(spacing: 0.0) {
                TextField("Price", text: $priceStr, onEditingChanged: { _ in
                    priceStr = TripPriceModel(Float(priceStr)!).description
                })
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100, height: 20)
                
                Picker("", selection: $selectedCurrency) {
                    ForEach(CurrencyType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .frame(width: 48)
                .pickerStyle(.menu)
            }
            .padding(.horizontal, 20)
            
            VStack {
                Picker("Select trip type", selection: $selectedTypeStr) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding(.horizontal, 20)
        }
        
        Button("Submit") {
                        
            guard let price = Float(priceStr) else {
                print("Can't create number")
                return
            }
            
            newTrip.placeFrom = placeFrom
            newTrip.placeTo = placeTo
            newTrip.type = TripType(rawValue: types.firstIndex(of: selectedTypeStr) ?? 0) ?? .Airplane
            newTrip.price = TripPriceModel(price)
            newTrip.dateAdded = dateToString(Date())
            newTrip.ownerID = app!.currentUser!.id
            
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            OpenSyncedRealmViewWrite(trip: newTrip)
                .frame(minWidth: 200, minHeight: 200)
        }
    }
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"

        return dateFormatter.string(from: date)
    }
}

struct OpenSyncedRealmViewWrite: View {
    @AsyncOpen(appId: "gotripios-pxcep", partitionValue: "", timeout: 4000) var asyncOpen
    
    var trip: TripInfoModel

    var body: some View {
        switch asyncOpen {
        case .connecting:
            ProgressView()
        case .waitingForUser:
            ProgressView("Waiting for user to log in...")
        case .open(let userRealm):
            { () -> Text in
                print(trip)
                do {
                    try userRealm.write {
                        userRealm.add(trip)
                    }
                } catch {
                    return Text("Could not write trip to realm: \(error.localizedDescription)")
                }

                return Text("Trip was successfully added")
            }()
        case .progress(let progress):
            ProgressView(progress)
        case .error(let error):
            Text("Error \(error.localizedDescription)")
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
            .frame(width: 300.0, height: 300.0)
    }
}
