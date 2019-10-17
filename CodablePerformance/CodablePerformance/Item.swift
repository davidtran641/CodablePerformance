//
//  Item.swift
//  CodablePerformance
//
//  Created by Tran Duc on 10/17/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation

// MARK: - Codable
struct Item: Codable {
  var id: Int
  var itemTitle: String
}

struct ItemResponse: Codable {
  var result: [Item]
}

class ItemParser {
  func parse(from data: Data) throws -> ItemResponse  {
    let decoder = JSONDecoder()
    return try decoder.decode(ItemResponse.self, from: data)
  }
}

// MARK: - Manual
struct ItemManual {
  var id: Int
  var itemTitle: String

  init(dict: [String: Any]) {
    id = dict["id"] as! Int
    itemTitle = dict["itemTitle"] as! String
  }
}

struct ItemResponseManual {
  var result: [ItemManual]
  init(dict: [String: Any]) {
    result = (dict["result"] as! [[String: Any]]).map { ItemManual(dict: $0) }
  }
}

class ItemParserManual {
  func parse(from data: Data) throws -> ItemResponseManual {
    return ItemResponseManual(dict: try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any])
  }
}

// MARK: - Manual With Casting value
struct ItemManualCast {
  var id: Int
  var itemTitle: String

  init(dict: [String: Any]) throws {
    id = try cast(dict["id"])
    itemTitle = try cast(dict["itemTitle"])
  }
}

struct ItemResponseManualCast {
  var result: [ItemManualCast]
  init(dict: [String: Any]) throws {
    result = try (try cast(dict["result"]) as [[String: Any]]).map { try ItemManualCast(dict: $0) }
  }
}

class ItemParserManualCast {
  func parse(from data: Data) throws -> ItemResponseManualCast  {
    return try ItemResponseManualCast(dict: try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any])
  }
}

// MARK: Cast helper
struct CastError: Error {
  public let explanation: String
  public let file: String
  public let line: Int
  public let function: String

  public init(explanation: String, file: String = #file, line: Int = #line, function: String = #function) {
    self.explanation = explanation
    self.file = URL(fileURLWithPath: file).lastPathComponent
    self.line = line
    self.function = function
  }

}

@inline(__always)
func cast<FromType, ToType>(_ value: FromType, file: String = #file, line: Int = #line, function: String = #function) throws -> ToType {
  guard let toValue = value as? ToType else { throw CastError(explanation: " \(value) is unexpected", file: file, line: line, function: function) }
  return toValue
}
