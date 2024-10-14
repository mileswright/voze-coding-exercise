import Foundation

protocol LocationService {
    func getLocations() async throws -> [Location]
}
