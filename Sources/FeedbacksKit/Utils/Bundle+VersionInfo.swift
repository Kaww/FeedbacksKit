import Foundation

extension Bundle {
	var appBuild: String { getInfo("CFBundleVersion") }
	var appVersionLong: String { getInfo("CFBundleShortVersionString") }
	var appVersionShort: String { getInfo("CFBundleShortVersion") }

	private func getInfo(_ string: String) -> String {
		infoDictionary?[string] as? String ?? "⚠️"
	}
}
