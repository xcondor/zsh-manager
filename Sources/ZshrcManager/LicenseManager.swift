import Foundation
import Combine

enum LicenseStatus: String, Codable {
    case trialing
    case expired
    case licensed
}

class LicenseManager: ObservableObject {
    static let shared = LicenseManager()
    
    @Published var status: LicenseStatus = .trialing
    @Published var trialDaysRemaining: Int = 3
    @Published var isPro: Bool = true
    
    private let defaults = UserDefaults.standard
    private let trialDurationDays = 3
    
    // UserDefaults keys
    private let kTrialStartDate = "license_trial_start"
    private let kLicenseKey = "license_active_key"
    private let kDidMigrateFromKeychain = "did_migrate_from_keychain"
    
    init() {
        checkStatus()
    }
    
    func checkStatus() {
        // 1. Check if already licensed
        if let key = defaults.string(forKey: kLicenseKey), !key.isEmpty {
            // In a real app, we would verify the key with an API here
            self.status = .licensed
            self.isPro = true
            return
        }
        
        // 2. Check trial start date
        if let startDateString = defaults.string(forKey: kTrialStartDate),
           let startTimestamp = Double(startDateString) {
            let startDate = Date(timeIntervalSince1970: startTimestamp)
            let calendar = Calendar.current
            let now = Date()
            
            let components = calendar.dateComponents([.day], from: startDate, to: now)
            let elapsedDays = components.day ?? 0
            
            if elapsedDays >= trialDurationDays {
                self.status = .expired
                self.isPro = false
                self.trialDaysRemaining = 0
            } else {
                self.status = .trialing
                self.isPro = true // Pro features available during trial
                self.trialDaysRemaining = trialDurationDays - elapsedDays
            }
        } else {
            // 3. First launch, initialize trial
            let now = Date().timeIntervalSince1970
            defaults.set("\(now)", forKey: kTrialStartDate)
            self.status = .trialing
            self.isPro = true
            self.trialDaysRemaining = trialDurationDays
        }
    }
    
    func activateLicense(key: String) -> Bool {
        // In production, this would be a network call to Paddle/LemonSqueezy
        if key.count >= 8 {
            defaults.set(key, forKey: kLicenseKey)
            checkStatus()
            return true
        }
        return false
    }
    
    func resetTrial() {
        // For debugging purposes
        defaults.removeObject(forKey: kTrialStartDate)
        defaults.removeObject(forKey: kLicenseKey)
        checkStatus()
    }
    
    var hardwareID: String {
        let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0)
        IOObjectRelease(platformExpert)
        return (serialNumberAsCFString?.takeRetainedValue() as? String) ?? "Unknown ID"
    }
}
