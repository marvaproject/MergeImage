import SwiftUI
import AppKit

struct ImageListView: View {
    @Binding var items: [ImageItem]
    let onAddImages: () -> Void

    @State private var draggedItem: ImageItem? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            headerView
            if items.isEmpty {
                emptyView
            } else {
                instructionsView
                itemsList
            }
        }
    }

    // MARK: - Subviews
    private var headerView: some View {
        HStack {
            Text("Daftar Gambar (\(items.count))")
                .font(.headline)
            Spacer()
            Button(action: onAddImages) {
                Label("Tambah", systemImage: "plus.circle.fill")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding(.horizontal, 14)
        .padding(.top, 14)
    }

    private var emptyView: some View {
        VStack(spacing: 8) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 32))
                .foregroundColor(.secondary)
            Text("Tarik & lepas gambar ke sini\natau klik tombol Tambah")
                .font(.callout)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                .foregroundColor(Color.secondary.opacity(0.3))
        )
        .padding(.horizontal, 14)
    }

    private var instructionsView: some View {
        Text("💡 Seret baris untuk mengatur urutan susunan")
            .font(.caption2)
            .foregroundColor(.secondary)
            .padding(.horizontal, 14)
    }

    private var itemsList: some View {
        VStack(spacing: 6) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                rowView(index: index, item: item)
            }
        }
        .padding(.horizontal, 14)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: items)
    }

    private func rowView(index: Int, item: ImageItem) -> some View {
        let isDragging = draggedItem == item

        return HStack(spacing: 10) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 14))
                .foregroundColor(.secondary.opacity(0.7))
                .frame(width: 14)

            Text("\(index + 1)")
                .font(.caption.bold())
                .foregroundColor(.secondary)
                .frame(width: 18)

            Image(nsImage: item.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.subheadline)
                    .lineLimit(1)
                Text("\(Int(item.originalSize.width)) × \(Int(item.originalSize.height)) px")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    removeItem(at: index)
                }
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 12))
                    .foregroundColor(.red.opacity(0.85))
            }
            .buttonStyle(.plain)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isDragging ? Color.accentColor.opacity(0.15) : Color(NSColor.controlBackgroundColor))
        )
        .scaleEffect(isDragging ? 1.02 : 1.0)
        .onDrag {
            self.draggedItem = item
            return NSItemProvider(object: item.id.uuidString as NSString)
        }
        .onDrop(of: ["public.text"], delegate: ImageDropDelegate(item: item, items: $items, draggedItem: $draggedItem))
    }

    private func removeItem(at index: Int) {
        guard items.indices.contains(index) else { return }
        items.remove(at: index)
    }
}

// MARK: - Drop Delegate for Smooth Reordering
struct ImageDropDelegate: DropDelegate {
    let item: ImageItem
    @Binding var items: [ImageItem]
    @Binding var draggedItem: ImageItem?

    func dropEntered(info: DropInfo) {
        guard let dragged = draggedItem,
              dragged != item,
              let from = items.firstIndex(of: dragged),
              let to = items.firstIndex(of: item) else { return }

        if items[to] != dragged {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
}
