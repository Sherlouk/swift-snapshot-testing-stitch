#if canImport(UIKit)
import UIKit
public typealias Font = UIFont
public typealias ViewController = UIViewController
#elseif canImport(AppKit)
import AppKit
public typealias Font = NSFont
public typealias ViewController = NSViewController
#endif
