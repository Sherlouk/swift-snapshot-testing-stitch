import UIKit

struct ImageStitcher {
    
    let inputs: [(title: String, image: UIImage)]
    
    func stitch(style: StitchStyle) -> UIImage {
        
        let includeTitles: Bool = inputs.map { $0.title }.allSatisfy { $0 == "" } == false
        let images = inputs.map { $0.image }
        
        // Calculate how large the full image will be based on the inputs
        let framePadding: CGFloat = style.itemSpacing
        
        let largestHeight = images.map { $0.size.height }.max() ?? 0
        let computedHeight =
            largestHeight +
            (includeTitles ? style.fontSize + framePadding : 0) + // Title Size
            (style.borderWidth * 2) + // Vertical Border
            (framePadding * 2) // Vertical Padding
        
        let imageSumWidth = images.map {
            $0.size.width +
            (style.borderWidth * 2) + // Horizontal Border
            style.itemSpacing // Horizontal Interitem Spacing
        }.reduce(0, +)
        
        let computedWidth =
            imageSumWidth +
            (framePadding * 2) - // Horizontal Padding
            style.itemSpacing // Remove Final Image's Interitem Spacing
        
        // Create renderer with correct image size
        let computedSize = CGSize(
            width: computedWidth,
            height: computedHeight
        )
        
        let renderer = UIGraphicsImageRenderer(size: computedSize)
        
        // Setup title styling
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: style.fontSize),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.white
        ]
        
        // Draw the image
        let image = renderer.image { context in
            context.cgContext.setFillColor(UIColor.black.cgColor)
            context.cgContext.fill(CGRect(origin: .zero, size: computedSize))
            
            var xOffset = framePadding + style.borderWidth
            var yOffset = framePadding + style.borderWidth
            
            // If we have a title to display, then we'll increase the yOffset to leave space at the top
            if includeTitles {
                yOffset += style.fontSize + framePadding
            }
            
            inputs.forEach { (title, image) in
                // Draw Border
                context.cgContext.setFillColor(style.borderColor.cgColor)
                context.cgContext.setStrokeColor(style.borderColor.cgColor)
                context.cgContext.setLineWidth(style.borderWidth)
                
                context.cgContext.addRect(CGRect(
                    x: xOffset,
                    y: yOffset,
                    width: image.size.width + (style.borderWidth * 2),
                    height: image.size.height + (style.borderWidth * 2)
                ))
                
                context.cgContext.drawPath(using: .fillStroke)
                
                // Draw Image
                image.draw(at: CGPoint(
                    x: xOffset + style.borderWidth,
                    y: yOffset + style.borderWidth
                ))
                
                // Draw Title
                if title.isEmpty == false {
                    title.draw(
                        with: CGRect(
                            x: xOffset,
                            y: framePadding,
                            width: image.size.width,
                            height: image.size.height
                        ),
                        options: .usesLineFragmentOrigin,
                        attributes: titleAttributes,
                        context: nil
                    )
                }
                
                // Increment horizontal offset for next image
                xOffset +=
                    image.size.width +
                    style.itemSpacing +
                    (style.borderWidth * 2)
            }
        }
        
        return image
    }
    
}
