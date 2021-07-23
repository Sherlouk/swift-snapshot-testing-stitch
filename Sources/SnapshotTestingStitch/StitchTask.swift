import Foundation
import SnapshotTesting

public struct StitchTask<Value, Format> {
    
    /// The title of the individual stitched value, shown above the snapshot itself.
    public let name: String?
    
    /// The SnapshotTesting strategy used to take the snapshot itself.
    public let strategy: Snapshotting<Value, Format>
    
    /// A configuration block which allows you to alter the input value before the snapshot is taken.
    public let configure: ((inout Value) -> Void)?
    
    /// Creates a new StitchTask, providing crucial contextual information to each asset within the stitched image.
    ///
    /// - Parameters:
    ///     - name: The title of the individual stitched value, shown above the snapshot itself.
    ///     - strategy: The SnapshotTesting strategy used to take the snapshot itself.
    ///     - configure: A configuration block which allows you to alter the input value before the snapshot is taken.
    public init(
        name: String?,
        strategy: Snapshotting<Value, Format>,
        configure: ((inout Value) -> Void)? = nil
    ) {
        self.name = name
        self.strategy = strategy
        self.configure = configure
    }
}
