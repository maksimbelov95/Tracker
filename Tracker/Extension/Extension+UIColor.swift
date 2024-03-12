import UIKit

extension UIColor {
    static var ypGreen: UIColor { UIColor(named: "YP Green") ?? UIColor.green }
    static var ypBlue: UIColor { UIColor(named: "YP Blue") ?? UIColor.blue }
    static var ypRed: UIColor { UIColor(named: "YP Red") ?? UIColor.red }
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? UIColor.black}
    static var ypBackgroundDay: UIColor { UIColor(named: "YP BackgroundDay") ?? UIColor.lightGray }
    static var ypBackgroundNight: UIColor { UIColor(named: "YP BackgroundNight") ?? UIColor.darkGray }
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.gray }
    static var ypLightGray: UIColor { UIColor(named: "YP LightGray") ?? UIColor.lightGray }
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? UIColor.white}
    static var ypBGDatePickerDay: UIColor { UIColor(named: "DataPickerColorDay") ?? UIColor.lightGray}
    static var ypBGDatePickerNight: UIColor { UIColor(named: "DataPickerColorNight") ?? UIColor.lightGray}
    static var ypTBDay: UIColor { UIColor(named: "TabBarBorderDay") ?? UIColor.lightGray}
    static var ypTBNight: UIColor { UIColor(named: "TabBarBorderNight") ?? UIColor.black}
    
    /// Преобразует UIColor в String, представляющую собой шестнадцатеричное значение цвета.
    ///
    /// - Возвращает: String в формате "#RRGGBB", где RR, GG, BB - шестнадцатеричные значения красного, зеленого и синего компонентов цвета соответственно.
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let redHex = String(format: "%02X", Int(red * 255))
        let greenHex = String(format: "%02X", Int(green * 255))
        let blueHex = String(format: "%02X", Int(blue * 255))
        
        return "#" + redHex + greenHex + blueHex
    }
}
