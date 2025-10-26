//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class ExerciseListViewModel: ObservableObject {
    @Published var exercises = [Exercise]()
    @Published var errorMessage: ExerciseError?
    
    var viewContext: NSManagedObjectContext
    private var repository: ExerciseRepositoryProtocol
    
    init(context: NSManagedObjectContext, repository: ExerciseRepositoryProtocol? = nil) {
            self.viewContext = context
            self.repository = repository ?? ExerciseRepository(viewContext: context)
            fetchExercises()
        }
    
    func fetchExercises() {
        do {
            exercises = try repository.getExercise()
        } catch {
            errorMessage = .fetchExerciseFailed
            exercises = []
        }
    }
    
    func removeExercise(at indexSet: IndexSet) {
        guard let index = indexSet.first, exercises.indices.contains(index) else {
            return
        }
        do {
            try repository.deleteExercise(exercises[index])
        } catch {
            errorMessage = .deleteExerciseFailed
        }
        fetchExercises()
    }
}
