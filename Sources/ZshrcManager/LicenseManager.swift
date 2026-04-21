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
    @Published var isPro: Bool = false
    
    private let keychain = KeychainStore.shared
    private let trialDurationDays = 3
    
    // Keychain accounts
    private let kTrialStartDate = "trial_start_date"
    private let kLicenseKey = "license_key"
    
    init() {
        checkStatus()
    }
    
    func checkStatus() {
        // 1. Check if already licensed
        if let key = keychain.getString(account: kLicenseKey), !key.isEmpty {
            // In a real app, we would verify the key with an API here
            self.status = .licensed
            self.isPro = true
            return
        }
        
        // 2. Check trial start date
        if let startDateString = keychain.getString(account: kTrialStartDate),
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
            try? keychain.setString("\(now)", account: kTrialStartDate)
            self.status = .trialing
            self.isPro = true
            self.trialDaysRemaining = trialDurationDays
        }
    }
    
    func activateLicense(key: String) -> Bool {
        // Simple validation for demo purposes. 
        // In production, this would be a network call to Paddle/LemonSqueezy
        if key.count >= 8 {
            try? keychain.setString(key, account: kLicenseKey)
            checkStatus()
            return true
        }
        return false
    }
    
    func resetTrial() {
        // For debugging purposes
        try? keychain.delete(account: kTrialStartDate)
        try? keychain.delete(account: kLicenseKey)
        checkStatus()
    }
    
    var hardwareID: String {
        let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0)
        IOObjectRelease(platformExpert)
        return (serialNumberAsCFString?.takeRetainedValue() as? String) ?? "Unknown ID"
    }
}
