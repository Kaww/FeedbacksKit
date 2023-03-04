import Foundation

public protocol SubmitService {
    func submit(formData: FeedbackFormData) async throws
}

public class DummySubmitService: SubmitService {

    public init() {}

    public func submit(formData: FeedbackFormData) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        print("Submitted !")
    }
}
