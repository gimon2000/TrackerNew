//
//  DaysValueTransformer.swift
//  TrackerNew
//
//  Created by gimon on 09.07.2024.
//

import Foundation

@objc
final class DaysValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        print(#fileID, #function, #line, "value: \(String(describing: value))")
        if let data = value as? NSData {
            print(#fileID, #function, #line, "value: \(String(describing: data))")
            return data
        }
        guard let days = value as? [Weekdays] else {
            print(#fileID, #function, #line)
            return nil
        }
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        print(#fileID, #function, #line, "value: \(String(describing: value))")
        if let data = value as? [Weekdays] {
            print(#fileID, #function, #line, "value: \(String(describing: data))")
            return data
        }
        guard let data = value as? NSData else {
            print(#fileID, #function, #line)
            return nil
        }
        return try? JSONDecoder().decode([Weekdays].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            DaysValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self))
        )
    }
}
