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

struct ItemManual {
  var id: Int
  var itemTitle: String

  init(dict: [String: Any]) {
    id = dict["id"] as! Int
    itemTitle = dict["itemTitle"] as! String
  }
}

// MARK: - Manual
struct ItemResponseManual {
  var result: [ItemManual]
  init(dict: [String: Any]) {
    result = (dict["result"] as! [[String: Any]]).map { ItemManual(dict: $0) }
  }
}

class ItemParser {
  func parse(from data: Data) -> ItemResponse {
    let decoder = JSONDecoder()
    return try! decoder.decode(ItemResponse.self, from: data)
  }
}

class ItemParserManual {
  func parse(from data: Data) -> ItemResponseManual {
    return ItemResponseManual(dict: try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any])
  }
}
