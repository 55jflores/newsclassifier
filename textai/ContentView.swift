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

            TextField("Enter text", text: $inputText)
                .textFieldStyle(.roundedBorder)

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
            if viewModel.responseJSON != nil {
                Text("Response:")
                    .font(.headline)
                
                Text("Gender: \(viewModel.responseJSON!.gender)")
                    .padding()
                Text("Female likelihood: \(String(format: "%.2f",viewModel.responseJSON!.f_perc*100))% likely")
                    .padding()
                Text("Male likelihood: \(String(format: "%.2f",viewModel.responseJSON!.m_perc*100))% likely")
                    .padding()
                
            }
           
          
        }
        .padding()
    }
}
