//
//  CityWeatherTests.swift
//  CityWeatherTests
//
//  Created by Alex Meraz on 10/3/24.
//

import XCTest
import Combine
@testable import CityWeather

final class CityWeatherTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    var locationManager: LocationManager!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockWeatherService = MockWeatherService()
        locationManager = LocationManager()
        viewModel = WeatherViewModel(weatherService: mockWeatherService, locationManager: locationManager)
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockWeatherService = nil
        locationManager = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchGeolocationsSuccess() {
        // Arrange
        let geolocations = [Geolocation(name: "San Francisco", lat: 37.7749, lon: -122.4194, country: "US", state: "California")]
        mockWeatherService.fetchGeolocationsResult = .success(geolocations)

        // Expectation
        let expectation = XCTestExpectation(description: "Geolocation fetch should complete")
        
        // When
        viewModel.fetchGeolocations(for: "San Francisco")
        
        // Add delay to allow async call to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Then
            XCTAssertEqual(self.viewModel.geolocations.count, 1)
            XCTAssertEqual(self.viewModel.geolocations.first?.name, "San Francisco")
            XCTAssertNil(self.viewModel.errorMessage)
            
            // Fulfill the expectation after the assertions are completed
            expectation.fulfill()
        }
        
        // Wait for expectation to be fulfilled, or timeout after
        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchGeolocationsFailure() {
        // Arrange
        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch geolocations"])
        mockWeatherService.fetchGeolocationsResult = .failure(error)
        
        // Expectation
        let expectation = XCTestExpectation(description: "Geolocation fetch should NOT complete")
        
        // When
        viewModel.fetchGeolocations(for: "San Francisco")
        
        // Add delay to allow async call to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Then
            XCTAssertEqual(self.viewModel.geolocations.count, 0)
            XCTAssertEqual(self.viewModel.errorMessage, "Failed to fetch geolocations")
            
            // Fulfill the expectation after the assertions are completed
            expectation.fulfill()
        }
        
        // Wait for expectation to be fulfilled, or timeout
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchWeatherSuccess() {
        // Arrange
        let geolocation = Geolocation(name: "San Francisco", lat: 37.7749, lon: -122.4194, country: "US", state: "California")
        let main = Main(temp: 20.0, humidity: 70)
        let detail = WeatherDetail(description: "Clear", icon: "01d")
        let weather = Weather(name: "San Francisco", main: main, weather: [detail])
        mockWeatherService.fetchWeatherResult = .success(weather)

        // Expectation
        let expectation = XCTestExpectation(description: "Weather fetch should complete")
        
        // When
        viewModel.fetchWeather(for: geolocation)

        // Add delay to allow async call to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Then
            XCTAssertEqual(self.viewModel.weather?.name, "San Francisco")
            XCTAssertNil(self.viewModel.errorMessage)
            
            // Fulfill the expectation after the assertions are completed
            expectation.fulfill()
        }
        
        // Wait for expectation to be fulfilled, or timeout
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchWeatherFailure() {
        // Arrange
        let geolocation = Geolocation(name: "San Francisco", lat: 37.7749, lon: -122.4194, country: "US", state: "California")
        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch weather"])
        mockWeatherService.fetchWeatherResult = .failure(error)

        // Expectation
        let expectation = XCTestExpectation(description: "Weather fetch should NOT complete")
        
        // When
        viewModel.fetchWeather(for: geolocation)

        // Add delay to allow async call to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Then
            XCTAssertNil(self.viewModel.weather)
            XCTAssertEqual(self.viewModel.errorMessage, "Failed to fetch weather")
            
            // Fulfill the expectation after the assertions are completed
            expectation.fulfill()
        }
        
        // Wait for expectation to be fulfilled, or timeout
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSaveAndLoadLastSearchedGeolocation() {
        // Arrange
        let geolocation = Geolocation(name: "San Francisco", lat: 37.7749, lon: -122.4194, country: "US", state: "California")

        // Act
        viewModel.saveLastSearchedGeolocation(geolocation)
        viewModel.loadLastSearchedGeolocation()

        // Assert
        XCTAssertEqual(viewModel.lastGeolocation?.name, "San Francisco")
    }
    
    func testHasUserSearchedForCity() {
        // Act
        viewModel.setUserHasSearchedForCity()

        // Assert
        XCTAssertTrue(viewModel.hasUserSearchedForCity())
    }
}
