import UIKit
import SnapshotTesting
import SnapshotTestingHEIC

public extension Snapshotting where Format == UIImage {
    /// Stitches multiple visual snapshot strategies into a single image asset.
    ///
    /// - Parameters:
    ///   - tasks: The unnamed tasks which should be carried out, in the order that they should be displayed.
    ///     Any strategy can be used as long as the output format is UIImage.
    ///   - style: The style configuration which allows for you to customise the appearance of the output image,
    ///     including but not limited to the item spacing, and optional image borders.
    ///   - precision: The percentage of pixels that must match in the final comparison
    ///   in order for the test to successfully pass.
    ///   - perceptualPrecision: The percentage a pixel must match the source pixel to be considered a match. [98-99% mimics the precision of the human eye.](http://zschuessler.github.io/DeltaE/learn/#toc-defining-delta-e)
    ///   - format: The desired image format to use when writing to an image destination.
    ///   It would default to PNG for backwards compatibility.
    static func stitch(
        strategies tasks: [Snapshotting<Value, Format>],
        style: StitchStyle = .init(),
        precision: Float = 1,
        perceptualPrecision: Float = 1,
        format: ImageFormat = .png
    ) -> Snapshotting {
        // Default to an empty string, if they choose not to provide one.
        stitch(
            strategies: tasks.map { .init(name: nil, strategy: $0, configure: nil) },
            style: style,
            precision: precision,
            perceptualPrecision: perceptualPrecision,
            format: format
        )
    }

    /// Stitches multiple visual snapshot strategies into a single image asset.
    ///
    /// - Parameters:
    ///   - tasks: The named tasks which should be carried out, in the order that they should be displayed.
    ///   Titles will be displayed above their respectful image, allowing for easier identification.
    ///   Any strategy can be used as long as the output format is UIImage.
    ///   - style: The style configuration which allows for you to customise the appearance of the output image,
    ///   including but not limited to the item spacing, and optional image borders.
    ///   - precision: The percentage of pixels that must match in the final comparison
    ///   in order for the test to successfully pass.
    ///   - perceptualPrecision: The percentage a pixel must match the source pixel to be considered a match. [98-99% mimics the precision of the human eye.](http://zschuessler.github.io/DeltaE/learn/#toc-defining-delta-e)
    ///   - format: The desired image format to use when writing to an image destination.
    ///   It would default to PNG for backwards compatibility.
    static func stitch(
        strategies tasks: [(name: String, strategy: Snapshotting<Value, Format>)],
        style: StitchStyle = .init(),
        precision: Float = 1,
        perceptualPrecision: Float = 1,
        format: ImageFormat = .png
    ) -> Snapshotting {
        stitch(
            strategies: tasks.map { .init(name: $0.name, strategy: $0.strategy, configure: nil) },
            style: style,
            precision: precision,
            perceptualPrecision: perceptualPrecision,
            format: format
        )
    }

    /// Stitches multiple visual snapshot strategies into a single image asset.
    ///
    /// - Parameters:
    ///   - tasks: The tasks which should be carried out, in the order that they should be displayed.
    ///   Tasks can include a title which will be displayed above their respectful image,
    ///   allowing for easier identification. Any strategy can be used as long as the output format is UIImage.
    ///   Tasks can can also contain a configuration block which allows for you to modify
    ///   the value just before it's snapshot is taken.
    ///   - style: The style configuration which allows for you to customise the appearance of the output image,
    ///   including but not limited to the item spacing, and optional image borders.
    ///   - precision: The percentage of pixels that must match in the final comparison
    ///   in order for the test to successfully pass.
    ///   - perceptualPrecision: The percentage a pixel must match the source pixel to be considered a match. [98-99% mimics the precision of the human eye.](http://zschuessler.github.io/DeltaE/learn/#toc-defining-delta-e)
    ///   - format: The desired image format to use when writing to an image destination.
    ///   It would default to PNG for backwards compatibility.
    static func stitch(
        strategies tasks: [StitchTask<Value, Format>],
        style: StitchStyle = .init(),
        precision: Float = 1,
        perceptualPrecision: Float = 1,
        format: ImageFormat = .png
    ) -> Snapshotting {
        let internalStrategy: Snapshotting<UIViewController, UIImage>

        switch format {
            case .png:
                internalStrategy = .image(precision: precision, perceptualPrecision: perceptualPrecision)
            case .heic(let compressionQuality):
                internalStrategy = .imageHEIC(precision: precision, compressionQuality: compressionQuality)
        }

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
                var values = [(index: Int, title: String?, output: UIImage)]()

                // Loop over each of the user-provided strategies, snapshot them,
                // store the output, and update the dispatch group.
                tasks.enumerated().forEach { index, task in
                    dispatchGroup.enter()

                    var mutableValue = value
                    task.configure?(&mutableValue)

                    task.strategy.snapshot(mutableValue).run { output in
                        values.append((index, task.name, output))
                        dispatchGroup.leave()
                    }
                }

                // Once all strategies have been completed...
                dispatchGroup.notify(queue: .main) {
                    // Sort values based on input order
                    let sortedValues: [(String?, UIImage)] = values
                        .sorted(by: { lhs, rhs in lhs.index < rhs.index })
                        .map { result in (result.title, result.output) }

                    // Check to ensure all tasks have been returned
                    assert(
                        sortedValues.count == tasks.count,
                        "Inconsistant number of outputted values in comparison to inputted strategies"
                    )

                    // Stitch them together, and callback to the snapshot testing library.
                    let image = ImageStitcher(inputs: sortedValues).stitch(style: style)
                    callback(image)
                }
            }
        }
    }
}
