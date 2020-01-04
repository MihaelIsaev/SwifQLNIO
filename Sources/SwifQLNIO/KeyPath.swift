//
//  KeyPath.swift
//  SwifQLNIO
//
//  Created by Mihael Isaev on 05/11/2018.
//

import Foundation
import SwifQL

//MARK: Aliased KeyPath

public class AliasedKeyPath<M, V> where M: Decodable, M: Reflectable {
    var alias: String
    var kp: KeyPath<M, V>
    init(_ alias: String, _ kp: KeyPath<M, V>) {
        self.alias = alias
        self.kp = kp
    }
}

extension AliasedKeyPath: FQUniversalKeyPath, FQUniversalKeyPathSimple {
    public typealias AType = V
    public typealias AModel = M
    public typealias ARoot = AliasedKeyPath
    
    public var queryValue: String {
        formattedPath(alias, kp).pathWithTable
    }
    
    public var originalKeyPath: KeyPath<M, V> {
        kp
    }
    
    public var path: String {
        formattedPath(alias, kp).path
    }
    
    public var lastPath: String {
        formattedPath(alias, kp).lastPath
    }
}

//MARK: Aliased KeyPath SwifQLable

extension AliasedKeyPath: SwifQLPart {}

extension AliasedKeyPath: SwifQLKeyPathable {
    public var table: String { alias }
    public var paths: [String] { kp.paths }
}

extension AliasedKeyPath: CustomStringConvertible {}

extension AliasedKeyPath: SwifQLable {
    public var parts: [SwifQLPart] { [SwifQLPartKeyPath(table: table, paths: kp.paths)] }
}

extension AliasedKeyPath: Keypathable {
    public var shortPath: String { _FormattedKeyPath.flattenKeyPath(self.paths) }
    
    public func fullPath(table: String) -> String {
        formattedPath(table, kp).pathWithTable
    }
}

//MARK: - KeyPath

extension KeyPath: FQUniversalKeyPath, FQUniversalKeyPathSimple, KeyPathLastPath  where Root: Decodable & Reflectable {
    public typealias AType = Value
    public typealias AModel = Root
    public typealias ARoot = KeyPath
    
    public var queryValue: String {
        formattedPath(Root.self, self).pathWithTable
    }
    
    public var originalKeyPath: KeyPath<Root, Value> { self }
    
    public var path: String {
        formattedPath(Root.self, self).path
    }
    
    public var lastPath: String {
        formattedPath(Root.self, self).lastPath
    }
}

extension KeyPath where Root: Reflectable {
    public var paths: [String] {
        var values: [String] = []
        do {
            if let v = try Root.reflectProperty(forKey: self)?.path {
                values = v
            }
        } catch {
            print(error)
        }
        return values
    }
}

//MARK: KeyPath SwifQLable

extension KeyPath: SwifQLPart {}

extension KeyPath: SwifQLKeyPathable where Root: Reflectable {
    public var table: String {
        if let model = Root.self as? Tableable.Type {
            return model.entity
        }
        return String(describing: Root.self)
    }
}

extension KeyPath: CustomStringConvertible where Root: Reflectable {}

extension KeyPath: SwifQLable where Root: Reflectable {
    public var parts: [SwifQLPart] { [SwifQLPartKeyPath(table: table, paths: paths)] }
}

extension KeyPath: Keypathable where Root: Reflectable {
    public var shortPath: String { _FormattedKeyPath.flattenKeyPath(self.paths) }
    public var lastPath: String { self.paths.last ?? "nnnnnn" }
    
    public func fullPath(table: String) -> String {
        formattedPath(table, self).pathWithTable
    }
}

//MARK: - Helper methods

struct _FormattedKeyPath {
    var pathWithTable: String = ""
    var path: String = ""
    var lastPath: String = ""
    
    init (table: String, paths: [String]) {
        pathWithTable.append(table.doubleQuotted)
        path = _FormattedKeyPath.flattenKeyPath(paths)
        pathWithTable.append(".")
        pathWithTable.append(path)
        lastPath = paths.last ?? ""
    }
    
    static func flattenKeyPath(_ paths: [String]) -> String {
        var path = ""
        for (index, p) in paths.enumerated() {
            if index == 0 {
                path.append(p.doubleQuotted)
            } else {
                path.append("->")
                path.append(p.singleQuotted)
            }
        }
        return path
    }
}

func formattedPath<T, V>(_ table: T.Type, _ kp: KeyPath<T, V>) -> _FormattedKeyPath where T: Reflectable {
    if let table = table as? Tableable.Type {
        return formattedPath(table.entity, kp)
    }
    return formattedPath(String(describing: table), kp)
}

func formattedPath<T, V>(_ table: String, _ kp: KeyPath<T, V>) -> _FormattedKeyPath where T: Reflectable {
    _FormattedKeyPath(table: table, paths: kp.paths)
}
