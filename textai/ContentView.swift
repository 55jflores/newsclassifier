//
//  ContentView.swift
//  textai
//
//  Created by Jesus Flores on 2/1/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var inputText = ""

    var body: some View {
        VStack(spacing: 16) {

            TextField("Enter blog", text: $inputText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...10)

            Button("Send POST Request") {
                viewModel.sendPostRequest(text: inputText)
            }
            .disabled(viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView()
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            if let response = viewModel.responseJSON {

                let sortedPredictions = response
                    .sorted { $0.value > $1.value }

                VStack(alignment: .leading, spacing: 8) {

                    ForEach(Array(sortedPredictions.enumerated()), id: \.element.key) { index, item in
                        
                        if index == 0 {
                            // ⭐ Top Prediction
                            Text("\(item.key): \(item.value * 100, specifier: "%.1f")%")
                                .font(.title)
                                .fontWeight(.bold)
                        } else {
                            // Normal Predictions
                            Text("\(item.key): \(item.value * 100, specifier: "%.1f")%")
                                .font(.body)
                        }
                    }
                }
            }

           
          
        }
        .padding()
    }
}
