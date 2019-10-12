import UIKit

extension String {
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.roundingMode = .ceiling
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    var doubleValue: Double? {
        if let _ = firstIndex(of: ".") {
            String.numberFormatter.decimalSeparator = "."
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        if let _ = firstIndex(of: ",") {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        if let result = String.numberFormatter.number(from: self) {
            return result.doubleValue
        }
        return nil 
    }
}
