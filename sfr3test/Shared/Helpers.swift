//
//  Helpers.swift
//  sfr3test
//
//  Created by Mike on 11/2/23.
//

import Foundation

extension Collection {
    /// Counts the number of items in the collection that pass the supplied test closure.
    /// - Parameter test: Closure to determine whether the item should be included in the count
    /// - Returns: Count of items returning true for the test closure
    func count(where test: (Element) -> Bool) -> Int {
        reduce(0) { $0 + (test($1) ? 1 : 0) }
    }
}

infix operator <- : AssignmentPrecedence

/// Apply Operator
///
/// - Executes the supplied block passing the object it is applied on as a parameter to the block.
/// - Parameters:
///   - left: The object to apply the block on.
///   - right: The block to execute.
/// - Returns: The object the block was applied to.
@discardableResult
public func <- <T: AnyObject>(left: T, right: (T) -> Void) -> T {
    right(left)
    return left
}

extension Data {
    static func fromFile(file fileURL: URL) -> Data? {
        return try? Data(contentsOf: fileURL, options: .uncached)
    }
}

extension Decodable {
    static func decodedFrom(file fileURL: URL, jsonDecoder: JSONDecoder = .init()) throws -> Self? {
        guard let data = Data.fromFile(file: fileURL) else { return nil }
        return try jsonDecoder.decode(Self.self, from: data)
    }
}

extension Encodable {
    func encoded(to fileURL: URL, jsonEncoder: JSONEncoder = .init()) throws {
        try jsonEncoder.encode(self).write(to: fileURL)
    }
}
