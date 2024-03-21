#if canImport(UIKit)
import UIKit
public typealias ViewController = UIViewController
#elseif canImport(AppKit)
import AppKit
public typealias ViewController = NSViewController
#endif
