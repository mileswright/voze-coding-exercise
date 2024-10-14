import Foundation

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
