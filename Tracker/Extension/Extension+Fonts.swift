import UIKit

public extension UIFont{
    
    static var hugeTitleMedium12: UIFont{
        return UIFont(name: "YS-Display-Medium", size: 12) ?? .systemFont(ofSize: 12, weight: .medium)
    }
    static var hugeTitleMedium16: UIFont{
        return UIFont(name: "YS-Display-Medium", size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
    }
    static var hugeTitleMedium17: UIFont{
        return UIFont(name: "YS-Display-Medium", size: 17) ?? .systemFont(ofSize: 17, weight: .medium)
    }
    
    
    static var hugeTitleBold19: UIFont{
        return UIFont(name: "YS-Display-Bold", size: 19) ?? systemFont(ofSize: 19, weight: .bold)
    }
    static var hugeTitleBold32: UIFont{
        return UIFont(name: "YS-Display-Bold", size: 32) ?? systemFont(ofSize: 32, weight: .bold)
    }
    
}
