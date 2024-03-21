import UIKit

struct ImageStitcher {
    let inputs: [(title: String?, image: Image)]
    
    
    func stitch(style: StitchStyle) -> Image {
        
        // Check whether or not any inputs contain a valid title
        let allTitles = inputs
            .compactMap(\.title)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { $0.isEmpty == false }
        let includeTitles: Bool = allTitles.isEmpty == false
        
        let images = inputs.map { $0.image }
        
        let computedSize = calculateImageSize(
            images: images,
            includeTitles: includeTitles,
            style: style
        )
        
        let renderer = UIGraphicsImageRenderer(size: computedSize)
        
        // Draw the image
        let image = renderer.image { context in
            drawBackground(size: computedSize, context: context.cgContext, style: style)
            
            var xOffset = style.framePadding + style.borderWidth
            var yOffset = style.framePadding + style.borderWidth
            
            // If we have a title to display, then we'll increase the yOffset to leave space at the top
            if includeTitles {
                yOffset += style.fontSize + style.titleSpacing
            }
            
            inputs.forEach { (title, image) in
                // Draw Border
                drawBorder(
                    frame: CGRect(
                        x: xOffset,
                        y: yOffset,
                        width: image.size.width + (style.borderWidth * 2),
                        height: image.size.height + (style.borderWidth * 2)
                    ),
                    context: context.cgContext,
                    style: style
                )
                
                // Draw Image
                image.draw(at: CGPoint(
                    x: xOffset + style.borderWidth,
                    y: yOffset + style.borderWidth
                ))
                
                // Draw Title
                drawTitle(
                    frame: CGRect(
                        x: xOffset,
                        y: style.framePadding,
                        width: image.size.width,
                        height: image.size.height
                    ),
                    title: title,
                    style: style
                )
                
                // Increment horizontal offset for next image
                xOffset +=
                    image.size.width
                    + style.itemSpacing
                    + (style.borderWidth * 2)
            }
        }
        
        return image
    }
    
    func drawTitle(frame: CGRect, title: String?, style: StitchStyle) {
        guard let title = title?.trimmingCharacters(in: .whitespacesAndNewlines),
              title.isEmpty == false
        else {
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: Font.systemFont(ofSize: style.fontSize),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: style.titleColor
        ]
        
        title.draw(
            with: frame,
            options: .usesLineFragmentOrigin,
            attributes: titleAttributes,
            context: nil
        )
    }
    
    func drawBorder(frame: CGRect, context: CGContext, style: StitchStyle) {
        context.setFillColor(style.borderColor.cgColor)
        context.setStrokeColor(style.borderColor.cgColor)
        context.setLineWidth(style.borderWidth)
        
        context.addRect(frame)
        
        context.drawPath(using: .fillStroke)
    }
    
    func drawBackground(size: CGSize, context: CGContext, style: StitchStyle) {
        context.setFillColor(style.backgroundColor.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
    }
    
    func calculateImageSize(images: [Image], includeTitles: Bool, style: StitchStyle) -> CGSize {
        let largestHeight = images
            .map { $0.size.height }
            .max()
            ?? 0 // This case would only be hit if zero images were provided
        
        let computedHeight =
            largestHeight
            + (includeTitles ? style.fontSize + style.titleSpacing : 0) // Title Size
            + (style.borderWidth * 2) // Vertical Border
            + (style.framePadding * 2) // Vertical Padding
        
        let imageSumWidth = images.map {
            $0.size.width
            + (style.borderWidth * 2) // Horizontal Border
            + style.itemSpacing // Horizontal Interitem Spacing
        }.reduce(0, +)
        
        let computedWidth =
            imageSumWidth
            + (style.framePadding * 2) // Horizontal Padding
            - style.itemSpacing // Remove Final Image's Interitem Spacing
        
        return CGSize(
            width: computedWidth,
            height: computedHeight
        )
    }
    
}
