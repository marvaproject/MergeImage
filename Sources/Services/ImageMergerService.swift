import Foundation
import AppKit
import CoreGraphics
import ImageIO

public final class ImageMergerService {
    public static let shared = ImageMergerService()

    private init() {}

    /// Merges an array of ImageItems into a single NSImage based on configuration.
    /// - Parameters:
    ///   - items: Array of ImageItems
    ///   - config: Layout and styling configuration
    ///   - maxDimension: If provided (e.g. 1600 for live preview), scales the rendering canvas down for ultra-fast response. If nil, renders at 100% native resolution.
    public func mergeImages(items: [ImageItem], config: MergeConfiguration, maxDimension: CGFloat? = nil) -> NSImage? {
        guard !items.isEmpty else { return nil }
        if items.count == 1 && config.borderStyle == .none && maxDimension == nil {
            return items[0].image
        }

        switch config.layout {
        case .horizontal:
            return mergeHorizontal(items: items, config: config, maxDimension: maxDimension)
        case .vertical:
            return mergeVertical(items: items, config: config, maxDimension: maxDimension)
        case .grid:
            return mergeGrid(items: items, config: config, maxDimension: maxDimension)
        }
    }

    // MARK: - Horizontal Merging
    private func mergeHorizontal(items: [ImageItem], config: MergeConfiguration, maxDimension: CGFloat?) -> NSImage? {
        let targetHeight = items.map { $0.originalSize.height }.max() ?? 1000.0
        guard targetHeight > 0 else { return nil }

        let scaledSizes: [CGSize] = items.map { item in
            let aspect = item.originalSize.width / max(item.originalSize.height, 1.0)
            return CGSize(width: targetHeight * aspect, height: targetHeight)
        }

        let border = (config.borderStyle == .none) ? 0.0 : config.borderWidth
        let hasOuter = (config.borderStyle == .all)
        let count = CGFloat(items.count)

        let innerDividers = max(0, count - 1)
        let totalImageWidth = scaledSizes.reduce(0) { $0 + $1.width }

        let canvasWidth: CGFloat
        let canvasHeight: CGFloat

        if hasOuter {
            canvasWidth = (border * 2) + (innerDividers * border) + totalImageWidth
            canvasHeight = (border * 2) + targetHeight
        } else {
            canvasWidth = (innerDividers * border) + totalImageWidth
            canvasHeight = targetHeight
        }

        // Apply downscaling scaleFactor for preview if needed
        let fullSize = CGSize(width: canvasWidth, height: canvasHeight)
        let scale = calculateScale(for: fullSize, maxDimension: maxDimension)
        let outputSize = CGSize(width: canvasWidth * scale, height: canvasHeight * scale)
        let scaledBorder = border * scale
        let scaledCornerRadius = config.cornerRadius * scale

        return renderCanvas(size: outputSize, config: config) { ctx in
            var currentX: CGFloat = hasOuter ? scaledBorder : 0.0
            let startY: CGFloat = hasOuter ? scaledBorder : 0.0

            for (index, item) in items.enumerated() {
                let imgW = scaledSizes[index].width * scale
                let imgH = scaledSizes[index].height * scale
                let rect = CGRect(x: currentX, y: startY, width: imgW, height: imgH)

                drawImage(item.image, in: rect, context: ctx, config: config, cornerRadius: scaledCornerRadius)
                currentX += imgW + scaledBorder
            }
        }
    }

    // MARK: - Vertical Merging
    private func mergeVertical(items: [ImageItem], config: MergeConfiguration, maxDimension: CGFloat?) -> NSImage? {
        let targetWidth = items.map { $0.originalSize.width }.max() ?? 1000.0
        guard targetWidth > 0 else { return nil }

        let scaledSizes: [CGSize] = items.map { item in
            let aspect = item.originalSize.height / max(item.originalSize.width, 1.0)
            return CGSize(width: targetWidth, height: targetWidth * aspect)
        }

        let border = (config.borderStyle == .none) ? 0.0 : config.borderWidth
        let hasOuter = (config.borderStyle == .all)
        let count = CGFloat(items.count)

        let innerDividers = max(0, count - 1)
        let totalImageHeight = scaledSizes.reduce(0) { $0 + $1.height }

        let canvasWidth: CGFloat
        let canvasHeight: CGFloat

        if hasOuter {
            canvasWidth = (border * 2) + targetWidth
            canvasHeight = (border * 2) + (innerDividers * border) + totalImageHeight
        } else {
            canvasWidth = targetWidth
            canvasHeight = (innerDividers * border) + totalImageHeight
        }

        let fullSize = CGSize(width: canvasWidth, height: canvasHeight)
        let scale = calculateScale(for: fullSize, maxDimension: maxDimension)
        let outputSize = CGSize(width: canvasWidth * scale, height: canvasHeight * scale)
        let scaledBorder = border * scale
        let scaledCornerRadius = config.cornerRadius * scale

        return renderCanvas(size: outputSize, config: config) { ctx in
            var currentY: CGFloat = hasOuter ? (outputSize.height - scaledBorder) : outputSize.height

            for (index, item) in items.enumerated() {
                let imgW = scaledSizes[index].width * scale
                let imgH = scaledSizes[index].height * scale
                currentY -= imgH
                let rect = CGRect(x: hasOuter ? scaledBorder : 0, y: currentY, width: imgW, height: imgH)

                drawImage(item.image, in: rect, context: ctx, config: config, cornerRadius: scaledCornerRadius)
                currentY -= scaledBorder
            }
        }
    }

    // MARK: - Grid Merging
    private func mergeGrid(items: [ImageItem], config: MergeConfiguration, maxDimension: CGFloat?) -> NSImage? {
        let cols = max(1, config.gridColumns)
        let totalItems = items.count
        let rows = Int(ceil(Double(totalItems) / Double(cols)))

        let cellWidth = items.map { $0.originalSize.width }.max() ?? 800.0
        let cellHeight = items.map { $0.originalSize.height }.max() ?? 800.0

        let border = (config.borderStyle == .none) ? 0.0 : config.borderWidth
        let hasOuter = (config.borderStyle == .all)

        let canvasWidth: CGFloat
        let canvasHeight: CGFloat

        if hasOuter {
            canvasWidth = (CGFloat(cols) * cellWidth) + (CGFloat(cols + 1) * border)
            canvasHeight = (CGFloat(rows) * cellHeight) + (CGFloat(rows + 1) * border)
        } else {
            canvasWidth = (CGFloat(cols) * cellWidth) + (CGFloat(max(0, cols - 1)) * border)
            canvasHeight = (CGFloat(rows) * cellHeight) + (CGFloat(max(0, rows - 1)) * border)
        }

        let fullSize = CGSize(width: canvasWidth, height: canvasHeight)
        let scale = calculateScale(for: fullSize, maxDimension: maxDimension)
        let outputSize = CGSize(width: canvasWidth * scale, height: canvasHeight * scale)
        let scaledCellW = cellWidth * scale
        let scaledCellH = cellHeight * scale
        let scaledBorder = border * scale
        let scaledCornerRadius = config.cornerRadius * scale

        return renderCanvas(size: outputSize, config: config) { ctx in
            let initialY = hasOuter ? (outputSize.height - scaledBorder) : outputSize.height
            let initialX = hasOuter ? scaledBorder : 0.0

            for (index, item) in items.enumerated() {
                let r = index / cols
                let c = index % cols

                let x = initialX + CGFloat(c) * (scaledCellW + scaledBorder)
                let y = initialY - CGFloat(r + 1) * scaledCellH - CGFloat(r) * scaledBorder
                let cellRect = CGRect(x: x, y: y, width: scaledCellW, height: scaledCellH)

                drawImage(item.image, in: cellRect, context: ctx, config: config, cornerRadius: scaledCornerRadius, aspectFit: true)
            }
        }
    }

    // MARK: - Helpers
    private func calculateScale(for size: CGSize, maxDimension: CGFloat?) -> CGFloat {
        guard let maxDimension = maxDimension, maxDimension > 0 else { return 1.0 }
        let currentMax = max(size.width, size.height)
        if currentMax > maxDimension {
            return maxDimension / currentMax
        }
        return 1.0
    }

    private func renderCanvas(size: CGSize, config: MergeConfiguration, drawingBlock: (CGContext) -> Void) -> NSImage? {
        guard size.width > 0 && size.height > 0 else { return nil }

        let width = Int(ceil(size.width))
        let height = Int(ceil(size.height))

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            return nil
        }

        context.interpolationQuality = .high

        let fullRect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        if config.borderStyle != .none && config.borderWidth > 0 {
            context.setFillColor(config.borderColor.cgColor)
            context.fill(fullRect)
        } else {
            context.clear(fullRect)
        }

        drawingBlock(context)

        guard let cgImage = context.makeImage() else { return nil }
        return NSImage(cgImage: cgImage, size: size)
    }

    private func drawImage(_ image: NSImage, in rect: CGRect, context: CGContext, config: MergeConfiguration, cornerRadius: CGFloat, aspectFit: Bool = false) {
        context.saveGState()

        if config.borderStyle == .all && cornerRadius > 0 {
            let radius = min(cornerRadius, min(rect.width, rect.height) / 2.0)
            let path = CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil)
            context.addPath(path)
            context.clip()
        }

        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            context.restoreGState()
            return
        }

        if aspectFit {
            let imgW = CGFloat(cgImage.width)
            let imgH = CGFloat(cgImage.height)
            let aspect = imgW / max(imgH, 1.0)
            let rectAspect = rect.width / max(rect.height, 1.0)

            var drawRect = rect
            if aspect > rectAspect {
                let targetH = rect.width / aspect
                drawRect.origin.y += (rect.height - targetH) / 2.0
                drawRect.size.height = targetH
            } else {
                let targetW = rect.height * aspect
                drawRect.origin.x += (rect.width - targetW) / 2.0
                drawRect.size.width = targetW
            }
            context.draw(cgImage, in: drawRect)
        } else {
            context.draw(cgImage, in: rect)
        }

        context.restoreGState()
    }
}
