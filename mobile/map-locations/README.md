5. **Filtering Locations:**
    - Implement a way to filter the displayed locations by `location_type`.
        - The assumption can be made the location_types are a static set and will not change.
        - You can provide a UI (e.g., dropdown menu, segmented control, etc) that allows users to select which types of locations to display on the map.
        - Please feel free to "steal" existing UI from other application such as Google Maps, Apple Maps, Zillow, etc for filtering or craft your own.
        - Optional: Distinguish between location types through the presentation of pin or markers.

6. **Additional Details on Tap:**
   - When a user taps on a location pin, show a view with more detailed information about that location.
        - Display all `attributes` inside this detail view.
        - Please feel free to "steal" existing UI from other application such as Google Maps, Apple Maps, Zillow, etc for details or craft your own.

## Requirements

- **Documentation:**
    - Please add any contextual implementation information into Implementation section at the bottom of this `README`.
    - Add code comments when relevant
    - Add information on how to get the application up and running into the Getting Started section at the bottom of this `README`.
- **Programming Language:**
    - iOS: Please focus on using Swift
    - Android: Please focus on using Kotlin (Java is still acceptable, however Kotlin is preferred)
- **Data Fetching:**
    - You may use the std library or a 3rd party library for making HTTP request.
        - If using a 3rd party library please explain why inside the Implementation section at the bottom of this `README`.
- **Map Integration:**
    - You may use any mapping library, such as MapKit
    - Please do not use a mapping library which requires an API key
- **UI/UX:**
    - Design a user-friendly interface to interact with the map and filter locations.
    - Keep it simple. This isn't a exercise to test your design skill.
- **Filtering:**
    - Implement efficient filtering of locations by their type.

## Submission

1. Once you have completed the exercise email a link to the forked repository.

## Evaluation Criteria

- **Correctness:** Does the app fetch and display data correctly?
- **UI/UX:** Is the map view intuitive and easy to use (within reason given lack of design criteria)?
- **Code Quality:** Is the code clean, readable, follow modern architecture per environment, and well-structured?
- **Filtering:** Is filtering by location type implemented efficiently?
- **Attention to Detail:** Does the app show detailed information when a pin is tapped?

Feel free to reach out if you have any questions. Good luck, and happy coding!

Do not edit any lines above this line break.

---

## Getting Started
1. Copy the repo
2. Update the `githubUsername` to desired account
3. Update the `projectName` to desired name (if necessary, will depend on name of fork)


## Implementation

1. Project uses vanilla SwiftUI to load, display and allow interaction with the locations provided via the "API".
2. Instructions indicated that `MapView.swift` should be the main view, I made the decision to split this out so that loading and filtering could be separate considerations from the display of the map.
3. Chip style `FilterView.swift` has the filters hardcoded but could be done more elegantly either in house or with a 3rd party library.
4. Map is fairly busy and could be styled to better draw the users attention to the desired locations, names could be displayed better/differently
5. Could add a display to the annotation tap that shows additional details on the map directly and then allows navigation to the `LocationDetailView` rather than going directly there
6. Map on `LocationDetailView` isn't positioned well for displaying the location when reusing the previous calculation, it works but isn't visually appealing
