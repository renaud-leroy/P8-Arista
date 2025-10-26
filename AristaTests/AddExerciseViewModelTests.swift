//
//  AddExerciseViewModelTests.swift
//  AristaTests
//
//  Created by Renaud Leroy on 04/10/2025.
//

import XCTest
import CoreData
import Combine
@testable import Arista

final class AddExerciseViewModelTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var persistenceController: PersistenceController!
    var viewModel: AddExerciseViewModel!
    
    override func setUp() {
        super.setUp()
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        
        //Creation d'utilisateur nécessaire pour les tests
        let user = User(context: context)
        user.firstName = "Test"
        user.lastName = "User"
        try! context.save()
        
        
        viewModel = AddExerciseViewModel(context: context)
    }
    
    override func tearDown() {
        context = nil
        persistenceController = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_addExercise_addsExerciseToContext() {
        // Given
        let date = Date()
        
        viewModel.category = .football
        viewModel.duration = 10
        viewModel.intensity = 5
        viewModel.startTime = date
        
        // When
        let success = viewModel.addExercise()
        
        // Then
        XCTAssertTrue(success)
        
        let repository = ExerciseRepository(viewContext: context)
        let exercises = try! repository.getExercise()
        
        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.category, "Football")
        XCTAssertEqual(exercises.first?.duration, 10)
        XCTAssertEqual(exercises.first?.intensity, 5)
        XCTAssertEqual(exercises.first?.startDate, date)
    }
    
    func test_addExercise_withDifferentCategory() {
        // Given
        let date = Date()
        
        viewModel.category = .natation
        viewModel.duration = 45
        viewModel.intensity = 10
        viewModel.startTime = date
        
        // When
        let success = viewModel.addExercise()
        
        // Then
        XCTAssertTrue(success)
        
        let repository = ExerciseRepository(viewContext: context)
        let exercises = try! repository.getExercise()
        
        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.category, "Natation")
    }
    
    func test_addExercise_WithNoDuration() {
        // Given
        let date = Date()
        
        viewModel.category = .course
        viewModel.duration = 0
        viewModel.intensity = 10
        viewModel.startTime = date
        
        // When
        let success = viewModel.addExercise()
        
        // Then
        XCTAssertTrue(success)
        
        let repository = ExerciseRepository(viewContext: context)
        let exercises = try! repository.getExercise()
        
        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.duration, 0)
    }
    
    func test_addExercise_WithNoIntensity() {
        // Given
        let date = Date()
        
        viewModel.category = .course
        viewModel.duration = 45
        viewModel.intensity = 0
        viewModel.startTime = date
        
        // When
        let success = viewModel.addExercise()
        
        // Then
        XCTAssertTrue(success)
        
        let repository = ExerciseRepository(viewContext: context)
        let exercises = try! repository.getExercise()
        
        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.intensity, 0)
    }
    
    func test_addExercise_WithNoStartTime() {
        // Given
        viewModel.category = .course
        viewModel.duration = 45
        viewModel.intensity = 10
        viewModel.startTime = Date()
        
        // When
        let success = viewModel.addExercise()
        
        // Then
        XCTAssertTrue(success)
        
        let repository = ExerciseRepository(viewContext: context)
        let exercises = try! repository.getExercise()
        
        XCTAssertEqual(exercises.count, 1)
    }
    
    func test_addExercise_returnsFalse_whenRepositoryThrowsError() {
        // Given
        let mockRepo = MockExerciseRepository()
        mockRepo.shouldThrowErrorForAdd = true
        
        let viewModelWithMock = AddExerciseViewModel(context: context, repository: mockRepo)
        viewModelWithMock.category = .football
        viewModelWithMock.duration = 60
        viewModelWithMock.intensity = 5
        viewModelWithMock.startTime = Date()
        
        // When
        let success = viewModelWithMock.addExercise()
        
        // Then
        XCTAssertFalse(success)
        XCTAssertNotNil(viewModelWithMock.errorMessage)
        XCTAssertTrue(viewModelWithMock.errorMessage!.contains("Failed to add exercise"))
      
    }
}
