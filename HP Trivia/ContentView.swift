//
//  ContentView.swift
//  HP Trivia
//
//  Created by Anup Saud on 2024-08-15.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    
    // State variables for audio player, animations, and view appearance
    @EnvironmentObject private var store : Store
    @EnvironmentObject private var game : GameViewModel
    @State private var audioPlayer: AVAudioPlayer!
    @State private var scalePlayButton = false
    @State private var moveBackgroundImage = false
    @State private var animateViewsIn = false
    @State private var showInstructionsView = false
    @State private var showSettingsView = false
    @State private var playGame = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background Image with moving animation
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.top, 3)
                    .offset(x: moveBackgroundImage ? geo.size.width / 1.1 : -geo.size.width / 1.1)
                    .onAppear {
                        // Animate background image to move back and forth
                        withAnimation(.linear(duration: 60).repeatForever()) {
                            moveBackgroundImage.toggle()
                        }
                    }
                
                VStack {
                    VStack {
                        if animateViewsIn {
                            VStack {
                                // Displaying "HP Trivia" with animation
                                Image(systemName: "bolt.fill")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                Text("HP")
                                    .font(.custom(Constants.hpFont, size: 70))
                                    .padding(.bottom, -50)
                                Text("Trivia")
                                    .font(.custom(Constants.hpFont, size: 60))
                            }
                            .padding(.top, 70)
                            .transition(.move(edge: .top)) // Animate entry from the top
                        }
                    }
                    .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                    
                    Spacer()
                    
                    VStack {
                        if animateViewsIn {
                            // Displaying recent scores with opacity transition
                            VStack {
                                Text("Recent Scores")
                                    .font(.title2)
                                Text("\(game.recentScores[0])")
                                Text("\(game.recentScores[1])")
                                Text("\(game.recentScores[2])")
                                
                            }
                            .font(.title3)
                            .padding(.horizontal)
                            .foregroundStyle(.white)
                            .background(.black.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .transition(.opacity)
                        }
                    }
                    .animation(.linear(duration: 1).delay(4), value: animateViewsIn)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                // Button to show instruction screen with slide-in animation
                                Button {
                                    // show instruction screen
                                    showInstructionsView.toggle()
                                } label: {
                                    Image(systemName: "info.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .shadow(radius: 5)
                                }
                                .transition(.offset(x: -geo.size.width / 4)) // Slide in from the left
                                .sheet(isPresented: $showInstructionsView, content: {
                                    InstructionsView()
                                })
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                // Play button with scaling animation
                                Button {
                                    // start a new game
                                    filterQuestion()
                                    game.startNewGame()
                                    playGame.toggle()
                                } label: {
                                    Text("Play")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 50)
                                        .background(store.books.contains(.active) ? .brown : .gray)
                                        .clipShape(RoundedRectangle(cornerRadius: 7))
                                        .shadow(radius: 5)
                                }
                                .scaleEffect(scalePlayButton ? 1.2 : 1) // Animate scaling effect
                                .onAppear {
                                    // Repeated scaling animation for the Play button
                                    withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                        scalePlayButton.toggle()
                                    }
                                }
                                .transition(.offset(y: geo.size.height / 3)) // Slide in from the bottom
                                .fullScreenCover(isPresented: $playGame) {
                                    GamePlayView()
                                        .environmentObject(game)
                                        .onAppear{
                                            audioPlayer.setVolume(0, fadeDuration: 2)
                                        }
                                        .onDisappear{
                                            audioPlayer.setVolume(1, fadeDuration: 3)
                                        }
                                }
                                .disabled(store.books.contains(.active) ? false : true)
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                        
                        
                        
                        Spacer()
                        
                        
                        VStack {
                            if animateViewsIn {
                                // Button to show settings screen with slide-in animation
                                Button {
                                    // show setting screen
                                    showSettingsView.toggle()
                                    
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .shadow(radius: 5)
                                }
                                .transition(.offset(x: geo.size.width / 4)) // Slide in from the right
                                .sheet(isPresented: $showSettingsView, content: {
                                   SettingsView()
                                        .environmentObject(store)
                                })
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        
                        Spacer()
                    }
                    .frame(width: geo.size.width)
                    
                    VStack{
                        if animateViewsIn {
                            if store.books.contains(.active) == false{
                                Text("No questions available. Go to setting.⬆️")
                                    .multilineTextAlignment(.center)
                                    .transition(.opacity)
                            }
                        }
                    }
                    .animation(.easeInOut.delay(2), value: animateViewsIn)
                    
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea() // Ignore safe area to cover the full screen
        .onAppear {
            animateViewsIn = true // Trigger animations on view appearance
             playAudio() // to play background music
        }
    }
    
    // Function to play background music
    private func playAudio() {
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        audioPlayer.numberOfLoops = -1 // Loop the audio indefinitely
        audioPlayer.play() // Start playing the audio
    }
    private func filterQuestion(){
        var books:[Int] = []
        for(index,status) in store.books.enumerated(){
            if status == .active{
                books.append(index + 1)
            }
        }
        game.filterQuestions(to: books)
        game.newQuestion()
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(GameViewModel())
}
