import XCTest
import SnapshotTesting
@testable import SnapshotTestingStitch

final class SnapshotTestingStitchTests: XCTestCase {
    
    let isRecording: Bool = false
    
    func test_withTitles() {
        assertSnapshot(
            matching: createTestViewController(),
            as: .stitch(
                strategies: [
                    ("iPhone 8", .image(on: .iPhone8)),
                    ("iPhone 8 Plus", .image(on: .iPhone8Plus)),
                ]
            ),
            record: isRecording
        )
    }
    
    func test_withoutTitles() {
        assertSnapshot(
            matching: createTestViewController(),
            as: .stitch(
                strategies: [
                    .image(on: .iPhone8),
                    .image(on: .iPhone8Plus),
                ]
            ),
            record: isRecording
        )
    }
    
    func test_withoutBorder() {
        assertSnapshot(
            matching: createTestViewController(),
            as: .stitch(
                strategies: [
                    ("iPhone 8", .image(on: .iPhone8)),
                    ("iPhone 8 Plus", .image(on: .iPhone8Plus)),
                ],
                style: .init(borderWidth: 0)
            ),
            record: isRecording
        )
    }
    
    func test_withManyDevices() {
        assertSnapshot(
            matching: createTestViewController(),
            as: .stitch(
                strategies: [
                    ("iPhone 8", .image(on: .iPhone8)),
                    ("iPhone 8 Plus", .image(on: .iPhone8Plus)),
                    ("iPhone X", .image(on: .iPhoneX)),
                    ("iPhone SE", .image(on: .iPhoneSe)),
                    ("iPhone Xr", .image(on: .iPhoneXr)),
                    ("iPhone Xs Max", .image(on: .iPhoneXsMax)),
                    ("iPhone Xs Max (Landscape)", .image(on: .iPhoneXsMax(.landscape))),
                ]
            ),
            record: isRecording
        )
    }
    
    func test_withView() {
        assertSnapshot(
            matching: createTestView(),
            as: .stitch(
                strategies: [
                    ("100x", .image(size: CGSize(width: 100, height: 100))),
                    ("250x", .image(size: CGSize(width: 250, height: 250))),
                ]
            ),
            record: isRecording
        )
    }
    
    func test_withNoStrategies() {
        // You actually get a compiler warning for ambiguity by default, so you have to go through some loops to pass
        // literally nothing through.
        let tasks: [Snapshotting<UIView, UIImage>] = []
        
        assertSnapshot(
            matching: createTestView(),
            as: .stitch(strategies: tasks),
            record: isRecording
        )
    }
    
    // MARK: - Helpers
    
    func createTestViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .blue
        
        return viewController
    }
    
    func createTestView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .green
        
        return view
    }
    
}
