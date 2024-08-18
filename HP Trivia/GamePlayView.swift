//
//  GamePlay.swift
//  HP Trivia
//
//  Created by Anup Saud on 2024-08-16.
//

import SwiftUI
import AVKit

struct GamePlayView: View {
    @Environment(\.dismiss) private var dismiss
    @Namespace private var namespace
    @State private var backgroundMusicPlayer: AVAudioPlayer!
    @State private var sfxAudioPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    @State private var tappedCorrectAnswer = false
    @State private var hintWiggle = false
    @State private var scaleNextButton = false
    @State private var movePointToScore = false
    @State private var showAlert = false
    @State private var revealHint = false
    @State private var revealBook = false
    //@State private var tappedWrongAnswer = false
    @State private var wrongAnswerTapped: [Int] = []
    
    let tempAnswers = [true,false,false,false]
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height * 1.05)
                    .overlay(Rectangle().foregroundStyle(.black.opacity(0.7)))
                VStack{
                    //  MARK: Controls
                    HStack{
                        Button("End Game"){
                            //TODO: End Game
                            showAlert = true
                            
                        }.buttonStyle(.borderedProminent)
                            .tint(.red.opacity(0.5))
                            .alert(isPresented: $showAlert){
                                Alert(title: Text("End Game"),
                                      message: Text("Are you sure want to end the game?"), primaryButton: .destructive(Text("Yes")){
                                    dismiss()
                                }, secondaryButton: .cancel(Text("No")))
                            }
                        
                        
                        Spacer()
                        Text("Score: 33")
                    }
                    .padding()
                    .padding(.vertical, 40)
                    //MARK: Questions
                    VStack{
                        if animateViewsIn{
                            Text("Who is Harry Potter?")
                                .font(.custom(Constants.hpFont, size: 50))
                                .multilineTextAlignment(.center)
                                .padding()
                                .transition(.scale)
                                .opacity(tappedCorrectAnswer ? 0.1 : 1)
                        }
                    }
                    .animation(.easeInOut(duration:animateViewsIn ? 2 : 0), value: animateViewsIn)
                    Spacer()
                    //MARK: Hints
                    HStack{
                        VStack {
                            if animateViewsIn {
                                Image(systemName: "questionmark.app.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                    .foregroundStyle(.cyan)
                                    .rotationEffect(.degrees(hintWiggle ? -13 : -17))
                                    .padding()
                                    .padding(.leading, 20)
                                    .transition(.offset(x: -geo.size.width / 2))
                                    .onAppear(perform: {
                                        withAnimation(.easeInOut(duration: 0.1).repeatCount(9).delay(5).repeatForever()){
                                            hintWiggle = true
                                        }
                                    })
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 1)){
                                            revealHint = true
                                        }
                                        playflipSound()
                                    }
                                    .rotation3DEffect(.degrees(revealHint ? 1440 : 0), axis: (x: 0 , y: 1, z: 0))
                                    .scaleEffect(revealHint ? 5 : 1)
                                    .opacity(revealHint ? 0 : 1)
                                    .offset(x: revealHint ? geo.size.width / 2 : 0)
                                    .overlay(Text("The Boy who ___")
                                        .padding(.leading,33)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.center)
                                        .opacity(revealHint ? 1 : 0)
                                        .scaleEffect(revealHint ? 1.33 : 1)
                                             
                                    )
                                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                    .disabled(tappedCorrectAnswer)
                                
                            }
                        }
                        .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                        Spacer()
                        VStack{
                            if animateViewsIn {
                                Image(systemName: "book.closed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .foregroundStyle(.black)
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,height: 100)
                                    .background(.cyan)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .rotationEffect(.degrees(hintWiggle ? 13 : 17))
                                    .padding()
                                    .padding(.trailing,20)
                                    .transition(.offset(x: geo.size.width/2))
                                    .onAppear(perform: {
                                        withAnimation(.easeInOut(duration: 0.1).repeatCount(9).delay(5).repeatForever()){
                                            hintWiggle = true
                                        }
                                    })
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 1)){
                                            revealBook = true
                                        }
                                        playflipSound()
                                    }
                                    .rotation3DEffect(.degrees(revealBook ? 1440 : 0), axis: (x: 0 , y: 1, z: 0))
                                    .scaleEffect(revealBook ? 5 : 1)
                                    .opacity(revealBook ? 0 : 1)
                                    .offset(x: revealBook ? -geo.size.width / 2 : 0)
                                    .overlay(Image("hp1")
                                        .resizable().scaledToFit()
                                        .padding(.trailing,33)
                                        .padding(.bottom)
                                        .opacity(revealBook ? 1 : 0)
                                        .scaleEffect(revealBook ? 1.33 : 1)
                                             
                                    )
                                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                    .disabled(tappedCorrectAnswer)
                                
                            }
                        }
                        .animation(.easeOut(duration: animateViewsIn ? 2 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                        
                    }
                    .padding(.bottom)
                    //MARK: Answers
                    LazyVGrid(columns:[GridItem(),GridItem()]){
                        ForEach(1..<5){ i in
                            if tempAnswers[i-1] == true{
                                VStack{
                                    if animateViewsIn {
                                        if tappedCorrectAnswer == false{
                                            Text("Answer \(i)")
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .padding(10)
                                                .frame(width: geo.size.width/2.15,height: 80)
                                                .background(.green.opacity(0.5))
                                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                                .transition(.asymmetric(insertion: .scale, removal: .scale(scale: 5).combined(with: .opacity.animation(.easeOut(duration: 0.5)))))
                                                .matchedGeometryEffect(id: "answer", in: namespace)
                                                .onTapGesture {
                                                    withAnimation(.easeOut(duration: 1)){
                                                        tappedCorrectAnswer = true
                                                        
                                                    }
                                                    playCorrectAnswerSound()
                                                }
                                        }
                                    }
                                }
                                .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                            }
                            else{
                                VStack{
                                    if animateViewsIn {
                                        Text("Answer \(i)")
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .padding(10)
                                            .frame(width: geo.size.width/2.15,height: 80)
                                            .background(wrongAnswerTapped.contains(i) ?.red.opacity(0.5) : .green.opacity(0.5))
                                            .clipShape(RoundedRectangle(cornerRadius: 25))
                                            .transition(.scale)
                                            .onTapGesture { withAnimation(.easeOut(duration: 1)){
                                                wrongAnswerTapped.append(i)
                                                
                                            }
                                                playWrongAnswerSound()
                                                giveWrongFeedback()
                                                
                                            }
                                            .scaleEffect(wrongAnswerTapped.contains(i) ? 0.8 : 1)
                                            .disabled(tappedCorrectAnswer||wrongAnswerTapped.contains(i))
                                            .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                        
                                    }
                                }
                                .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                            }
                        }
                        
                        
                    }
                    Spacer()
                }.frame(width: geo.size.width, height: geo.size.height)
                    .foregroundStyle(.white)
                
                //MARK: Celebration
                VStack{
                    Spacer()
                    VStack{
                        if tappedCorrectAnswer{
                            Text("5")
                                .font(.largeTitle)
                                .padding(.top,50)
                                .transition(.offset(y: -geo.size.height / 4))
                                .offset(x: movePointToScore ? geo.size.width/2.3   : 0 ,y: movePointToScore ? -geo.size.height/13  : 0)
                                .opacity(movePointToScore ? 0 : 1)
                                .onAppear{
                                    withAnimation(.easeInOut(duration: 1).delay(3)){
                                        movePointToScore = true
                                    }
                                    
                                }
                        }
                    }
                    .animation(.easeInOut(duration: 1).delay(2), value: tappedCorrectAnswer)
                    Spacer()
                    VStack{
                        if tappedCorrectAnswer{
                            Text("Brilliant!")
                                .font(.custom(Constants.hpFont, size: 100))
                                .transition(.scale.combined(with: .offset(y: -geo.size.height/2)))
                        }
                    }
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 1 : 0).delay(tappedCorrectAnswer ? 1 : 0), value: tappedCorrectAnswer)
                    Spacer()
                    if tappedCorrectAnswer{
                        Text("Answer 1")
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: geo.size.width / 2.15 ,height: 80)
                            .background(.green.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .scaleEffect(2)
                            .matchedGeometryEffect(id: "answer", in: namespace)
                    }
                    Spacer()
                    Spacer()
                    VStack{
                        if tappedCorrectAnswer{
                            Button("Next Level>"){
                                // Reset level for next question
                                animateViewsIn = false
                                tappedCorrectAnswer = false
                                revealHint = false
                                revealBook = false
                                movePointToScore = false
                                wrongAnswerTapped = []
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    animateViewsIn = true
                                }
                            }.buttonStyle(.borderedProminent)
                                .tint(.blue.opacity(0.5))
                                .font(.largeTitle)
                                .transition(.offset(y: geo.size.height / 3))
                                .scaleEffect(scaleNextButton ? 1.2 : 1)
                                .onAppear{
                                    withAnimation(.easeInOut(duration: 1.3).repeatForever()){
                                        scaleNextButton.toggle()
                                    }
                                }
                            
                        }
                    }
                    .animation(.easeInOut(duration: tappedCorrectAnswer ?  2.7 : 0).delay(tappedCorrectAnswer ? 2.7 : 0), value: tappedCorrectAnswer)
                    Spacer()
                    Spacer()
                    
                }.foregroundStyle(.white)
                
                
            }.frame(width: geo.size.width, height: geo.size.height)
            
        }
        .ignoresSafeArea()
        .onAppear{
            animateViewsIn = true
            //playbackGroundMusic()
        }
        
    }
    // Function to play background music
    private func playbackGroundMusic() {
        let songs = ["let-the-mystery-unfold","deep-in-the-dell","spellcraft","hiding-place-in-the-forest"]
        let randomMusic = Int.random(in: 0...3)
        let sound = Bundle.main.path(forResource: songs[randomMusic], ofType: "mp3")
        backgroundMusicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        backgroundMusicPlayer.volume = 0.1
        backgroundMusicPlayer.numberOfLoops = -1 // Loop the audio indefinitely
        backgroundMusicPlayer.play() // Start playing the audio
    }
    private func playflipSound(){
        let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3")
        sfxAudioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxAudioPlayer.play()
    }
    private func playCorrectAnswerSound(){
        let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3")
        sfxAudioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxAudioPlayer.play()
    }
    private func playWrongAnswerSound(){
        let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3")
        sfxAudioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxAudioPlayer.play()
    }
    //feedback haptic
    private func giveWrongFeedback(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

}

#Preview {
    VStack {
        GamePlayView()
    }
}
