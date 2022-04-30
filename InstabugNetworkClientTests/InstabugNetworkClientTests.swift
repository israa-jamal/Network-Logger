//
//  InstabugNetworkClientTests.swift
//  InstabugNetworkClientTests
//
//  Created by Yousef Hamza on 1/13/21.
//

import XCTest
@testable import InstabugNetworkClient

class InstabugNetworkClientTests: XCTestCase {

    func testA_RecordsAreRemovedOnLaunching() {
        XCTAssertTrue(NetworkClient.shared.allNetworkRequests().isEmpty)
    }
    
    func testB_DataIsRecordedCorrectly() {
        NetworkClient.shared.logger.saveRecord(url: "www.google.com", method: "Get", payload: "Random request payload", statusCode: 200, error: NSError(domain: "Error Domain", code: 404, userInfo:nil), responseBody: "Random response payload")
        XCTAssertEqual(NetworkClient.shared.allNetworkRequests().count, 1)
        
        let record = NetworkClient.shared.allNetworkRequests().first
        XCTAssertNotNil(record)
        XCTAssertNotNil(record?.createdAt)
        XCTAssertNotNil(record?.request)
        XCTAssertNotNil(record?.response)
        XCTAssertEqual(record?.request?.url, "www.google.com")
        XCTAssertEqual(record?.request?.method, "Get")
        XCTAssertEqual(record?.request?.payload, "Random request payload")
        XCTAssertEqual(record?.response?.statusCode, 200)
        XCTAssertEqual(record?.response?.payload, "Random response payload")
        XCTAssertEqual(record?.response?.error?.code, 404)
        XCTAssertEqual(record?.response?.error?.domain, "Error Domain")
    }
    
    func testC_FetchingAllRecords() {
        XCTAssertNotNil(NetworkClient.shared.allNetworkRequests())
    }

    func testD_RecordsNotExceedingLimit() {
        for _ in 0..<1000 {
            NetworkClient.shared.logger.saveRecord(url: "www.google.com", method: "Get", payload: nil, statusCode: nil, error: nil, responseBody: nil)
        }
        XCTAssertEqual(NetworkClient.shared.allNetworkRequests().count, 1000)
        NetworkClient.shared.logger.saveRecord(url: "www.google.com", method: "Get", payload: nil, statusCode: nil, error: nil, responseBody: nil)
        NetworkClient.shared.logger.saveRecord(url: "www.google.com", method: "Get", payload: nil, statusCode: nil, error: nil, responseBody: nil)
        XCTAssertEqual(NetworkClient.shared.allNetworkRequests().count, 1000)
    }
    
    func testE_RequestPayloadNotExceedingLimit() {
        let requestPayload = randomString(length: Size.MB.length) + "more text"
        NetworkClient.shared.logger.deleteAllRecords()
        NetworkClient.shared.logger.saveRecord(url: "www.google.com", method: "Get", payload: requestPayload, statusCode: nil, error: nil, responseBody: nil)
        XCTAssertTrue(NetworkClient.shared.allNetworkRequests().first?.request?.payload?.count ?? 0 <= Size.MB.length)
        XCTAssertEqual(NetworkClient.shared.allNetworkRequests().first?.request?.payload, "(payload too large)")
    }
    
    func testF_ResponsePayloadNotExceedingLimit() {
        let responsePayload = randomString(length: Size.MB.length) + "more text"
        NetworkClient.shared.logger.deleteAllRecords()
        NetworkClient.shared.logger.saveRecord(url: "www.google.com", method: "Get", payload: nil, statusCode: nil, error: nil, responseBody: responsePayload)
        XCTAssertTrue(NetworkClient.shared.allNetworkRequests().first?.response?.payload?.count ?? 0 <= Size.MB.length)
        XCTAssertEqual(NetworkClient.shared.allNetworkRequests().first?.response?.payload, "(payload too large)")
    }
    
    func testG_ApisNotFailing() {
        NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
            XCTAssertNotNil(data)
        }
        
        NetworkClient.shared.post(URL(string: "https://httpbin.org/post")!) { data in
            XCTAssertNotNil(data)
        }
        
        NetworkClient.shared.put(URL(string: "https://httpbin.org/put")!) { data in
            XCTAssertNotNil(data)
        }
        NetworkClient.shared.delete(URL(string: "https://httpbin.org/delete")!) { data in
            XCTAssertNotNil(data)
        }
    }
}

//MARK:- Helpers

extension InstabugNetworkClientTests {
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
