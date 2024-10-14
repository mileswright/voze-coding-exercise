import Foundation

protocol AttributeType: Codable {
    associatedtype AssociatedType
    var value: AssociatedType { get }
    init(value: AssociatedType)
}

struct NameAttribute: AttributeType, Codable {
    var value: String
}

struct DescriptionAttribute: AttributeType, Codable {
    var value: String
}

struct EstimatedRevenueAttribute: AttributeType, Codable {
    var value: Decimal
}

struct LocationTypeAttribute: AttributeType, Codable {
    var value: LocationType
}
