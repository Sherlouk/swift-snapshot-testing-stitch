import UIKit
import SnapshotTesting

extension Snapshotting where Format == UIImage {
    
    public static func stitch(
        strategies: [Snapshotting<Value, Format>],
        style: StitchStyle = .init(),
        precision: Float = 1
    ) -> Snapshotting {
        // Default to an empty string, if they choose not to provide one.
        stitch(strategies: strategies.map { ("", $0) }, style: style, precision: precision)
    }
    
    public static func stitch(
        strategies tasks: [(name: String, strategy: Snapshotting<Value, Format>)],
        style: StitchStyle = .init(),
        precision: Float = 1
    ) -> Snapshotting {
        let internalStrategy: Snapshotting<UIViewController, UIImage> = .image(precision: precision)
        
        return Snapshotting(
            pathExtension: internalStrategy.pathExtension,
            diffing: internalStrategy.diffing
        ) { value in
            Async<UIImage> { callback in
                // Fail fast: Ensure we have tasks to complete, otherwise return an empty image.
                //
                // An empty image will render an error as part of the SnapshotTesting flow.
                guard tasks.isEmpty == false else {
                    callback(UIImage())
                    return
                }
                
                // Create a dispatch group to keep track of the remaining tasks
                let dispatchGroup = DispatchGroup()
                
                // Create an array to store the final outputs to be stitched
                var values = [(index: Int, title: String, output: UIImage)]()
                
                // Loop over each of the user-provided strategies, snapshot them,
                // store the output, and update the dispatch group.
                tasks.enumerated().forEach { index, task in
                    dispatchGroup.enter()
                    
                    task.strategy.snapshot(value).run { output in
                        values.append((index, task.name, output))
                        dispatchGroup.leave()
                    }
                }
                
                // Once all strategies have been completed...
                dispatchGroup.notify(queue: .main) {
                    // Sort values based on input order
                    let sortedValues: [(String, UIImage)] = values
                        .sorted(by: { lhs, rhs in lhs.index < rhs.index })
                        .map { result in (result.title, result.output) }
                    
                    // Check to ensure all tasks have been returned
                    assert(sortedValues.count == tasks.count,
                           "Inconsistant number of outputted values in comparison to inputted strategies")
                    
                    // Stitch them together, and callback to the snapshot testing library.
                    let image = ImageStitcher(inputs: sortedValues).stitch(style: style)
                    callback(image)
                }
            }
        }
    }
    
}
