//
//  ContentView.swift
//  instaweblabs
//
//  Created by Ashish on 09/06/25.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FormViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contact Us")) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                    TextField("Message", text: $viewModel.message)
                }

                Button(action: {
                    viewModel.submit()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Submit")
                    }
                }

                if let response = viewModel.responseText {
                    Section(header: Text("Response")) {
                        Text(response)
                            .font(.footnote)
                            .foregroundColor(.green)
                    }
                }

                if let error = viewModel.errorText {
                    Section {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Feedback Form").alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Invalid Input"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview{
    ContentView()
}
