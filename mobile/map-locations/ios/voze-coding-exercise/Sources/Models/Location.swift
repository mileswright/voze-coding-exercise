import Foundation
import MapKit
import SwiftUI

struct Location: Identifiable {
    let id: Int
    let latitude: Double
    let longitude: Double
    var attributes: [any AttributeType]

    init(id: Int, latitude: Double, longitude: Double, attributes: [any AttributeType]) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.attributes = attributes
    }
}

extension Location {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var color: Color {
        locationType.color
    }

    var icon: Image {
        locationType.icon
    }
}

extension Location {
    subscript<T: AttributeType>(key: T.Type) -> T.AssociatedType? {
        get { attributes.firstOfTypeOrNil(as: key)?.value }
        set {
            if let idx = attributes.firstIndex(where: { $0 is T }) {
                if let newValue {
                    attributes[idx] = T.init(value: newValue)
                } else {
                    attributes.remove(at: idx)
                }
            } else if let newValue {
                attributes.append(T.init(value: newValue))
            }
        }
    }

    var name: String? {
        attributes.firstOfTypeOrNil(as: NameAttribute.self)?.value
    }

    var description: String? {
        attributes.firstOfTypeOrNil(as: DescriptionAttribute.self)?.value
    }

    var estimatedRevenueMillions: Decimal? {
        attributes.firstOfTypeOrNil(as: EstimatedRevenueAttribute.self)?.value
    }

    var locationType: LocationType {
        attributes.firstOfTypeOrNil(as: LocationTypeAttribute.self)?.value ?? .none
    }
}

extension Location: Codable {
    enum CodingKeys: String, CodingKey {
        case id, latitude, longitude, attributes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)

        var attributesContainer = try container.nestedUnkeyedContainer(forKey: .attributes)
        var attributes = [any AttributeType]()

        while !attributesContainer.isAtEnd {
            let attributeContainer = try attributesContainer.nestedContainer(keyedBy: AttributeKeys.self)
            let type = try attributeContainer.decode(String.self, forKey: .type)

            switch type {
            case "location_type":
                let value = try attributeContainer.decode(LocationType.self, forKey: .value)
                attributes.append(LocationTypeAttribute(value: value))
            case "name":
                let value = try attributeContainer.decode(String.self, forKey: .value)
                attributes.append(NameAttribute(value: value))
            case "description":
                let value = try attributeContainer.decode(String.self, forKey: .value)
                attributes.append(DescriptionAttribute(value: value))
            case "estimated_revenue_millions":
                let value = try attributeContainer.decode(Decimal.self, forKey: .value)
                attributes.append(EstimatedRevenueAttribute(value: value))
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: attributeContainer, debugDescription: "Invalid type value")
            }
        }

        self.attributes = attributes
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)

        var attributesContainer = container.nestedUnkeyedContainer(forKey: .attributes)
        for attribute in attributes {
            var attributeContainer = attributesContainer.nestedContainer(keyedBy: AttributeKeys.self)
            switch attribute {
            case let locationType as LocationTypeAttribute:
                try attributeContainer.encode("location_type", forKey: .type)
                try attributeContainer.encode(locationType.value, forKey: .value)
            case let name as NameAttribute:
                try attributeContainer.encode("name", forKey: .type)
                try attributeContainer.encode(name.value, forKey: .value)
            case let description as DescriptionAttribute:
                try attributeContainer.encode("description", forKey: .type)
                try attributeContainer.encode(description.value, forKey: .value)
            case let estimatedRevenue as EstimatedRevenueAttribute:
                try attributeContainer.encode("estimated_revenue_millions", forKey: .type)
                try attributeContainer.encode(estimatedRevenue.value, forKey: .value)
            default:
                throw EncodingError.invalidValue(attribute, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Invalid attribute type"))
            }
        }
    }
}

extension Location {
    static var location1: Location {
        Location(
            id: 1,
            latitude: 37.7750,
            longitude: -122.4195,
            attributes: [
                LocationTypeAttribute(value: .restaurant),
                NameAttribute(value: "Golden Gate Grill"),
                DescriptionAttribute(value: "A popular spot for local cuisine."),
                EstimatedRevenueAttribute(value: 3.5)
            ]
        )
    }

    static var location2: Location {
        Location(
            id: 2,
            latitude: 37.7745,
            longitude: -122.4189,
            attributes: [
                LocationTypeAttribute(value: .museum),
                NameAttribute(value: "San Francisco Museum of Modern Art"),
                DescriptionAttribute(value: "Contemporary art exhibits."),
                EstimatedRevenueAttribute(value: 5.0)
            ]
        )
    }

    static var location3: Location {
        Location(
            id: 3,
            latitude: 37.7752,
            longitude: -122.4198,
            attributes: [
                LocationTypeAttribute(value: .park),
                NameAttribute(value: "Yerba Buena Gardens"),
                DescriptionAttribute(value: "Urban park with sculptures and waterfalls."),
                EstimatedRevenueAttribute(value: 8.0)
            ]
        )
    }
}
