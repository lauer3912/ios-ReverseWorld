//
//  BuyservicesClient.swift
//  ReverseWorld
//
//  Shared Buyservices Credits & Freemium backend client
//

import Foundation

actor BuyservicesClient {
    static let shared = BuyservicesClient()

    let baseURL: URL
    let appId: String

    struct FreeTierConfig: Codable {
        let initialCredits: Int
        let dailySigninBonus: Int
        let enableHFBackup: Bool
    }

    static let defaultFreeTier = FreeTierConfig(
        initialCredits: 100,
        dailySigninBonus: 10,
        enableHFBackup: true
    )

    private struct DeductRequest: Encodable {
        let app_id: String
        let cost: Int
        let reason: String
    }

    private struct SigninRequest: Encodable {
        let app_id: String
    }

    init(
        baseURL: URL = URL(string: "https://buyservices.top/api/v1")!,
        appId: String = "com.ggsheng.ReverseWorld"
    ) {
        self.baseURL = baseURL
        self.appId = appId
    }

    func fetchBalance() async throws -> Int {
        let url = baseURL.appendingPathComponent("credits/balance")
            .appending(queryItems: [URLQueryItem(name: "app_id", value: appId)])
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                return Self.defaultFreeTier.initialCredits
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let balance = json["balance"] as? Int {
                return balance
            }
        } catch {
            return Self.defaultFreeTier.initialCredits
        }
        return Self.defaultFreeTier.initialCredits
    }

    func claimDailyBonus() async throws -> Int {
        let url = baseURL.appendingPathComponent("credits/signin")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(SigninRequest(app_id: appId))

        let (data, response) = try await URLSession.shared.data(for: req)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            return Self.defaultFreeTier.dailySigninBonus
        }
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let newBal = json["new_balance"] as? Int {
            return newBal
        }
        return Self.defaultFreeTier.dailySigninBonus
    }
}
