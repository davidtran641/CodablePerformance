# Codable Performance Benchmark
A simple benchmark to compare performance between Codable & Manual method

## Data structure
Struct can be found at `Item.swift`, which contains both `Item` for codable & `ItemManual` using manual way.

Item is a simple struct which has 2 properties `id` & `itemTitle`

The benchmark will try to parse a list of 100K & 1M items.
Benchmark code can be found at `CodablePerformanceTests.swift`. It's using traditional `measure` test provided by XCTestCase.

## Result
Manual parsing still faster than codable even though codable makes code cleaner & shorter.

| Number of items | Codable | Manual |
| --- | --- | --- |
| 100,000 | 0.564s | 0.370s|
| 1000,000 | 6.2s | 4.16s |





