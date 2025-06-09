import Foundation

class FormViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var message = ""
    @Published var responseText: String?
    @Published var alertMessage:String = ""
    @Published var showAlert:Bool = false 
    @Published var isLoading = false
    @Published var errorText: String?
    func isValidEmail(_ email: String) -> Bool {
           let emailRegEx =
           "(?:[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,}|\\[(?:(2(5[0-5]|[0-4][0-9])|1?[0-9][0-9]?)(\\.(?!$)|$)){4}\\])"
           let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
           return predicate.evaluate(with: email)
       }
    func submit() {
        guard !name.isEmpty, !email.isEmpty, !message.isEmpty else {
            errorText = "All fields are required."
            return
        }
        
        guard isValidEmail(email) else {
                   alertMessage = "Please enter a valid email address."
                   showAlert = true
                   return
               }

        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "name": name,
            "email": email,
            "message": message
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        isLoading = true
        errorText = nil

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorText = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorText = "No response data"
                    return
                }

                self.responseText = String(data: data, encoding: .utf8)
            }
        }.resume()
    }
}
