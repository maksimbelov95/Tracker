
import Foundation

final class UserStorage{
    
    private enum SettingsKeys: String {

        case onboardingKey
    }
    
    static var isOnboardingShow: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.onboardingKey.rawValue)
        }
        set {  UserDefaults.standard.set(newValue, forKey: SettingsKeys.onboardingKey.rawValue)
        }
    }
}

