#if canImport(SwiftUI)

import SwiftUI

private struct UseAutoLayoutKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

@available(iOS 13, *)
extension EnvironmentValues {
    var usesAutoLayout: Bool {
        get { self[UseAutoLayoutKey.self] }
        set { self[UseAutoLayoutKey.self] = newValue }
    }
}

public enum PreviewPositioning {
    case top
    case middle
}

private struct PreviewPosition: EnvironmentKey {
    static let defaultValue: PreviewPositioning = .middle
}

@available(iOS 13, *)
extension EnvironmentValues {
    var previewPosition: PreviewPositioning {
        get { self[PreviewPosition.self] }
        set { self[PreviewPosition.self] = newValue }
    }
}

#endif
