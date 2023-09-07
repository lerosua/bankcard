//
//  LAContext+EX.swift
//  bankcard
//
//  Created by rosua le on 2023/9/7.
//

import Foundation
import LocalAuthentication

extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Capture these recoverable error thru Crashlytics
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                return .none
            }
        } else {
            return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
}

class BCLAContext {
    //单例
    public static var shareInstance:LAContext = {
        let instance : LAContext = LAContext()
        return instance;
    }()
    
    static func getUseAuthState()->Bool{
        if let savedSettings = UserDefaults.standard.object(forKey: kSettingKey) as? [String: Any] {
            if let lock = savedSettings[kUseLockKey] as? Bool {
                print("启用生物锁 \(lock)")
                return lock
            }
        }
        return false
    }
    
}
