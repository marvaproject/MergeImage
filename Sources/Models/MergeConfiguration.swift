import Foundation
import SwiftUI

public enum MergeLayout: String, CaseIterable, Identifiable {
    case horizontal = "Horizontal"
    case vertical = "Vertikal"
    case grid = "Grid"

    public var id: String { rawValue }

    public var icon: String {
        switch self {
        case .horizontal: return "rectangle.split.3x1"
        case .vertical: return "rectangle.split.1x2"
        case .grid: return "square.grid.2x2"
        }
    }
}

public enum BorderStyle: String, CaseIterable, Identifiable {
    case all = "Semua (Luar & Tengah)"
    case innerOnly = "Hanya Tengah"
    case none = "Tanpa Border"

    public var id: String { rawValue }
}

public struct MergeConfiguration: Equatable {
    public var layout: MergeLayout = .horizontal
    public var borderStyle: BorderStyle = .all
    public var borderWidth: CGFloat = 0.0
    public var borderColor: Color = .black
    public var cornerRadius: CGFloat = 0.0
    public var gridColumns: Int = 2
    public var backgroundColor: Color = .black

    public init(
        layout: MergeLayout = .horizontal,
        borderStyle: BorderStyle = .all,
        borderWidth: CGFloat = 0.0,
        borderColor: Color = .black,
        cornerRadius: CGFloat = 0.0,
        gridColumns: Int = 2,
        backgroundColor: Color = .black
    ) {
        self.layout = layout
        self.borderStyle = borderStyle
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.gridColumns = gridColumns
        self.backgroundColor = backgroundColor
    }
}
