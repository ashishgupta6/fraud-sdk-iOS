//
//  Extensions.swift
//  Sign3Intelligence
//
//  Created by Sreyans Bohara on 22/01/25.
//

extension Array where Element: Equatable {
    mutating func addUnique(_ newElement: Element) {
        if !self.contains(newElement) {
            self.append(newElement)
        }
    }
}

extension Array where Element: Equatable {
    mutating func addUnique(_ newElements: [Element]) {
        for newElement in newElements {
            if !self.contains(newElement) {
                self.append(newElement)
            }
        }
    }
}


