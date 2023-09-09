import SwiftUI

public struct FeedbackForm: View {

    public struct Config {
        let title: String?

        public init(title: String?) {
            self.title = title
        }
    }

    @Environment(\.presentationMode) private var presentationMode

    @StateObject private var viewModel: FeedbackFormViewModel
    private let config: Config?

    public init(
        service: SubmitService,
        config: Config? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: FeedbackFormViewModel(service: service))
        self.config = config
    }

    public var body: some View {
        NavigationView {
            Form {
                formFields
                submitButton
            }
            .navigationTitle(Text(config?.title ?? "_send_a_feedback".localized))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("_cancel".localized)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: Views

    private var formFields: some View {
        Group {
            Section {
                TextField("_email_placeholder".localized, text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            } header: {
                Text("_email_title".localized)
            }

            Section {
                TextEditor(text: $viewModel.message)
            } header: {
                Text("_message_title".localized)
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
                    Text("_send_feedback".localized)
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
            .environment(\.locale, Locale(identifier: "en"))
    }
}
