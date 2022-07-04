//
//  ValidityChecker.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/15/22.
//

import Foundation

class ValidityChecker {
    
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let firstNameRegex = "([a-zA-Z]{2,30}\\s*)+"
        
    let isLongEnough = "^.{8,}$"
    
    func isEmailValid(_ email: String) -> Bool {
        return checkValidity(value: email, regex: emailRegex)
    }
    
    func isNameValid(_ name: String) -> Bool {
        return checkValidity(value: name, regex: firstNameRegex)
    }
    
    func isBirthdateValid(_ date: Date) -> Bool {
        // Initialize current date
        let today = Date()
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        // Calculate difference between today and birthday
        let age = gregorian.components([.year], from: date, to: today, options: [])
        return age.year! >= 18
    }
    
    func passwordErrorCheck(_ string: String) -> Error? {
        let mySet = CharacterSet(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
        if string.rangeOfCharacter(from: mySet) != nil {
            if checkValidity(value: string, regex: isLongEnough) {
                return nil
            } else {
                return PasswordError.tooShort
            }
        } else {
            return PasswordError.needsNumber
        }
    }
    
    fileprivate func checkValidity(value: String, regex: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: value)
    }
}

public enum PasswordError: Error {
    case tooShort
    case needsNumber
}

extension PasswordError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .tooShort: return NSLocalizedString("Password must be atleast 8 characters.", comment: "My error")
            case .needsNumber: return NSLocalizedString("Password must contain a number.", comment: "My error")
        }
    }
}

