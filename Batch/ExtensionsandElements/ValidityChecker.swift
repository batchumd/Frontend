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
    
    func isEmailValid(_ email: String) -> Bool {
        return checkValidity(value: email, regex: emailRegex)
    }
    
    func isNameValid(_ name: String) -> Bool {
        return checkValidity(value: name, regex: firstNameRegex)
    }
    
    func isBirthdateValid(_ date: Date) -> Bool {
        let today = Date()
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let age = gregorian.components([.year], from: date, to: today, options: [])
        return age.year! >= 18
    }
    
    func isPasswordValid(_ string: String) -> Bool {
        return string.count >= 8
    }
    
    fileprivate func checkValidity(value: String, regex: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: value)
    }
    
}

