import UIKit

extension String {
    
    /// Преобразует String, представляющую собой шестнадцатеричное значение цвета, в UIColor.
    ///
    /// - Параметры:
    ///     - hexString: String в формате "#RRGGBB", где RR, GG, BB - шестнадцатеричные значения красного, зеленого и синего компонентов цвета соответственно.
    ///
    /// - Возвращает: UIColor, представляющий собой цвет, заданный шестнадцатеричным значением.
    func toUIColor() -> UIColor? {
        var formattedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if formattedString.hasPrefix("#") {
            formattedString.remove(at: formattedString.startIndex)
        }
        
        guard formattedString.count == 6 else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: formattedString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
