//
//  LocationRepoTests.swift
//  Travel
//
//  Created by k mao on 12/6/24.
//

import XCTest
@testable import Travel
import Combine
import FirebaseFirestore

class LocationRepositoryTests: XCTestCase {
  
  var locationRepository: LocationRepository!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    locationRepository = LocationRepository()
    cancellables = []
  }

  override func tearDown() {
    locationRepository = nil
    cancellables = nil
    super.tearDown()
  }

  // Test if locations are fetched correctly
  func testGetLocations() {
    let expectation = self.expectation(description: "Fetching locations")
    
    // Simulate fetching locations
    locationRepository.$locations
      .dropFirst()
      .sink { locations in
        XCTAssertGreaterThan(locations.count, 0, "Locations should be fetched")
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    // Trigger fetching locations
    locationRepository.get()

    waitForExpectations(timeout: 2.0, handler: nil)
  }

  // Test if search functionality filters locations based on search text
  func testSearchLocations() {
    let location1 = Location(id: "1", name: "Beach Park", latitude: 0.0, longitude: 0.0, address: "123 Beach St", duration: "2 hours", ratings: 5, sunday: "Yes", monday: "No", tuesday: "Yes", wednesday: "No", thursday: "Yes", friday: "Yes", saturday: "No", image: "beachImage", description: "A nice beach")
    let location2 = Location(id: "2", name: "Mountain View", latitude: 0.0, longitude: 0.0, address: "456 Mountain Rd", duration: "3 hours", ratings: 4, sunday: "Yes", monday: "Yes", tuesday: "No", wednesday: "Yes", thursday: "No", friday: "Yes", saturday: "Yes", image: "mountainImage", description: "A scenic mountain")
    
    // Mock the locations array
    locationRepository.locations = [location1, location2]
    
    // Simulate search for "Beach"
    locationRepository.search(searchText: "Beach")
    
    XCTAssertEqual(locationRepository.filteredLocations.count, 1, "There should be 1 location matching the search text")
    XCTAssertEqual(locationRepository.filteredLocations.first?.name, "Beach Park", "The filtered location should be 'Beach Park'")
  }

  // Test if filteredLocations remains empty when no matches are found
  func testSearchLocationsNoMatch() {
    let location1 = Location(id: "1", name: "Beach Park", latitude: 0.0, longitude: 0.0, address: "123 Beach St", duration: "2 hours", ratings: 5, sunday: "Yes", monday: "No", tuesday: "Yes", wednesday: "No", thursday: "Yes", friday: "Yes", saturday: "No", image: "beachImage", description: "A nice beach")
    
    // Mock the locations array
    locationRepository.locations = [location1]
    
    // Simulate search for a non-matching text
    locationRepository.search(searchText: "Mountain")
    
    XCTAssertEqual(locationRepository.filteredLocations.count, 0, "There should be no locations matching the search text")
  }

  // Test if search functionality handles empty search text correctly
  func testSearchLocationsEmptySearchText() {
    let location1 = Location(id: "1", name: "Beach Park", latitude: 0.0, longitude: 0.0, address: "123 Beach St", duration: "2 hours", ratings: 5, sunday: "Yes", monday: "No", tuesday: "Yes", wednesday: "No", thursday: "Yes", friday: "Yes", saturday: "No", image: "beachImage", description: "A nice beach")
    
    // Mock the locations array
    locationRepository.locations = [location1]
    
    // Simulate empty search
    locationRepository.search(searchText: "")
    
    XCTAssertEqual(locationRepository.filteredLocations.count, 0, "Filtered locations should remain empty with an empty search text")
  }

}