import UIKit

public struct StitchStyle {
    /// How large should the font size be for the optional titles which appear above each stitched image?
    public let fontSize: CGFloat
    
    /// What color should the border be which surrounds each individual stitched image?
    public let borderColor: UIColor
    
    /// How thick should the border be which surrounds each individual stitched image?
    public let borderWidth: CGFloat
    
    /// How far apart should each stitched image be from another?
    public let itemSpacing: CGFloat
    
    /// Creates a defintion of how a stitched snapshot should be presented.
    ///
    /// Allows you to customise certain aspects of the stitched output image.
    ///
    /// - Parameters:
    ///     - fontSize: How large should the font size be for the optional titles which appear above each stitched image?
    ///     - borderColor: What color should the border be which surrounds each individual stitched image?
    ///     - borderWidth: How thick should the border be which surrounds each individual stitched image?
    ///     - itemSpacing: How far apart should each stitched image be from another?
    public init(
        fontSize: CGFloat = 20,
        borderColor: UIColor = .red,
        borderWidth: CGFloat = 5,
        itemSpacing: CGFloat = 32
    ) {
        assert(borderWidth >= 0, "The provided border width should be a positive integer, or zero if you do not want a border to be displayed.")
        assert(itemSpacing >= 0, "The provided item spacing should be a positive integer.")
        assert(fontSize >= 0, "The provided font size should be a positive integer.")
        
        self.fontSize = fontSize
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.itemSpacing = itemSpacing
    }
    
}
