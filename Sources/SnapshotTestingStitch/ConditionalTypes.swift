#if canImport(UIKit)
import UIKit
public typealias Image = UIImage
public typealias Color = UIColor
public typealias Font = UIFont
public typealias ViewController = UIViewController
#elseif canImport(AppKit)
import AppKit
public typealias Image = NSImage
public typealias Color = NSColor
public typealias Font = NSFont
public typealias ViewController = NSViewController
#endif
