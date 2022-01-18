import Foundation
import SnapshotTestingHEIC

public enum ImageFormat {
    case png
    case heic(_ compression: CompressionQuality = .lossless)
}
