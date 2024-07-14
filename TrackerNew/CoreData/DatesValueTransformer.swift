//
//  DatesValueTransformer.swift
//  TrackerNew
//
//  Created by gimon on 10.07.2024.
//

import Foundation

@objc
final class DatesValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        print(#fileID, #function, #line, "value: \(String(describing: value))")
        if let data = value as? NSData {
            print(#fileID, #function, #line, "value: \(String(describing: data))")
            return data
        }
        guard let dates = value as? Set<Date> else {
            print(#fileID, #function, #line)
            return nil
        }
        return try? JSONEncoder().encode(dates)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        print(#fileID, #function, #line, "value: \(String(describing: value))")
        if let data = value as? Set<Date> {
            print(#fileID, #function, #line, "value: \(String(describing: data))")
            return data
        }
        guard let data = value as? NSData else {
            print(#fileID, #function, #line)
            return nil
        }
        return try? JSONDecoder().decode(Set<Date>.self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            DatesValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: DatesValueTransformer.self))
        )
    }
}
