import SwiftUI
import AppKit

struct CanvasPreviewView: View {
    let mergedImage: NSImage?
    let isGenerating: Bool
    let onDropFiles: ([URL]) -> Void
    let onAttachFiles: () -> Void

    @State private var zoomScale: CGFloat = 1.0
    @State private var isTargeted: Bool = false

    var body: some View {
        ZStack {
            Color(NSColor.windowBackgroundColor)
                .ignoresSafeArea()

            if let image = mergedImage {
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    VStack {
                        Spacer(minLength: 30)

                        Image(nsImage: image)
                            .resizable()
                            .interpolation(.high)
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: max(150, image.size.width * zoomScale),
                                height: max(150, image.size.height * zoomScale)
                            )
                            .shadow(color: Color.black.opacity(0.18), radius: 12, x: 0, y: 6)

                        Spacer(minLength: 30)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // Floating Controls: Zoom & Quick Add/Attach button
                VStack {
                    Spacer()
                    HStack {
                        Button(action: onAttachFiles) {
                            Label("Tambah Gambar", systemImage: "plus.circle.fill")
                                .font(.subheadline)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.regular)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding(16)

                        Spacer()

                        HStack(spacing: 8) {
                            Button(action: { 
                                withAnimation(.easeOut(duration: 0.15)) {
                                    zoomScale = max(0.1, zoomScale - 0.15)
                                }
                            }) {
                                Image(systemName: "minus.magnifyingglass")
                            }
                            .buttonStyle(.plain)

                            Text("\(Int(zoomScale * 100))%")
                                .font(.caption.monospaced())
                                .frame(width: 46)

                            Button(action: { 
                                withAnimation(.easeOut(duration: 0.15)) {
                                    zoomScale = min(3.0, zoomScale + 0.15)
                                }
                            }) {
                                Image(systemName: "plus.magnifyingglass")
                            }
                            .buttonStyle(.plain)

                            Button("Reset") {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                                    zoomScale = 1.0
                                }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.mini)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.primary.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
                        .padding(16)
                    }
                }
            } else {
                // Empty drop zone with clickable Attach button
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(isTargeted ? Color.accentColor.opacity(0.15) : Color.primary.opacity(0.04))
                            .frame(width: 104, height: 104)

                        Image(systemName: isTargeted ? "arrow.down.doc.fill" : "photo.on.rectangle.angled")
                            .font(.system(size: 46))
                            .foregroundColor(isTargeted ? .accentColor : .secondary)
                    }

                    VStack(spacing: 8) {
                        Text("Seret & Lepas Gambar ke Sini")
                            .font(.title3.bold())

                        Text("Atau klik tombol di bawah untuk memilih file dari komputer")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    Button(action: onAttachFiles) {
                        HStack(spacing: 8) {
                            Image(systemName: "paperclip.circle.fill")
                                .font(.title3)
                            Text("Pilih / Lampirkan Gambar")
                                .font(.headline)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .shadow(color: Color.accentColor.opacity(0.25), radius: 8, x: 0, y: 4)

                    Text("Format yang didukung: PNG, JPG, JPEG, WebP, HEIC, TIFF")
                        .font(.caption)
                        .foregroundColor(.secondary.opacity(0.8))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    onAttachFiles()
                }
            }

            if isGenerating {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
            }
        }
        .onDrop(of: ["public.file-url"], isTargeted: $isTargeted) { providers in
            handleDrop(providers: providers)
            return true
        }
    }

    private func handleDrop(providers: [NSItemProvider]) {
        var urls: [URL] = []
        let group = DispatchGroup()
        let allowedExtensions = ["png", "jpg", "jpeg", "webp", "heic", "tiff", "bmp", "gif"]

        for provider in providers {
            group.enter()
            provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, _ in
                defer { group.leave() }
                var fileURL: URL? = nil
                if let data = item as? Data {
                    fileURL = URL(dataRepresentation: data, relativeTo: nil)
                } else if let url = item as? URL {
                    fileURL = url
                }

                if let url = fileURL {
                    var isDir: ObjCBool = false
                    if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir), !isDir.boolValue {
                        if allowedExtensions.contains(url.pathExtension.lowercased()) {
                            urls.append(url)
                        }
                    }
                }
            }
        }

        group.notify(queue: .main) {
            if !urls.isEmpty {
                onDropFiles(urls)
            }
        }
    }
}
