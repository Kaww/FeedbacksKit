import UIKit

public struct FeedbackFormData {
    let email: String
    let message: String

	let deviceName: String
	let systemNameAndVersion: String
	let appVersion: String
	let language: String

    public init(
        email: String,
        message: String
    ) {
        self.email = email
        self.message = message

		deviceName = UIDevice.current.name
		systemNameAndVersion = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
		appVersion = "\(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))"
		language = Locale.current.localizedString(forIdentifier: Locale.current.identifier) ?? Locale.current.identifier
    }
}
