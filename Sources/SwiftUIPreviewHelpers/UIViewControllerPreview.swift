import SwiftUI

@available(iOS 14.0, *)
public struct UIViewControllerPreview: UIViewControllerRepresentable {
    
    private let viewController: UIViewController
    
    public init(for createVC: @escaping () throws -> UIViewController) {
        let controller: UIViewController
        do {
            controller = try createVC()
        } catch {
            // add a label with the error message
            let vc = UIViewController()
            let label = UILabel()
            label.text = error.localizedDescription
            label.textColor = .label
            label.backgroundColor = .red
            label.numberOfLines = 0
            vc.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leftAnchor.constraint(equalTo: vc.view.leftAnchor).isActive = true
            label.topAnchor.constraint(equalTo: vc.view.topAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: vc.view.rightAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
            controller = vc
        }
        self.viewController = controller
    }
    
    public init(for vc: UIViewController) {
        self.init {
            return vc
        }
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // no-op
    }
    
    /// Wraps the preview in a SwiftUI NavigationView
    public func previewInNavigationView(displayMode: NavigationBarItem.TitleDisplayMode = .automatic) -> some View {
        return NavigationView {
            self.navigationBarTitleDisplayMode(displayMode)
        }
    }
    
    /// Wraps the preview in a UIKit UINavigationViewController
    public func previewInNavigationViewController() -> some View {
        return UIViewControllerPreview {
            return UINavigationController(rootViewController: viewController)
        }
    }
}
