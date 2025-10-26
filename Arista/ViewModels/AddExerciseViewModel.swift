//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class AddExerciseViewModel: ObservableObject {
    @Published var category: ExerciseCategory = .football
    @Published var startTime: Date = Date()
    @Published var duration: Int = 0
    @Published var intensity: Int = 0
    @Published var errorMessage: String? = nil
    
    private var viewContext: NSManagedObjectContext
    private var repository: ExerciseRepositoryProtocol
    
    init(context: NSManagedObjectContext,
         repository: ExerciseRepositoryProtocol? = nil) {
        self.viewContext = context
        self.repository = repository ?? ExerciseRepository(viewContext: context)    }
    
    func addExercise() -> Bool {
        do {
            try repository.addExercise(
                category: category,
                duration: duration,
                intensity: intensity,
                startDate: startTime
            )
            return true
        } catch {
            errorMessage = "Failed to add exercise: \(error.localizedDescription)"
            return false
        }
    }
}
