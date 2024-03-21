#if canImport(UIKit)
import UIKit
public typealias Color = UIColor
public typealias Font = UIFont
public typealias ViewController = UIViewController
#elseif canImport(AppKit)
import AppKit
public typealias Color = NSColor
public typealias Font = NSFont
public typealias ViewController = NSViewController
#endif
