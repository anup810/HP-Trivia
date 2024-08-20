# HP Trivia

**HP Trivia** is an engaging iOS trivia game designed for Harry Potter fans. This app tests your knowledge of the Harry Potter universe through various questions, providing an immersive experience with sound effects and animations. The app uses Swift and SwiftUI, leveraging Core Data for local storage and StoreKit for in-app purchases.

## Features

- **Trivia Questions**: Answer questions related to the Harry Potter universe.
- **Gameplay Experience**: Enhanced with sound effects, animations, and smooth transitions.
- **Progress Tracking**: Save and load your progress, including the status of answered questions.
- **In-App Purchases**: Unlock additional content or features using StoreKit.
- **Data Persistence**: Core Data is used to store questions and game states locally.

## Installation

To run this project locally:

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/HP-Trivia.git
    ```
2. Open the project in Xcode:
    ```bash
    cd HP-Trivia
    open "HP Trivia.xcodeproj"
    ```



## How to Play

1. Launch the app and start a new game.
2. Answer the trivia questions by selecting the correct option.
3. Use hints if you get stuck, but remember, they might be limited!
4. Track your progress through the game and try to achieve a high score.
5. Purchase additional content via in-app purchases for a more extended experience.

## Project Structure

- **HP Trivia/**: Contains the main source code for the application.
- **GameViewModel.swift**: Manages the game state, including question handling, score calculation, and game logic.
- **ContentView.swift**: The main view of the application where the trivia questions are displayed.
- **GamePlayView.swift**: Handles the gameplay interface and user interactions.
- **Store.swift**: Manages in-app purchases using StoreKit.
- **Question.swift**: Defines the data structure for trivia questions.
- **HP_TriviaApp.swift**: The entry point of the application.
- **Assets.xcassets**: Contains all images and sound assets used in the app.
- **Constants.swift**: Stores constant values used throughout the app.

## Dependencies

- **Swift**: Programming language used for development.
- **SwiftUI**: Used for building the UI components.
- **Core Data**: For local storage and data persistence.
- **StoreKit**: Handles in-app purchases.
- **CocoaPods**: Dependency manager used to manage external libraries.

## Contributing

Contributions are welcome! If you find a bug or want to add a feature, feel free to submit a pull request.

1. Fork the repository.
2. Create a new branch:
    ```bash
    git checkout -b feature/your-feature-name
    ```
3. Make your changes and commit them:
    ```bash
    git commit -m "Add your feature"
    ```
4. Push to the branch:
    ```bash
    git push origin feature/your-feature-name
    ```
5. Open a pull request.


