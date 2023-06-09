//
//  TMDBTests.swift
//  TMDBTests
//
//  Created by Azis Ramdhan on 05/12/21.
//

import XCTest
@testable import TMDB

class TMDBTests: XCTestCase {

    // NetMonitor wraps NWPathMonitor, providing a convenient way to check for a network connection
    let networkMonitor = NetMonitor.shared
    // System Under Test (SUT), or the object this test case class is concerned with testing
    var sut: HomeViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = HomeViewModel(service: HomeDataService())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testPostsNotEmpty() throws {
        try XCTSkipUnless(networkMonitor.netOn, "Network connectivity needed for this test.")
        let promise = expectation(description: "Completion handler invoked")
        sut.onSuccessGetMovies = {
            promise.fulfill()
        }
        sut.getMovies(.popular)

        wait(for: [promise], timeout: 5)
        XCTAssertFalse(sut.movies.isEmpty)
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
