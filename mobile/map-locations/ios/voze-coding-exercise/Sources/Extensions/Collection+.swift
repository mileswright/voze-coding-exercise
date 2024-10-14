import Foundation

extension Collection {
    func firstOfTypeOrNil<T>(as type: T.Type) -> T? {
        for item in self {
            if let typed = item as? T { return typed }
        }
        return nil
    }
}
