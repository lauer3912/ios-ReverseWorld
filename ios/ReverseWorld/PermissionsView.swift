//
//  PermissionsView.swift
//  ReverseWorld
//
//  User-facing view that shows permission status with one-tap grant.
//  Per Apple HIG: clear purpose → contextual request → friendly denied state → easy Settings redirect.
//
//  Created: 2026-06-29 09:06 CST (Katherine-E2wa1m)
//

import SwiftUI

/// Compact permission row used in ProfileView settings
struct PermissionRow: View {
    let icon: String
    let title: String
    let description: String
    let status: PermissionStatus
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Theme.Accent.primary)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Text.primary)
                Text(description)
                    .font(.caption)
                    .foregroundColor(Theme.Text.secondary)
                    .lineLimit(2)
            }

            Spacer()

            statusBadge
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture { action() }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(status.displayLabel). Double-tap to \(status == .denied ? "open Settings" : "grant access")")
    }

    @ViewBuilder
    private var statusBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: status.iconName)
                .foregroundColor(status.tintColor)
            Text(status == .denied ? "Open Settings" : status == .authorized ? "Granted" : status == .restricted ? "Restricted" : "Grant")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(status.tintColor)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(status.tintColor.opacity(0.15))
        .clipShape(Capsule())
    }
}

/// Full permission management screen (shown from ProfileView)
struct PermissionsView: View {
    @ObservedObject var manager: PermissionsManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Background.primary.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        headerCard

                        VStack(spacing: 0) {
                            PermissionRow(
                                icon: "camera.fill",
                                title: "Camera",
                                description: "Mirror your world and record reverse videos",
                                status: manager.camera,
                                action: { Task { await requestCamera() } }
                            )
                            Divider().background(Theme.Background.card)
                            PermissionRow(
                                icon: "mic.fill",
                                title: "Microphone",
                                description: "Record sound with your mirror videos",
                                status: manager.microphone,
                                action: { Task { await requestMicrophone() } }
                            )
                            Divider().background(Theme.Background.card)
                            PermissionRow(
                                icon: "photo.fill",
                                title: "Photo Library",
                                description: "Save reverse creations and load photos to apply filters",
                                status: manager.photoLibrary,
                                action: { Task { await requestPhotoLibrary() } }
                            )
                            Divider().background(Theme.Background.card)
                            PermissionRow(
                                icon: "photo.fill.on.rectangle.fill",
                                title: "Photo Save (Add Only)",
                                description: "Save reversed photos without reading your library",
                                status: manager.photoAddOnly,
                                action: { Task { await requestPhotoAddOnly() } }
                            )
                            Divider().background(Theme.Background.card)
                            PermissionRow(
                                icon: "waveform",
                                title: "Speech Recognition",
                                description: "Convert your voice into reversed text",
                                status: manager.speechRecognition,
                                action: { Task { await requestSpeechRecognition() } }
                            )
                        }
                        .padding(.horizontal)
                        .background(Theme.Background.card)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
                        .padding(.horizontal)

                        Button {
                            Task { await requestAll() }
                        } label: {
                            HStack {
                                Image(systemName: "lock.open.fill")
                                Text("Grant All Critical Permissions")
                            }
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(manager.allCriticalGranted ? Theme.Accent.success : Theme.Accent.primary)
                            .clipShape(Capsule())
                        }
                        .disabled(manager.allCriticalGranted)
                        .padding(.horizontal)
                        .padding(.top, 8)

                        whyWeNeedThisCard
                            .padding(.horizontal)
                            .padding(.top, 8)
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Permissions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Theme.Accent.primary)
                }
            }
        }
    }

    // MARK: - Sub-views

    private var headerCard: some View {
        VStack(spacing: 8) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 44))
                .foregroundStyle(Theme.Accent.primary)
            Text("\(manager.grantedCount) of \(manager.totalCount) permissions granted")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Theme.Text.primary)
            Text("ReverseWorldGo only uses these when needed for the feature you're using")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(Theme.Text.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal)
        .background(Theme.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
        .padding(.horizontal)
    }

    private var whyWeNeedThisCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Why we need access", systemImage: "info.circle.fill")
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(Theme.Accent.warning)
            Text("ReverseWorldGo is committed to your privacy. We only request access when the feature requires it, and we never upload your photos, videos, or voice recordings to any server.")
                .font(.caption)
                .foregroundColor(Theme.Text.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
    }

    // MARK: - Actions

    private func requestCamera() async {
        _ = await manager.requestCamera()
    }

    private func requestMicrophone() async {
        _ = await manager.requestMicrophone()
    }

    private func requestPhotoLibrary() async {
        _ = await manager.requestPhotoLibrary()
    }

    private func requestPhotoAddOnly() async {
        _ = await manager.requestPhotoAddOnly()
    }

    private func requestSpeechRecognition() async {
        _ = await manager.requestSpeechRecognition()
    }

    private func requestAll() async {
        _ = await manager.requestCameraAndMicrophone()
        _ = await manager.requestPhotoLibrary()
        _ = await manager.requestPhotoAddOnly()
        _ = await manager.requestSpeechRecognition()
    }
}