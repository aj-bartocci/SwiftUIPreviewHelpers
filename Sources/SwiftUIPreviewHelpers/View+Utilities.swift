#if DEBUG
import SwiftUI

@available(iOS 14.0, *)
public extension View {
    
    func previewSize(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        return self
        .frame(width: width, height: height, alignment: alignment)
        .previewLayout(.sizeThatFits)
    }
    
    func previewDevice(_ device: PreviewHelpers.Device) -> some View {
        return self
        .previewDevice(PreviewDevice(rawValue: device.rawValue))
    }
    
    func previewInDarkMode() -> some View {
        return self.preferredColorScheme(.dark)
        .background(Color(UIColor.systemBackground))
    }
    
    func previewInLightMode() -> some View {
        return self.preferredColorScheme(.light)
        .background(Color(UIColor.systemBackground))
    }
    
    // MARK: Accessibility
    func previewWithSizeCategory(_ size: ContentSizeCategory) -> some View {
        return self
        .environment(\.sizeCategory, size)
    }
    
    func previewWithBoldText() -> some View {
        return self
        .environment(\.legibilityWeight, .bold)
    }

}
#endif
