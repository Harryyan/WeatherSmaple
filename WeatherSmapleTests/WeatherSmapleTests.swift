//
//  WeatherSmapleTests.swift
//  WeatherSmapleTests
//
//  Created by Harry Yan on 7/11/20.
//

import XCTest
@testable import WeatherSmaple

class WeatherSmapleTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        let request = WeatherRequest(lat: 0, lon: 0)
        let webService = WeatherService()
        
        webService.loadWeather(on: request) { result in
            if case .success(let value) = result {
                XCTAssertEqual(value?.name, "Auckland")
            }
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
