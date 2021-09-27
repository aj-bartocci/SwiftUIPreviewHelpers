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
    
    func previewDevice(_ device: SwiftUIPreviewHelpers.Device) -> some View {
        return self
        .previewDevice(PreviewDevice(rawValue: device.rawValue))
    }
    
    func previewInDarkMode() -> some View {
        return self.preferredColorScheme(.dark)
        .background(Color(UIColor.systemBackground))
    }
}
#endif
