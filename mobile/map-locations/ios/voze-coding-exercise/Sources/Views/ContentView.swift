import SwiftUI

@MainActor
@Observable
class ContentViewModel: ObservableObject {
    enum State {
        case loading
        case loaded
        case error(Error)
    }

    private var locationService: LocationService
    var state: State = .loading
    var locations: [Location] = []

    init(locationService: LocationService) {
        self.locationService = locationService
    }

    func loadData() {
        self.state = .loading

        Task {
            do {
                let locations = try await self.locationService.getLocations()
                DispatchQueue.main.async {
                    self.locations = locations
                    self.state = .loaded
                }
            } catch {
                self.state = .error(error)
            }
        }
    }
}

@MainActor
struct ContentView: View {

    @ObservedObject var model: ContentViewModel

    var body: some View {
        Group {
            switch model.state {
            case .loading:
                Text("Loading...")
            case .loaded:
                List(model.locations) { location in
                    Text("\(location.id)")
                }
            case let .error(error):
                Text("Error: \(error)")
            }
        }
        .onAppear {
            model.loadData()
        }
    }
}

#Preview {
    ContentView(model: .init(locationService: GithubLocationServiceProvider(githubUsername: "Voze-HQ")))
}
