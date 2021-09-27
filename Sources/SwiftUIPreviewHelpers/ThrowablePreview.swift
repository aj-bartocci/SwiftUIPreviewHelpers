#if DEBUG
import SwiftUI

@available(iOS 14.0, *)
public struct ThrowablePreview<Content: View>: View {
    
    private let view: AnyView
    public init(@ViewBuilder createView: () throws -> Content) {
        do {
            let view = try createView()
            self.view = AnyView(view)
        } catch {
            let errorText = Text(error.localizedDescription)
                .foregroundColor(Color(UIColor.label))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
            self.view = AnyView(errorText)
        }
    }
    
    public var body: some View {
        view
    }
}

#endif
