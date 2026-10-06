//
//  ReverseCreditsView.swift
//  ReverseWorld
//
//  Free Audio & Video Inversion Credits & Bonus View
//

import SwiftUI

struct ReverseCreditsView: View {
    @State private var balance: Int = 100
    @State private var hasClaimedToday: Bool = false
    @State private var isClaiming: Bool = false
    @State private var showPaywall: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                                .font(.title2)
                                .foregroundColor(.indigo)
                            Text("Reverse Credits")
                                .font(.headline)
                            Spacer()
                            Text("\(balance) pts")
                                .font(.title3.bold())
                                .foregroundColor(.primary)
                        }

                        Text("Use credits for high-definition reverse video exports, batch voice reversing, and phoneme analysis.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Divider()

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Daily Flip Bonus")
                                    .font(.subheadline.bold())
                                Text("+10 credits for daily check-in")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button {
                                claimBonus()
                            } label: {
                                if isClaiming {
                                    ProgressView()
                                } else {
                                    Text(hasClaimedToday ? "Claimed Today" : "Claim +10")
                                        .font(.subheadline.bold())
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(hasClaimedToday || isClaiming)
                        }
                    }
                    .padding(.vertical, 6)
                } header: {
                    Text("Free Tier Quota")
                } footer: {
                    Text("All basic audio reversal, microphone recordings, and mirror camera features are permanently free offline.")
                }

                Section("Pro Unlimited") {
                    Button {
                        showPaywall = true
                    } label: {
                        HStack {
                            Label("View Unlimited Pro Plans", systemImage: "crown.fill")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Reverse Credits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(isPresented: $showPaywall)
            }
            .task {
                if let bal = try? await BuyservicesClient.shared.fetchBalance() {
                    balance = bal
                }
            }
        }
    }

    private func claimBonus() {
        guard !hasClaimedToday else { return }
        isClaiming = true
        _Concurrency.Task {
            if let newBal = try? await BuyservicesClient.shared.claimDailyBonus() {
                balance += newBal
            } else {
                balance += 10
            }
            hasClaimedToday = true
            isClaiming = false
        }
    }
}
