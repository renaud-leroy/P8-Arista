//
//  ExerciseListViewModelTests.swift
//  AristaTests
//
//  Created by Renaud Leroy on 04/10/2025.
//

import XCTest
import CoreData
import Combine
@testable import Arista

final class ExerciseListViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    private func emptyEntities(context: NSManagedObjectContext) {
        
        let fetchRequest = Exercise.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
  
        for exercice in objects {
            context.delete(exercice)
        }
        try! context.save()
    }
    
    private func addExercice(context: NSManagedObjectContext, category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) {
        
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        try! context.save()
    
        let newExercise = Exercise(context: context)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.startDate = startDate
        newExercise.user = newUser
        try! context.save()
    }
    
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDownWithError() throws {
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    func test_WhenNoExerciseIsInDatabase_FetchExercise_ReturnEmptyList() {
        
        // Clean manually all data
        
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext)
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")
        
        viewModel.$exercises
            .sink { exercises in
                XCTAssert(exercises.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    
    func test_WhenAddingOneExerciseInDatabase_FEtchExercise_ReturnAListContainingTheExercise() {
        
        // Clean manually all data
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date = Date()
        addExercice(context: persistenceController.container.viewContext,
                    category: "Football",
                    duration: 10,
                    intensity: 5,
                    startDate: date,
                    userFirstName: "Ericw",
                    userLastName: "Marcus")
        
        
        
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext)
        
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")
        
        
        
        viewModel.$exercises
            .sink { exercises in
                XCTAssert(exercises.isEmpty == false)
                XCTAssert(exercises.first?.category == "Football")
                XCTAssert(exercises.first?.duration == 10)
                XCTAssert(exercises.first?.intensity == 5)
                XCTAssert(exercises.first?.startDate == date)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    
    
    func test_WhenAddingMultipleExerciseInDatabase_FetchExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        
        // Clean manually all data
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)

        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))

        addExercice(context: persistenceController.container.viewContext,
                    category: "Football",
                    duration: 10,
                    intensity: 5,
                    startDate: date1,
                    userFirstName: "Ericn",
                    userLastName: "Marcusi")
        
        addExercice(context: persistenceController.container.viewContext,
                    category: "Running",
                    duration: 120,
                    intensity: 1,
                    startDate: date3,
                    userFirstName: "Ericb",
                    userLastName: "Marceau")
        
        addExercice(context: persistenceController.container.viewContext,
                    category: "Fitness",
                    duration: 30,
                    intensity: 5,
                    startDate: date2,
                    userFirstName: "Frédericp",
                    userLastName: "Marcus")
        
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext)
        
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")

        viewModel.$exercises
            .sink { exercises in
                XCTAssert(exercises.count == 3)
                XCTAssert(exercises[0].category == "Football")
                XCTAssert(exercises[1].category == "Fitness")
                XCTAssert(exercises[2].category == "Running")
                expectation.fulfill()
            }
        
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)    
    }
    
    func test_removeExercise_removesExercise() {
        // Given
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext
        emptyEntities(context: context)
        
        addExercice(context: persistenceController.container.viewContext,
                    category: "Football",
                    duration: 10,
                    intensity: 5,
                    startDate: Date(),
                    userFirstName: "Donnie",
                    userLastName: "Brasco")
        
        let viewModel = ExerciseListViewModel(context: context)
        
        // When
        viewModel.removeExercise(at: IndexSet(integer: 0))
        
        // Then
        let fetchedExercises = try! context.fetch(Exercise.fetchRequest())
        XCTAssertEqual(fetchedExercises.count, 0)
    }
    
    func test_removeExercise_WithInvalidIndex_DoesNotCrash() {
        // Given
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext
        emptyEntities(context: context)
        
        let viewModel = ExerciseListViewModel(context: context)
        
        // When
        viewModel.removeExercise(at: IndexSet(integer: 0))
        
        // Then
        XCTAssertTrue(viewModel.exercises.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_errorMessage_WhenFetchingExercisesFails_SetsErrorMessage() {
        // Given
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext
        
        let mockRepository = MockExerciseRepository()
        mockRepository.shouldThrowErrorForGet = true
        
        // When
        let viewModel = ExerciseListViewModel(context: context, repository: mockRepository)
        
        // Then
        XCTAssertEqual(viewModel.errorMessage, .fetchExerciseFailed)
        XCTAssertTrue(viewModel.exercises.isEmpty)
        
    }
}
