import Foundation

struct GithubLocationServiceProvider: LocationService {
    var githubUsername: String
    var projectName: String

    private var urlString: String {
        // Thiw
        "https://raw.githubusercontent.com/\(githubUsername)/\(projectName)/master/mobile/map-locations/locations.json"
    }
    private var url: URL? { URL(string: urlString) }

    func getLocations() async throws -> [Location] {
            guard let url else { throw LocationServiceError.invalidURL }
            let (data, _) = try await URLSession.shared.data(from: url)
            let locations = try JSONDecoder().decode([Location].self, from: data)
            return locations
    }
}

