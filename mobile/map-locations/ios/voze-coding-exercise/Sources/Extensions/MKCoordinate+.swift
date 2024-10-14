import MapKit

extension MKCoordinateRegion {
    static let startingLocation = MKCoordinateRegion(
        center: .sfCityCenter,
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
}
