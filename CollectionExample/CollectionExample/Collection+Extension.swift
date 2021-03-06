//
//  Collection+Extension.swift
//  CollectionExample
//
//  Created by Adem Türkoğlu on 6.03.2021.
//  Copyright © 2021 adem. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else {
            assertionFailure("The index is out of the range.")
            return nil
        }

        return self[index]
    }
}

extension Collection {
    func count(where predicate: (Element) -> Bool) -> Int {
        var count = 0
        for element in self where predicate(element) {
            count += 1
        }
        return count
    }
}

