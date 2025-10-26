//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by Renaud Leroy on 19/10/2025.
//

import XCTest
import CoreData
import Combine
@testable import Arista

final class UserDataViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    var context: NSManagedObjectContext!
    var peristenceController: PersistenceController!
    var viewModel: UserDataViewModel!
    
    override func setUp() {
        super.setUp()
        peristenceController = PersistenceController(inMemory: true)
        context = peristenceController.container.viewContext
    }
    
    override func tearDown() {
        cancellables.removeAll()
        peristenceController = nil
        viewModel = nil
        context = nil
        super.tearDown()
    }
    
    func test_fetchUserData_shouldReturnUserData_whenUserExists() {
        // Given
        let user = User(context: context)
        user.firstName = "John"
        user.lastName = "Doe"
        try! context.save()
        
        let repository = UserRepository(viewContext: context)
        
        // When
        viewModel = UserDataViewModel(context: context, repository: repository)
        viewModel.fetchUserData()
        
        // Then
        XCTAssertEqual(viewModel.firstName, "John")
        XCTAssertEqual(viewModel.lastName, "Doe")
    }
    
    func test_fetchUserData_shouldReturnEmptyString_whenNoUser() {
        // Given
        let repository = UserRepository(viewContext: context)
        
        // When
        viewModel = UserDataViewModel(context: context, repository: repository)
        viewModel.fetchUserData()
        
        // Then
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")
    }
    
    func test_fetchUserData_shouldHandleNilValues() {
        // Given
        let user = User(context: context)
        user.firstName = nil
        user.lastName = nil
        try! context.save()
        
        let repository = UserRepository(viewContext: context)
        
        // When
        viewModel = UserDataViewModel(context: context, repository: repository)
        viewModel.fetchUserData()
        
        // Then
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")
    }
    
    func test_fetchUserData_shouldHandleEmptyFirstName() {
        // Given
        let user = User(context: context)
        user.firstName = ""
        user.lastName = "Smith"
        try! context.save()
        
        let repository = UserRepository(viewContext: context)
        
        // When
        viewModel = UserDataViewModel(context: context, repository: repository)
        viewModel.fetchUserData()
        
        // Then
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "Smith")
    }
    
    func test_fetchUserData_shouldHandleEmptyLastName() {
        // Given
        let user = User(context: context)
        user.firstName = "Jane"
        user.lastName = ""
        try! context.save()
        
        let repository = UserRepository(viewContext: context)
        
        // When
        viewModel = UserDataViewModel(context: context, repository: repository)
        viewModel.fetchUserData()
        
        // Then
        XCTAssertEqual(viewModel.firstName, "Jane")
        XCTAssertEqual(viewModel.lastName, "")
    }
}
