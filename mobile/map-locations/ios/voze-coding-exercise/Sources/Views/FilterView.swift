import SwiftUI

struct FilterView: View {
    @Binding var filters: [LocationTypeFilter]

    var filterTapped: () -> Void
    var resetFiltersTapped: () -> Void

    var body: some View {
        VStack {
            HStack {
                Text("Filters")
                    .font(.headline)
                Spacer()
                Button {
                    resetFiltersTapped()
                } label: {
                    Text("Reset")
                }
            }
            .padding(.bottom, 8)

            // Hardcoding this given they don't change, could use a library
            // or our own implmentation of a chip view where they fill in nicely
            Group {
                VStack {
                    HStack(spacing: 21) {
                        filterButtonFor(filters[0]) { filters[0].active.toggle() }
                        filterButtonFor(filters[1]) { filters[1].active.toggle() }
                        filterButtonFor(filters[2]) { filters[2].active.toggle() }
                    }
                    .padding(.bottom, 8)

                    HStack(spacing: 21) {
                        filterButtonFor(filters[3]) { filters[3].active.toggle() }
                        filterButtonFor(filters[4]) { filters[4].active.toggle() }
                        filterButtonFor(filters[5]) { filters[5].active.toggle() }
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }

    private func filterButtonFor(_ filter: LocationTypeFilter, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation {
                action()
                filterTapped()
            }
        } label: {
            HStack {
                filter.locationType.icon
                    .foregroundStyle(filter.active ? filter.locationType.color : filter.locationType.inactiveColor)
                Text(filter.locationType.title)
                    .foregroundStyle(filter.active ? filter.locationType.color : filter.locationType.inactiveColor)
            }
            .padding(8)
            .background(.gray.opacity(0.15))
            .cornerRadius(8)
        }

    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var filters = LocationType.allCases.sorted { $0.title < $1.title }.map { $0.asLocationTypeFilter }

        var body: some View {
            VStack {
                FilterView(
                    filters: $filters,
                    filterTapped: {
                        // Updates map locations
                    },
                    resetFiltersTapped: {
                        filters = LocationType.allCases.map { $0.asLocationTypeFilter }
                    }
                )
            }
        }
    }

    return PreviewWrapper()
}
