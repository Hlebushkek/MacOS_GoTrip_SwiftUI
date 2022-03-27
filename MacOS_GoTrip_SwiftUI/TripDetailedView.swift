//
//  TripDetailedView.swift
//  MacOS_GoTrip_SwiftUI
//
//  Created by Gleb Sobolevsky on 26.03.2022.
//

import SwiftUI
import MapKit


struct City: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class TripModel: ObservableObject {
    @Published var region: MKCoordinateRegion
    let c1: City
    let c2: City
    
    init(_ c1: City, _ c2: City) {
        self.c1 = c1
        self.c2 = c2
        
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (c1.coordinate.latitude + c2.coordinate.latitude) / 2,longitude: (c1.coordinate.longitude + c2.coordinate.longitude) / 2), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    }
}

struct TripDetailedView: View {
    
    @ObservedObject var tripModel: TripModel
    var annotations: [City] = []
    
    init(_ tripModel: TripModel) {
        self.tripModel = tripModel
        
        annotations.append(tripModel.c1)
        annotations.append(tripModel.c2)
    }

    var body: some View {
        ScrollView {
            Map(coordinateRegion: $tripModel.region, annotationItems: annotations) {
                MapPin(coordinate: $0.coordinate)
            }
            .ignoresSafeArea(edges: .top)
            .frame(height: 300)

            HStack {
                CircleImage(imgName: "Vancouver")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 240)
                
                Spacer()
                
                CircleImage(imgName: "Vancouver")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 240)
            }
            .offset(y: -40)
            

            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Text("landmark.name")
                            .font(.title)
                        
                        HStack {
                            Text("landmark.park")
                            Text("landmark.state")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            Text("landmark.name")
                                .font(.title)
                        }

                        HStack {
                            Text("landmark.park")
                            Text("landmark.state")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }

                Divider()

                Text("About landmark.name")
                    .font(.title2)
                Text("landmark.description")
            }
            .padding()
        }
        .navigationTitle("title123")
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailedView(TripModel(
            City(name: "Vancouver", coordinate: CLLocationCoordinate2D(latitude: 49.260413, longitude: -123.113946)),
            City(name: "Torronto", coordinate: CLLocationCoordinate2D(latitude: 43.651605, longitude: -79.383125))
        ))
    }
}
