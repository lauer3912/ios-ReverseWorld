import SwiftUI
import StoreKit

/// Manages in-app purchases and premium status
@MainActor
final class PremiumManager: ObservableObject {
    static let shared = PremiumManager()

    @Published var isPremium: Bool = false
    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var loadStatus: LoadStatus = .idle
    @Published var restoreError: String?  // R2-9: expose restore error so UI can show feedback

    enum LoadStatus: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    // Product IDs from App Store Connect (TitleCase to match ASC)
    // R5-1 fix: code used lowercase 'premium_monthly' but ASC has 'PremiumMonthly' (TitleCase).
    // Product ID lookup is case-sensitive, so users could NEVER purchase.
    // Now matches ASC exactly: com.ggsheng.ReverseWorld.PremiumMonthly
    static let monthlyProductID = "com.ggsheng.ReverseWorld.PremiumMonthly"
    static let yearlyProductID = "com.ggsheng.ReverseWorld.PremiumYearly"

    private var transactionListener: Task<Void, Never>?

    init() {
        // Load from UserDefaults (in case user has previous purchases)
        isPremium = UserDefaults.standard.bool(forKey: "isPremium")

        // R2-4 fix: use [weak self] to avoid strong reference in Task
        Task { [weak self] in
            await self?.refreshProducts()
            await self?.updatePurchasedProducts()
        }

        transactionListener = listenForTransactions()
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Product Loading

    func refreshProducts() async {
        loadStatus = .loading
        do {
            let productIDs = [Self.monthlyProductID, Self.yearlyProductID]
            products = try await Product.products(for: productIDs)
            loadStatus = .loaded
        } catch {
            loadStatus = .failed(error.localizedDescription)
            AppLog.premium.error("refreshProducts failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    // MARK: - Purchase

    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                await transaction.finish()
                await updatePurchasedProducts()
                return true
            case .unverified:
                return false
            }
        case .userCancelled, .pending:
            return false
        @unknown default:
            return false
        }
    }

    // R2-9 fix: capture and expose error so UI can show feedback
    func restorePurchases() async {
        restoreError = nil
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
            if purchasedProductIDs.isEmpty {
                restoreError = "No previous purchases found for this Apple ID"
            }
        } catch {
            restoreError = "Restore failed: \(error.localizedDescription)"
            AppLog.premium.error("restorePurchases failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    // MARK: - Status

    private func updatePurchasedProducts() async {
        var purchased: Set<String> = []
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchased.insert(transaction.productID)
            }
        }
        purchasedProductIDs = purchased
        isPremium = !purchased.isEmpty
        UserDefaults.standard.set(isPremium, forKey: "isPremium")
    }

    // R2-7 fix: Task.detached already uses [weak self], but also add @Sendable closure
    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached(priority: .background) { [weak self] in
            for await result in Transaction.updates {
                guard let self = self else { return }
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    await self.updatePurchasedProducts()
                }
            }
        }
    }

    // MARK: - Helpers

    func product(for id: String) -> Product? {
        products.first { $0.id == id }
    }

    var monthlyProduct: Product? { product(for: Self.monthlyProductID) }
    var yearlyProduct: Product? { product(for: Self.yearlyProductID) }

    var displayPrice: String {
        guard !products.isEmpty else { return "$4.99" }
        if let monthly = monthlyProduct, monthly.id == Self.monthlyProductID {
            return monthly.displayPrice
        }
        return "$4.99"
    }

    var yearlyDisplayPrice: String {
        guard let yearly = yearlyProduct else { return "$49.99" }
        return yearly.displayPrice
    }
}
