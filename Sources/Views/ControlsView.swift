import SwiftUI

struct ControlsView: View {
    @Binding var config: MergeConfiguration
    let onSaveToDownloads: () -> Void
    let onSaveAs: () -> Void
    let isProcessing: Bool
    let hasImages: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // MARK: - Layout Mode
            VStack(alignment: .leading, spacing: 8) {
                Text("Tata Letak (Layout)")
                    .font(.headline)
                
                Picker("Layout", selection: $config.layout) {
                    ForEach(MergeLayout.allCases) { layout in
                        Label(layout.rawValue, systemImage: layout.icon).tag(layout)
                    }
                }
                .pickerStyle(.segmented)

                if config.layout == .grid {
                    HStack {
                        Text("Jumlah Kolom:")
                            .font(.subheadline)
                        Stepper(value: $config.gridColumns, in: 1...10) {
                            Text("\(config.gridColumns) Kolom")
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.top, 4)
                }
            }

            Divider()

            // MARK: - Border Settings
            VStack(alignment: .leading, spacing: 12) {
                Text("Pengaturan Border")
                    .font(.headline)

                Picker("Gaya Border", selection: $config.borderStyle) {
                    ForEach(BorderStyle.allCases) { style in
                        Text(style.rawValue).tag(style)
                    }
                }
                .pickerStyle(.radioGroup)

                if config.borderStyle != .none {
                    // Border Thickness (0 - 100 px, default 0)
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Ketebalan Border")
                                .font(.subheadline)
                            Spacer()
                            Text("\(Int(config.borderWidth)) px")
                                .font(.caption.monospaced())
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $config.borderWidth, in: 0...100, step: 1)
                    }

                    // Border Color (Default black)
                    HStack {
                        Text("Warna Border")
                            .font(.subheadline)
                        Spacer()
                        ColorPicker("", selection: $config.borderColor)
                            .labelsHidden()
                    }

                    // Corner Radius (Rounded) - aktif jika borderStyle == .all (0 - 100 px, default 0)
                    if config.borderStyle == .all {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Sudut Melengkung (Rounded)")
                                    .font(.subheadline)
                                Spacer()
                                Text("\(Int(config.cornerRadius)) px")
                                    .font(.caption.monospaced())
                                    .foregroundColor(.secondary)
                            }
                            Slider(value: $config.cornerRadius, in: 0...100, step: 1)
                        }
                        .transition(.opacity)
                    }
                }
            }

            Divider()

            // MARK: - Action Buttons
            VStack(spacing: 10) {
                Button(action: onSaveToDownloads) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                        Text("Simpan ke Downloads")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!hasImages || isProcessing)

                Button(action: onSaveAs) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Simpan Sebagai...")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)
                .disabled(!hasImages || isProcessing)
            }
            .padding(.top, 4)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 14)
    }
}
