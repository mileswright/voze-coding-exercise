import SwiftUI

enum LocationType: String, CaseIterable, Codable {
    case bar
    case cafe
    case landmark
    case museum
    case park
    case restaurant
    case none
}

extension LocationType {
    var asLocationTypeFilter: LocationTypeFilter {
        LocationTypeFilter(active: true, locationType: self)
    }

    var title: String {
        switch self {
        case .bar:
            "Bar"
        case .cafe:
            "Cafe"
        case .landmark:
            "Landmark"
        case .museum:
            "Museum"
        case .park:
            "Park"
        case .restaurant:
            "Restaurant"
        case .none:
            "Unknown"
        }
    }

    var color: Color {
        switch self {
        case .bar:
                .purple
        case .cafe:
                .indigo
        case .landmark:
                .orange
        case .museum:
                .red
        case .park:
                .green
        case .restaurant:
                .blue
        case .none:
                .gray.opacity(0.5)
        }
    }

    var inactiveColor: Color {
        color.opacity(0.35)
    }

    var icon: Image {
        switch self {
        case .bar:
            return Image(systemName: "wineglass.fill")
        case .cafe:
            return Image(systemName: "cup.and.saucer.fill")
        case .landmark:
            return Image(systemName: "star.fill")
        case .museum:
            return Image(systemName: "building.columns.fill")
        case .park:
            return Image(systemName: "leaf.fill")
        case .restaurant:
            return Image(systemName: "fork.knife")
        case .none:
            return Image(systemName: "questionmark.circle.fill")
        }
    }
}
