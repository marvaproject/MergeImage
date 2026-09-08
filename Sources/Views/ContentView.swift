import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var items: [ImageItem] = []
    @State private var config = MergeConfiguration()
    @State private var mergedImage: NSImage? = nil
    @State private var isProcessing = false
    @State private var successBannerMessage: String? = nil
    @State private var lastSavedURL: URL? = nil

    @State private var updateWorkItem: DispatchWorkItem?

    var body: some View {
        HSplitView {
            // Sidebar
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 16) {
                    ImageListView(items: $items, onAddImages: openFileDialog)

                    Divider()
                        .padding(.horizontal, 14)

                    ControlsView(
                        config: $config,
                        onSaveToDownloads: saveToDownloads,
                        onSaveAs: saveAsDialog,
                        isProcessing: isProcessing,
                        hasImages: !items.isEmpty
                    )
                }
                .padding(.top, 4)
            }
            .frame(minWidth: 290, idealWidth: 320, maxWidth: 380)

            // Canvas & Preview Area
            VStack(spacing: 0) {
                if let message = successBannerMessage {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)

                        Text("Berhasil disimpan: \(message)")
                            .font(.subheadline)
                            .lineLimit(1)

                        Spacer()

                        if let url = lastSavedURL {
                            Button("Buka di Finder") {
                                NSWorkspace.shared.activateFileViewerSelecting([url])
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                        }

                        Button(action: {
                            successBannerMessage = nil
                        }) {
                            Image(systemName: "xmark")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(NSColor.controlBackgroundColor))
                    Divider()
                }

                CanvasPreviewView(
                    mergedImage: mergedImage,
                    isGenerating: isProcessing,
                    onDropFiles: handleDroppedURLs,
                    onAttachFiles: openFileDialog
                )
            }
            .frame(minWidth: 500, minHeight: 450)
        }
        .frame(minWidth: 800, minHeight: 550)
        .onChange(of: items) { _ in requestMergePreview() }
        .onChange(of: config) { _ in requestMergePreview() }
    }

    // MARK: - Image Import
    private func openFileDialog() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.image, .png, .jpeg, .tiff, .heic, .webP]

        if panel.runModal() == .OK {
            handleDroppedURLs(panel.urls)
        }
    }

    private func handleDroppedURLs(_ urls: [URL]) {
        let allowed = ["png", "jpg", "jpeg", "webp", "heic", "tiff", "bmp", "gif"]
        for url in urls {
            var isDir: ObjCBool = false
            if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir), !isDir.boolValue {
                if allowed.contains(url.pathExtension.lowercased()) {
                    if let img = NSImage(contentsOf: url) {
                        let name = url.lastPathComponent
                        items.append(ImageItem(name: name, image: img))
                    }
                }
            }
        }
    }

    // MARK: - Live Preview Generation
    private func requestMergePreview() {
        updateWorkItem?.cancel()

        guard !items.isEmpty else {
            mergedImage = nil
            return
        }

        let workItem = DispatchWorkItem {
            let currentItems = self.items
            let currentConfig = self.config
            let result = ImageMergerService.shared.mergeImages(items: currentItems, config: currentConfig, maxDimension: 1600)

            DispatchQueue.main.async {
                self.mergedImage = result
            }
        }

        updateWorkItem = workItem
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.06, execute: workItem)
    }

    // MARK: - Export Logic
    private func saveToDownloads() {
        guard !items.isEmpty else { return }
        isProcessing = true

        let exportItems = self.items
        let exportConfig = self.config

        DispatchQueue.global(qos: .userInitiated).async {
            guard let resultImage = ImageMergerService.shared.mergeImages(items: exportItems, config: exportConfig, maxDimension: nil),
                  let tiffData = resultImage.tiffRepresentation,
                  let bitmap = NSBitmapImageRep(data: tiffData),
                  let pngData = bitmap.representation(using: .png, properties: [:]) else {
                DispatchQueue.main.async { self.isProcessing = false }
                return
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd_HHmmss"
            let dateString = formatter.string(from: Date())
            let fileName = "MergeImage_\(dateString).png"

            let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
            let destinationURL = downloadsURL.appendingPathComponent(fileName)

            do {
                try pngData.write(to: destinationURL)
                DispatchQueue.main.async {
                    self.isProcessing = false
                    self.lastSavedURL = destinationURL
                    self.successBannerMessage = fileName

                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                        if self.lastSavedURL == destinationURL {
                            self.successBannerMessage = nil
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isProcessing = false
                    print("Gagal menyimpan file: \(error.localizedDescription)")
                }
            }
        }
    }

    private func saveAsDialog() {
        guard !items.isEmpty else { return }
        isProcessing = true

        let exportItems = self.items
        let exportConfig = self.config

        DispatchQueue.global(qos: .userInitiated).async {
            guard let resultImage = ImageMergerService.shared.mergeImages(items: exportItems, config: exportConfig, maxDimension: nil) else {
                DispatchQueue.main.async { self.isProcessing = false }
                return
            }

            DispatchQueue.main.async {
                self.isProcessing = false
                let savePanel = NSSavePanel()
                savePanel.canCreateDirectories = true
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd_HHmmss"
                savePanel.nameFieldStringValue = "MergeImage_\(formatter.string(from: Date())).png"
                savePanel.allowedContentTypes = [.png, .jpeg]

                if savePanel.runModal() == .OK, let targetURL = savePanel.url {
                    guard let tiffData = resultImage.tiffRepresentation,
                          let bitmap = NSBitmapImageRep(data: tiffData) else { return }

                    let isJpeg = targetURL.pathExtension.lowercased() == "jpg" || targetURL.pathExtension.lowercased() == "jpeg"
                    let fileData = isJpeg
                        ? bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.95])
                        : bitmap.representation(using: .png, properties: [:])

                    try? fileData?.write(to: targetURL)
                    self.lastSavedURL = targetURL
                    self.successBannerMessage = targetURL.lastPathComponent
                }
            }
        }
    }
}
