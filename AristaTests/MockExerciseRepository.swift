//
//  MockExerciseRepository.swift
//  AristaTests
//
//  Created by Renaud Leroy on 25/10/2025.
//

import Foundation

@testable import Arista


class MockExerciseRepository: ExerciseRepositoryProtocol {
    
    var errorToThrow: Error?
    var shouldThrowErrorForDelete: Bool = false
    var shouldThrowErrorForAdd: Bool = false
    var shouldThrowErrorForGet: Bool = false
    var exerciseToReturn: [Exercise] = []
    
    
    func getExercise() throws -> [Exercise] {
        if shouldThrowErrorForGet {
            if let error = errorToThrow {
                throw error
            }
            throw NSError(domain: "MockError", code: 998, userInfo: [
                NSLocalizedDescriptionKey: "Simulated getExercise error"
            ])
        }
        return exerciseToReturn
    }
    
    
    func addExercise(category: ExerciseCategory, duration: Int, intensity: Int, startDate: Date) throws {
        if shouldThrowErrorForAdd {
            if let error = errorToThrow {
                throw error
            }
            throw NSError(domain: "MockError", code: 999, userInfo: [
                NSLocalizedDescriptionKey: "Simulated addExercise error"
            ])
        }
    }
    
    func deleteExercise(_ exercise: Arista.Exercise) throws {
        if shouldThrowErrorForDelete {
            if let error = errorToThrow {
                throw error
            }
            throw NSError(domain: "MockError", code: 997, userInfo: [
                NSLocalizedDescriptionKey: "Simulated deleteExercise error"
            ])
        }
        
        if let index = exerciseToReturn.firstIndex(where: { $0.objectID == exercise.objectID }) {
            exerciseToReturn.remove(at: index)
        }
    }
}

