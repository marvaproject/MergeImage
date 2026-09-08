import SwiftUI
import AppKit

extension Color {
    var nsColor: NSColor {
        return NSColor(self)
    }

    var cgColor: CGColor {
        return NSColor(self).cgColor
    }
}
