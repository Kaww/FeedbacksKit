import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, bundle: .module, comment: "\(self)_comment")
    }
}
