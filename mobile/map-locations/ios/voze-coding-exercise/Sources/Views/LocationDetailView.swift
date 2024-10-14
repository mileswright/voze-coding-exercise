import MapKit
import SwiftUI

struct LocationDetailView: View {
    var location: Location

    var body: some View {
        VStack(spacing: 8) {
            if let description = location.description {
                Text("Description: \n\(description)")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 16)
            }
            if let estimatedRevenueMillions = location.estimatedRevenueMillions {
                Text("Estimated Revenue: \n\(estimatedRevenueMillions) million")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 16)
            }

            // This could probably be massaged to be part of the MapView
            Map(initialPosition: mapCameraPositionForLocations([location])) {
                Annotation(coordinate: location.coordinate) {
                    location.icon
                        .foregroundStyle(location.color)
                } label: {
                    VStack {
                        HStack {
                            location.locationType.icon
                            Text(location.name)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .background(Color.white)
                }
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 8)
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    location.icon
                        .foregroundStyle(location.color)
                    Text(location.name)
                        .foregroundStyle(location.color)
                }
            }
        }
    }

    private func mapCameraPositionForLocations(_ locations: [Location]) -> MapCameraPosition {
        MapCameraPosition.region(regionThatContainsAllLocations(locations))
    }

    private func regionThatContainsAllLocations(_ locations: [Location]) -> MKCoordinateRegion {
        let minLat = locations.map { $0.latitude }.min() ?? 0
        let maxLat = locations.map { $0.latitude }.max() ?? 0
        let minLon = locations.map { $0.longitude }.min() ?? 0
        let maxLon = locations.map { $0.longitude }.max() ?? 0
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2

        // Ensure all points are viewable by providing 10% buffer to span deltas
        let spanBuffer = 1.1
        let latitudeDelta = (maxLat - minLat) * spanBuffer
        let longitudeDelta = (maxLon - minLon) * spanBuffer

        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        )
    }
}

#Preview {
    NavigationStack {
        LocationDetailView(location: .location1)
    }
}
