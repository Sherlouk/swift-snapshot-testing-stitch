# SnapshotTesting Stitch

This is an extension to [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) which allows you to create images combining the output of multiple snapshot strategies assuming they all output to UIImage.

In essence, this allows you to have a single image which represents a single snapshotted value in multiple different configurations. This might be useful in situations, for example, where you have the same UIViewController and want a single image showing the view in multiple sizes.

Images may also have titles, allowing you to easily identify each configuration within the image.

## Usage

See tests for example usage.
