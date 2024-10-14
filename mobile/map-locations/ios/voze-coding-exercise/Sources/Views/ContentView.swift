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
    var locations: [Location] = [] {
        didSet {
            self.locationByLocationType = Dictionary(grouping: locations, by: { $0.locationType })
            self.setMapLocations()
        }
    }
    var locationByLocationType: [LocationType: [Location]] = [:]
    var filters: [LocationTypeFilter] = LocationType.allCases.map { $0.asLocationTypeFilter }
    var mapLocations: [Location] = []
    var isFilterViewShowing: Bool = false

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

    private func setMapLocations() {
        var result: [Location] = []

        let activeFilters = filters.filter { $0.active }
        for activeFilter in activeFilters {
            print(activeFilter)
            result.append(contentsOf: locationByLocationType[activeFilter.locationType] ?? [])
        }

        self.mapLocations = result
    }

    func loadingViewDidAppear() {
        fetchLocations()
    }

    func retryButtonTapped() {
        fetchLocations()
    }

    func resetFilters() {
        filters = LocationType.allCases.map { $0.asLocationTypeFilter }
        setMapLocations()
    }

    func filterTapped() {
        setMapLocations()
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
                MapView(locations: $model.mapLocations)
            case let .error(error):
                errorView(error)
            }
        }
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Voze Locations")
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    model.isFilterViewShowing.toggle()
                } label: {
                    Image(
                        systemName: model.isFilterViewShowing ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                }
            }
        }
        .sheet(isPresented: $model.isFilterViewShowing) {
            FilterView(filters: $model.filters) {
                model.filterTapped()
            } resetFiltersTapped: {
                model.resetFilters()
            }
            .presentationDetents([.medium, .fraction(0.35)])
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
    ContentView(model: .init(
        locationService: GithubLocationServiceProvider(
            githubUsername: "mileswright",
            projectName: "voze-coding-exercise"
        )
    ))
}
