import SwiftUI

@main
struct voze_coding_exerciseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: .init(
                locationService: GithubLocationServiceProvider(githubUsername: "mileswright")
            ))
        }
    }
}
