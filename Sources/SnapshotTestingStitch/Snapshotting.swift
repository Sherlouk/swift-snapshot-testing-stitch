import UIKit
import SnapshotTesting

extension Snapshotting where Format == UIImage {
    
    public static func stitch(
        strategies: [Snapshotting<Value, Format>],
        style: StitchStyle = .init()
    ) -> Snapshotting {
        // Default to an empty string, if they choose not to provide one.
        stitch(strategies: strategies.map { ("", $0) }, style: style)
    }
    
    public static func stitch(
        strategies: [(name: String, strategy: Snapshotting<Value, Format>)],
        style: StitchStyle = .init()
    ) -> Snapshotting {
        let internalStrategy: Snapshotting<UIViewController, UIImage> = .image
        
        return Snapshotting(
            pathExtension: internalStrategy.pathExtension,
            diffing: internalStrategy.diffing
        ) { value in
            Async<UIImage> { callback in
                // Create a dispatch group to keep track of the remaining tasks
                let dispatchGroup = DispatchGroup()
                
                // Create an array to store the final outputs to be stitched
                var values = [(String, UIImage)]()
                
                // Loop over each of the user-provided strategies, snapshot them,
                // store the output, and update the dispatch group.
                strategies.forEach { strategy in
                    dispatchGroup.enter()
                    
                    strategy.strategy.snapshot(value).run { output in
                        values.append((strategy.name, output))
                        dispatchGroup.leave()
                    }
                }
                
                // Once all strategies have been completed...
                dispatchGroup.notify(queue: .main) {
                    // Sort values based on input order
                    let comparableValues = strategies.compactMap { (name, _) in
                        values.first(where: { $0.0 == name })
                    }
                    
                    // Stitch them together, and callback to the snapshot testing library.
                    let image = ImageStitcher(inputs: comparableValues).stitch(style: style)
                    callback(image)
                }
            }
        }
    }
    
}
