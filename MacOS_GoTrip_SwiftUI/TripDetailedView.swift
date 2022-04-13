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
    @ObservedObject var trip: TripInfoModel
    
    var annotations: [City] = []
    
    init(_ trip: TripInfoModel) {
        self.trip = trip
        self.tripModel = TripModel(
            City(name: "Vancouver", coordinate: CLLocationCoordinate2D(latitude: 49.260413, longitude: -123.113946)),
            City(name: "Torronto", coordinate: CLLocationCoordinate2D(latitude: 43.651605, longitude: -79.383125)))
        annotations.append(tripModel.c1)
        annotations.append(tripModel.c2)
    }
    
    let img1 = CircleImage(imgName: "Vancouver")
    let img2 = CircleImage(imgName: "Vancouver")

    var body: some View {
        ScrollView {
            Map(coordinateRegion: $tripModel.region, annotationItems: annotations) {
                MapPin(coordinate: $0.coordinate)
            }
            .ignoresSafeArea(edges: .top)
            .frame(height: 300)
            
            GeometryReader { geo in
                Line(start: CGPoint(x: 120, y: 0), end: CGPoint(x: geo.size.width - 120, y: 0))
                    .stroke(.white, lineWidth: 20)
            }

            HStack {
                img1
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 240)
                
                Spacer()
                
                img2
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 240)
            }
            .offset(y: -40)
            .padding(.horizontal, 20)

            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Text(trip.placeFrom)
                            .font(.title)
                        
                        HStack {
                            Text(trip.placeFrom)
                            Text(trip.placeFrom)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            Text(trip.placeTo)
                                .font(.title)
                        }

                        HStack {
                            Text(trip.placeTo)
                            Text(trip.placeTo)
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
        .navigationTitle("Trip Detailed")
    }
}

struct Line: Shape {
    var start, end: CGPoint

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: start)
            p.addLine(to: end)
        }
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailedView(TripInfoModel())
    }
}
