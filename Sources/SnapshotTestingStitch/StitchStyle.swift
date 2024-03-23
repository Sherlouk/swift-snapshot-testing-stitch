import CoreGraphics

public struct StitchStyle {
    /// How large should the font size be for the optional titles which appear above each stitched image?
    public let fontSize: CGFloat
    
    /// What color should the title text be?
    public let titleColor: Color
    
    /// What color should the border be which surrounds each individual stitched image?
    public let borderColor: Color
    
    /// How thick should the border be which surrounds each individual stitched image?
    public let borderWidth: CGFloat
    
    /// How far apart should each stitched image be from another?
    public let itemSpacing: CGFloat
    
    /// How much padding should be around the frame of the image?
    public let framePadding: CGFloat
    
    /// How much spacing should be between the title and each individual stitched image?
    public let titleSpacing: CGFloat
    
    /// What color should the background of the image be?
    public let backgroundColor: Color
    
    /// Creates a definition of how a stitched snapshot should be presented.
    ///
    /// Allows you to customize certain aspects of the stitched output image.
    ///
    /// - Parameters:
    ///     - fontSize: How large should the font size be for the optional titles which appear above each stitched image?
    ///     - titleColor: What color should the title text be?
    ///     - borderColor: What color should the border be which surrounds each individual stitched image?
    ///     - borderWidth: How thick should the border be which surrounds each individual stitched image?
    ///     - itemSpacing: How far apart should each stitched image be from another?
    ///     - framePadding: How much padding should be around the frame of the image?
    ///     - titleSpacing: How much spacing should be between the title and each individual stitched image?
    ///     - backgroundColor: What color should the background of the image be?
    public init(
        fontSize: CGFloat = 20,
        titleColor: Color = .white,
        borderColor: Color = .red,
        borderWidth: CGFloat = 5,
        itemSpacing: CGFloat = 32,
        framePadding: CGFloat = 32,
        titleSpacing: CGFloat = 32,
        backgroundColor: Color = .black
    ) {
        assert(borderWidth >= 0, "The provided border width should be a positive integer, or zero if you do not want a border to be displayed.")
        assert(itemSpacing >= 0, "The provided item spacing should be a positive integer.")
        assert(fontSize >= 0, "The provided font size should be a positive integer.")
        assert(framePadding >= 0, "The provided frame padding should be a positive integer.")
        assert(titleSpacing >= 0, "The provided title spacing should be a positive integer.")
        
        self.fontSize = fontSize
        self.titleColor = titleColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.itemSpacing = itemSpacing
        self.framePadding = framePadding
        self.titleSpacing = titleSpacing
        self.backgroundColor = backgroundColor
    }
    
}
