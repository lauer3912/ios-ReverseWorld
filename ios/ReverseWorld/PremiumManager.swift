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

    enum LoadStatus: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    // Product IDs from AppStore/Listing.md
    static let monthlyProductID = "com.ggsheng.ReverseWorld.premium_monthly"
    static let yearlyProductID = "com.ggsheng.ReverseWorld.premium_yearly"

    private var transactionListener: Task<Void, Never>?

    init() {
        // Load from UserDefaults (in case user has previous purchases)
        isPremium = UserDefaults.standard.bool(forKey: "isPremium")

        // Listen for transaction updates
        transactionListener = listenForTransactions()

        Task {
            await self.refreshProducts()
            await self.updatePurchasedProducts()
        }
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

    func restorePurchases() async {
        try? await AppStore.sync()
        await updatePurchasedProducts()
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

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
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
        guard !products.isEmpty else { return "$0.99" }
        if let monthly = monthlyProduct, monthly.id == Self.monthlyProductID {
            return monthly.displayPrice
        }
        return "$0.99"
    }

    var yearlyDisplayPrice: String {
        guard let yearly = yearlyProduct else { return "$29.99" }
        return yearly.displayPrice
    }
}
