import UIKit

extension UIDevice {

    /// The device model identifier e.g. "iPhone14,5" (iPhone 13) or "Simulator"
    static var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "i386", "x86_64":
            return "Simulator"
        default:
            return identifier
        }
    }
}
