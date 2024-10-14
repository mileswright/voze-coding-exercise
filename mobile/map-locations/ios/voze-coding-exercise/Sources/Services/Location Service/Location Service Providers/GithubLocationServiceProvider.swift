import Foundation

struct GithubLocationServiceProvider: LocationService {
    var githubUsername: String
    private var urlString: String {
        "https://raw.githubusercontent.com/\(githubUsername)/voze-coding-exercise/master/mobile/map-locations/locations.json"
    }
    private var url: URL? { URL(string: urlString) }

    func getLocations() async throws -> [Location] {
            guard let url else { throw NetworkError.invalidURL }
            let (data, _) = try await URLSession.shared.data(from: url)
            let locations = try JSONDecoder().decode([Location].self, from: data)
            return locations
    }
}

