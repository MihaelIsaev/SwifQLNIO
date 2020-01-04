//
//  SwifQLTable.swift
//  SwifQLNIO
//
//  Created by Mihael Isaev on 05/11/2018.
//

import SwifQL

public typealias SwifQLTable = Tableable & Reflectable

/// Default `Reflectable` implementation for types that are also `Decodable`.
extension Reflectable where Self: Decodable {
    /// Default `Reflectable` implementation for types that are also `Decodable`.
    ///
    /// See `Reflectable.reflectProperties(depth:)`
    public static func reflectProperties(depth: Int) throws -> [ReflectedProperty] {
        try decodeProperties(depth: depth)
    }
    
    /// Default `Reflectable` implementation for types that are also `Decodable`.
    ///
    /// See `AnyReflectable`.
    public static func anyReflectProperty(valueType: Any.Type, keyPath: AnyKeyPath) throws -> ReflectedProperty? {
        try anyDecodeProperty(valueType: valueType, keyPath: keyPath)
    }
}
