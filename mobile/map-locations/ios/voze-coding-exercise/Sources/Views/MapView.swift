import SwiftUI
import MapKit

@MainActor
struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .initialPosition
    @Binding private var locations: [Location]

    init(locations: Binding<[Location]>) {
        self._locations = locations
        self._cameraPosition = State(initialValue: mapCameraPositionForLocations(self.locations))
    }

    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                ForEach(locations) { location in
                    Annotation(location.name ?? "", coordinate: location.coordinate) {
                        location.icon
                            .foregroundStyle(location.color)
                    }
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
    struct PreviewWrapper: View {
        @State var locations: [Location] = [.location1, .location2, .location3]
        var body: some View {
            MapView(locations: $locations)
        }
    }

    return PreviewWrapper()
}

