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

    func fetchLocations() {
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

    func loadingViewDidAppear() {
        fetchLocations()
    }

    func retryButtonTapped() {
        fetchLocations()
    }

}

@MainActor
struct ContentView: View {

    @ObservedObject var model: ContentViewModel

    var body: some View {
        Group {
            switch model.state {
            case .loading:
                loadingView()
            case .loaded:
                MapView(locations: $model.locations)
            case let .error(error):
                errorView(error)
            }
        }
    }

    @ViewBuilder
    private func loadingView() -> some View {
        HStack {
            ProgressView()
                .progressViewStyle(.circular)
            Text("Loading...")
        }
        .onAppear {
            model.loadingViewDidAppear()
        }
    }

    @ViewBuilder
    private func errorView(_ error: Error) -> some View {
        VStack(spacing:  16 ) {
            Text("Error: \(error.localizedDescription)")
            Button("Retry") {
                model.retryButtonTapped()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(model: .init(locationService: GithubLocationServiceProvider(githubUsername: "mileswright")))
}
