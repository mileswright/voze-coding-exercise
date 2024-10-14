import SwiftUI

@main
struct voze_coding_exerciseApp: App {
    // This will need to be changed for any user
    let githubUsername: String = "mileswright"
    // This will need to be changed for any project
    let projectName: String = "voze-coding-exercise"
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(model: .init(
                    locationService: GithubLocationServiceProvider(
                        githubUsername: githubUsername,
                        projectName: projectName
                    )
                ))
            }
        }
    }
}
