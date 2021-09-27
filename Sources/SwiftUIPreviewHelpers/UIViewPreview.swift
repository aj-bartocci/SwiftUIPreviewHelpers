#if DEBUG
import SwiftUI

@available(iOS 14.0, *)
public struct UIViewPreview: UIViewRepresentable {
    
    let view: UIView
    
    public init(for createView: @escaping () throws -> UIView) {
        do {
            self.view = try createView()
        } catch {
            // add a label with the error message
            let view = UIView()
            let label = UILabel()
            label.text = error.localizedDescription
            label.textColor = .label
            label.backgroundColor = .red
            label.numberOfLines = 0
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            self.view = view
        }
    }
    
    public init(for view: UIView) {
        self.init(for: { return view })
    }
    
    public func makeUIView(context: Context) -> some UIView {
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        // no-op
    }
}
#endif
