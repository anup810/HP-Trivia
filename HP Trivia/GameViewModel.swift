//
//  Game.swift
//  HP Trivia
//
//  Created by Anup Saud on 2024-08-19.
//
import SwiftUI
import Foundation

@MainActor
class GameViewModel: ObservableObject {
    @Published var gameScore = 0
    @Published var questionScore = 5
    @Published var recentScores = [0,0,0]
    // Array to store all the questions decoded from JSON
    private var allQuestions: [Question] = []
    
    // Array to keep track of IDs of answered questions
    private var answeredQuestions: [Int] = []
    
    // Current question to be displayed
    var currentQuestion = Constants.previewQuestion
    
    // Array to store shuffled answers for the current question
    var answers: [String] = []
    
    // Array to store questions filtered by selected books
    var filteredQuestions: [Question] = []
    
    // Computed property to get the correct answer from the current question
    var correctAnswer: String {
        currentQuestion.answers.first(where: { $0.value == true })!.key
    }
    
    // Initializer to decode questions from the JSON file
    init() {
        decodeQuestions()
    }
    func startNewGame(){
        gameScore = 0
        questionScore = 5
        answeredQuestions = []
    }
    // Function to filter questions based on the selected books
    func filterQuestions(to books: [Int]) {
        filteredQuestions = allQuestions.filter { books.contains($0.book) }
    }
    
    // Function to select a new question that hasn't been answered yet
    func newQuestion() {
        // Return early if there are no filtered questions
        if filteredQuestions.isEmpty {
            return
        }
        
        // Reset answered questions if all have been answered
        if answeredQuestions.count == filteredQuestions.count {
            answeredQuestions = []
        }
        
        // Randomly select a new question that hasn't been answered
        var potentialQuestion = filteredQuestions.randomElement()!
        while answeredQuestions.contains(potentialQuestion.id) {
            potentialQuestion = filteredQuestions.randomElement()!
        }
        currentQuestion = potentialQuestion
        
        // Shuffle and store the answers for the current question
        answers = []
        for answer in currentQuestion.answers.keys {
            answers.append(answer)
        }
        answers.shuffle()
        questionScore = 5
    }
    
    // Function to handle the correct answer scenario
    func correct() {
        answeredQuestions.append(currentQuestion.id)
        withAnimation {
            // Update Score
            gameScore += questionScore
        }

    }
    func endgame(){
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
    }
    
    // Private function to decode the questions from the JSON file
    private func decodeQuestions() {
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
            do {
                // Load and decode the JSON data
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                allQuestions = try decoder.decode([Question].self, from: data)
                
                // Initially, all questions are available to be filtered
                filteredQuestions = allQuestions
            } catch {
                // Print an error message if decoding fails
                print("Error decoding JSON data: \(error)")
            }
        }
    }
}
