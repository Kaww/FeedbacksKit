public struct FeedbackFormData {
    let email: String
    let message: String

    public init(
        email: String,
        message: String
    ) {
        self.email = email
        self.message = message
    }
}
