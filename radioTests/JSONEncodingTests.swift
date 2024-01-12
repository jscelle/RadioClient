//
//  JSONEncodingTests.swift
//  radioTests
//
//  Created by Artem Raykh on 07.12.2023.
//

import XCTest
@testable import radio // Replace with the actual module name

final class JSONEncodingTests: XCTestCase {
    
    var encoder: Encoding!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        encoder = JSONEncoding()
    }
    
    override func tearDownWithError() throws {
        encoder = nil
        try super.tearDownWithError()
    }
    
    func testJSONEncodingParametersInPOSTRequest() throws {
        let url = URL(string: "https://example.com")!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue // Use POST method
        
        let parameters: [String: Any] = [
            "username": "user123",
            "password": "password456"
        ]
        
        let response = try encoder.encode(base: request, parameters: parameters)
        
        // Verify the encoded HTTP body
        let expectedJSONData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        XCTAssertEqual(response.httpBody, expectedJSONData)
        XCTAssertEqual(response.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
    
    func testJSONEncodingEmptyParameters() throws {
        let url = URL(string: "https://example.com")!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let parameters: [String: Any] = [:] // Empty parameters
        
        let response = try encoder.encode(base: request, parameters: parameters)
            
        // Verify that the HTTP body is nil
        XCTAssertNil(response.httpBody)
        XCTAssertEqual(response.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
}
