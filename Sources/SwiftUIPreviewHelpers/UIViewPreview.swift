#if DEBUG || ALLOW_PREVIEW_HELPER_RELEASE
import SwiftUI

class UIViewWrapper: UIView {
    let view: UIView
    
    init(view: UIView, position: PreviewPositioning) {
        self.view = view
        super.init(frame: .zero)
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        switch position {
        case .top:
            let top: NSLayoutConstraint
            if #available(iOS 11.0, *) {
                top = view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
            } else {
                top = view.topAnchor.constraint(equalTo: self.topAnchor)
            }
            NSLayoutConstraint.activate([
                view.leftAnchor.constraint(equalTo: self.leftAnchor),
                view.rightAnchor.constraint(equalTo: self.rightAnchor),
                top
            ])
        case .middle:
            NSLayoutConstraint.activate([
                view.leftAnchor.constraint(equalTo: self.leftAnchor),
                view.rightAnchor.constraint(equalTo: self.rightAnchor),
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FixedUIViewWrapper: UIView {
    let view: UIView
    
    init(view: UIView) {
        self.view = view
        super.init(frame: .zero)
        
        addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return view.frame.size
    }
}

@available(iOS 14.0, *)
public struct UIViewBridge: UIViewRepresentable {
    
    @Environment(\.usesAutoLayout) var usesAutoLayout
    @Environment(\.previewPosition) var previewPosition
    
    let build: () throws -> UIView
    
    public init(build: @escaping () throws -> UIView) {
        self.build = build
    }
    
    public func makeUIView(context: Context) -> some UIView {
        let underlyingView: UIView
        do {
            underlyingView = try build()
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
            underlyingView = view
        }
        let view: UIView
        if usesAutoLayout {
            view = UIViewWrapper(view: underlyingView, position: previewPosition)
            view.setContentHuggingPriority(.required, for: .horizontal)
            view.setContentHuggingPriority(.required, for: .vertical)
        } else {
            view = FixedUIViewWrapper(view: underlyingView)
        }
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        // no-op
    }
}

@available(iOS 14.0, *)
public struct UIViewPreview: View {
    
    let build: () throws -> UIView
    
    public init(for createView: @escaping () throws -> UIView) {
        self.build = createView
    }
    
    public init(for view: UIView) {
        self.init(for: { return view })
    }
    
    public var body: some View {
        UIViewBridge(build: build)
    }
}

@available(iOS 13.0, *)
extension View {
    public func previewWithoutAutolayout() -> some View {
        self.environment(\.usesAutoLayout, false)
    }
    
    public func previewPosition(_ position: PreviewPositioning) -> some View {
        self.environment(\.previewPosition, position)
    }
}

#endif

