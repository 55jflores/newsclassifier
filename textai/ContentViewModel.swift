//
//  ContentViewModel.swift
//  textai
//
//  Created by Jesus Flores on 2/1/26.
//



import Foundation
import Combine

struct ApiResponse: Decodable {
    let gender: String
    let f_perc: Float
    let m_perc: Float

}

class ApiService {

    static let shared = ApiService()
    private init() {}

    func sendString(_ text: String) async throws -> ApiResponse {
        guard let url = URL(string: "https://jflo-sentiment.hf.space/sentiment") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Request body
        let body: [String: String] = [
            "message": text
        ]

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(ApiResponse.self, from: data)
    }
}


@MainActor
class ContentViewModel: ObservableObject {
    @Published var responseJSON: ApiResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func sendPostRequest(text: String) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await ApiService.shared.sendString(text)
                responseJSON = response
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
