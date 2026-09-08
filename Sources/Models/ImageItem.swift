import Foundation
import AppKit

public struct ImageItem: Identifiable, Equatable {
    public let id: UUID
    public let name: String
    public let image: NSImage
    public let originalSize: CGSize

    public init(id: UUID = UUID(), name: String, image: NSImage) {
        self.id = id
        self.name = name
        self.image = image
        self.originalSize = image.size
    }

    public static func == (lhs: ImageItem, rhs: ImageItem) -> Bool {
        lhs.id == rhs.id
    }
}
