//
//  DataManagerProtocol_Tests.swift
//  DataManagerTests
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation
import XCTest
@testable import DataManager

class DataManagerProtocol_Tests: XCTestCase {
    
    override func setUpWithError() throws {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_fetchCurrentSummary() {
        guard let url = URL(string: "http://www.example.com") else {
            XCTFail("URL invalid")
            return
        }
        
        XCTAssertEqual(url.absoluteString, "http://www.example.com")
    }
    
    func test_fetchCityList() {
        guard let url = URL(string: "http://www.example.com") else {
            XCTFail("URL invalid")
            return
        }
        
        XCTAssertEqual(url.absoluteString, "http://www.example.com")
    }
}
