import SwiftUI

public struct FeedbackForm: View {

    @Environment(\.presentationMode) private var presentationMode

    @StateObject private var viewModel: FeedbackFormViewModel

    public init(service: SubmitService) {
        self._viewModel = StateObject(wrappedValue: FeedbackFormViewModel(service: service))
    }

    public var body: some View {
        NavigationView {
            Form {
                formFields
                submitButton
            }
            .navigationTitle("Send a feedback")
        }
    }

    // MARK: Views

    private var formFields: some View {
        Group {
            Section {
                TextField("Email (optional)", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none) // TODO: add variant for newer iOS version
            } header: {
                Text("Email")
            }

            Section {
                TextEditor(text: $viewModel.message)
            } header: {
                Text("Message")
            }
        }
        .disabled(viewModel.isFormDisabled)
    }

    private var submitButton: some View {
        Section {
            Button {
                submitForm()
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Send feedback")
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(viewModel.isSubmitDisabled)
        } footer: {
            footer
        }
    }

    private var footer: some View {
        VStack {
            if let result = viewModel.result {
                switch result {
                case .success:
                    successText(message: result.message)

                case .failure:
                    failureText(message: result.message)
                }
            }
        }
        .animation(.spring(), value: viewModel.result)
    }

    private func successText(message: String) -> some View {
        Text(message)
            .bold()
            .frame(maxWidth: .infinity)
            .foregroundColor(.green)
            .onAppear {
                Task {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    viewModel.result = nil
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .transition(.slide.combined(with: .opacity))
    }

    private func failureText(message: String) -> some View {
        Text(message)
            .bold()
            .frame(maxWidth: .infinity)
            .foregroundColor(.red)
            .onAppear {
                Task {
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    viewModel.result = nil
                }
            }
            .transition(.slide.combined(with: .opacity))
    }

    // MARK: Actions

    private func submitForm() {
        hideKeyboard()
        viewModel.submit()
    }
}

struct FeedbackForm_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackForm(service: DummySubmitService())
    }
}
