//
//  TMDBDetailTests.swift
//  TMDBTests
//
//  Created by Azis Ramdhan on 06/12/21.
//

import XCTest
@testable import TMDB

class TMDBDetailTests: XCTestCase {

    // NetMonitor wraps NWPathMonitor, providing a convenient way to check for a network connection
    let networkMonitor = NetMonitor.shared
    // System Under Test (SUT), or the object this test case class is concerned with testing
    var sut: DetailViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = DetailViewModel(service: DetailDataService())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMovieDetailExist() throws {
        try XCTSkipUnless(networkMonitor.netOn, "Network connectivity needed for this test.")
        let promise = expectation(description: "Completion handler invoked")
        sut.onSuccessGetMovieDetail = {
            promise.fulfill()
        }
        let venomMovieId = 580489
        sut.getMovieDetail(venomMovieId)

        wait(for: [promise], timeout: 5)
        XCTAssertNotNil(sut.movie)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
