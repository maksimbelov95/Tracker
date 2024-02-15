
import Foundation

final class UserStorage{
    
    private enum SettingsKeys: String {

        case onboardingKey
    }
    
    static var isOnboardingShow: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.onboardingKey.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.onboardingKey.rawValue
            if let isShow = newValue {
                defaults.set(isShow, forKey: key)
                print("new value \(isShow)")
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}

