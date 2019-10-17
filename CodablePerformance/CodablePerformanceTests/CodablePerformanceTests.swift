//
//  CodablePerformanceTests.swift
//  CodablePerformanceTests
//
//  Created by Tran Duc on 10/17/19.
//  Copyright © 2019 David. All rights reserved.
//

import XCTest
@testable import CodablePerformance

class CodablePerformanceTests: XCTestCase {

  var count = 1000 * 1000
  var data: Data!

  override func setUp() {
    super.setUp()
    data = createData(count: count)
  }

  override func tearDown() {
    data = nil
    super.tearDown()
  }

  func testAutoDecode() {
    let parser = ItemParser()
    self.measure {
      let _ = parser.parse(from: data)
    }
  }

  func testManualDecode() {
    let parser = ItemParserManual()
    self.measure {
      let _ = parser.parse(from: data)
    }
  }

  private func createData(count: Int) -> Data {
    let response = ItemResponse(result: (0..<count).map { Item(id: $0, itemTitle: "Title at \($0)") })
    let encoder = JSONEncoder()
    return try! encoder.encode(response)
  }

}

