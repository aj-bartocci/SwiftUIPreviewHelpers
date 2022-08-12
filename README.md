# SwiftUIPreviewHelpers

This package contains helper structs and functions that make working with SwiftUI Previews a bit easier. You do not need to be using SwiftUI in your app to benefit from using SwiftUI Previews. 

The package itself puts all code inside of the DEBUG macro, so that the code will not ship with release builds of your app. This means when using the library you should wrap your code in the DEBUG macro as well. This helps make sure you are not shipping preview related code with your applications. 

When [SE-0273](https://github.com/apple/swift-evolution/blob/master/proposals/0273-swiftpm-conditional-target-dependencies.md) is fully implemented you should be able to specify this package as a debug dependency as well, so that it will only be packaged for debug builds.

# Project Requirements 
- Swift 5+
- iOS 10+
- Xcode 11+

# Targeting older iOS versions
Even though SwiftUI is iOS 13+ you can still benefit from SwiftUI previews in apps that target iOS 10+. This can be done by marking the preview provider code with @available(iOS 14, *), it must be 14 because this library uses some iOS 14 features. Since you never call this code directly (Xcode generates the previews automatically) it doesn't matter that it is higher than your minimum iOS version.

If your codebase already targets iOS 14+ then you do not need to worry about using @available(iOS 14, *) for your previews. 

# UIKit Helpers

The UIKit preview helpers follow the same general format as the SwiftUI preview helpers. Each preview helper has 2 initializers, one initializer being a throwing closure that returns the UIKit element and the other taking a concreate instance of the UIKit element. 

The closure based initializers can be useful for throwing errors from mock data, configuring the elements in specific ways, or for embedding the elements inside of container views / view controllers.

The UIKit helpers use autolayout by default to pin to the superview edges, but you can call `previewWithoutAutolayout` on the `UIViewPreview` if your rendered view does not want to use autolayout.

UIViewPreviews will render content in the vertical center of the preview, but this can be changed to render from the top by calling `previewPosition(.top)`.

# Tips
When actively developing and looking at a UIKit view based preview the constraints may not update in real time. There seems to be a limitation of using UIKit in SwiftUI previews, in that simply saving the file will not trigger constraints and other UIKit elements to update. A workaround is to build the project, which seems to make the previews update accordingly. 

## UIViewControllerPreview
UIViewControllerPreview is a wrapper of UIViewControllerRepresentable that makes it easy to render UIViewControllers.

```swift
UIViewControllerPreview {
    let data = ...
    let dependency = try JSONDecoder().decode(SomeDependency.self, from: data)
    let vc = TestViewController(dependency: dependency)
    return UINavigationController(rootViewController: vc)
}
```

```swift
UIViewControllerPreview(for: TestViewController())
```

## UIViewPreview
UIViewPreview is a wrapper of UIViewRepresentable that makes it easy to render UIViews. 

```swift
UIViewPreview {
    let data = ...
    let dependency = try JSONDecoder().decode(SomeDependency.self, from: data)
    let view = TestView(dependency: dependency)
    return view
}
```

```swift
UIViewPreview(for: TestView())
```

## ThrowablePreview
ThrowablePreview is a wrapper View for rendering SwiftUI Views. This is for when mock data is needed and might throw errors. If an error is caught an error message will be rendered. 
```swift
ThrowablePreview {
    let data = ...
    let dependency = try JSONDecoder().decode(SomeDependency.self, from: data)
    let view = SwiftUITestView(dependency: dependency)
    return view
}
```

## PreviewSize
Using previewSize is helpful when working with Views so that you can size the previews to be specific sizes instead of the device size. 

```swift
func previewSize(
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    alignment: Alignment = .center
) -> some View

----------

UIViewPreview(for: TestView())
  .previewSize(width: 400, height: 300)
```

## PreviewDevice
Using previewDevice is useful for rendering the previews on specific devices. This simply wraps the existing previewDevice function with some type safety. The previewDevice function provided by Apple uses strings for rendering the devices which can be annying. This helper function simple adds some pre-defined devices so you don't need to worry about having the correct string values. 

```swift
func previewDevice(_ device: PreviewHelpers.Device) -> some View

----------

UIViewControllerPreview(for: TestViewController())
  .previewDevice(.iPhone11)

```

## PreviewInDarkMode
Using previewInDarkMode simply sets the environment values to render the view in dark mode, which is a bit easier than the default way of doing it.
```swift
func previewInDarkMode() -> some View

----------

UIViewPreview(for: TestView())
  .previewInDarkMode()
```

## PreviewInNavigationViewController (UIViewControllerPreview only)
Using previewInNavigationViewController is useful for embedding a UIViewController inside of a UIKit navigation view controller. This is mostly handy when you don't care about using a custom navigation controller. If you are using a custom navigation controller it is better to set it up in the UIViewControllerPreview initializer like the exmaple above. 

```swift
func previewInNavigationViewController() -> some View

----------

UIViewControllerPreview(for: ViewController())
  .previewInNavigationViewController()
```

## PreviewInNavigationView (UIViewControllerPreview only)
Using previewInNavigationView is useful for embedding a UIViewController inside of a SwiftUI navigation view. This is mostly handy when you don't care about using a custom navigation controller. If you are using a custom navigation controller it is better to set it up in the UIViewControllerPreview initializer like the exmaple above. 

```swift
func previewInNavigationView(displayMode: NavigationBarItem.TitleDisplayMode = .automatic) -> some View

----------

UIViewControllerPreview(for: ViewController())
  .previewInNavigationView(displayMode: .inline)
```

# Example Usage in iOS 11 project

```swift
#if DEBUG
import SwiftUI
import SwiftUIPreviewHelpers

enum TestError: Error {
    case foo
}

struct SomeStruct: Decodable { }

@available(iOS 14, *)
struct ViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            UIViewControllerPreview(for: ViewController())
            .previewInNavigationView(displayMode: .inline)
            .previewDevice(.iPhone11)
            .previewInDarkMode()
            
            UIViewControllerPreview {
                let mockData = try JSONDecoder().decode(SomeStruct.self, from: Data())
                let vc = ViewController()
                return UINavigationController(rootViewController: vc)
            }
            .previewDevice(.iPhone8)
            
            UIViewControllerPreview {
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
                return vc
            }
            
            UIViewControllerPreview {
                throw TestError.foo
            }
        }
    }
}
#endif
```
