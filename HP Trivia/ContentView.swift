//
//  ContentView.swift
//  HP Trivia
//
//  Created by Anup Saud on 2024-08-15.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var scalePlayButton = false
    @State private var moveBackgroundImage = false
    var body: some View {
        GeometryReader{geo in
            ZStack{
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.top,3)
                //Animation to move background image
                    .offset(x: moveBackgroundImage ? geo.size.width/1.1 : -geo.size.width/1.1)
                    .onAppear{
                        withAnimation(.linear(duration: 60).repeatForever()) {
                            moveBackgroundImage.toggle()
                        }
                    }
                
                VStack{
                    VStack{
                        Image(systemName: "bolt.fill")
                            .font(.largeTitle)
                            .imageScale(.large)
                        Text("HP")
                            .font(.custom(Constants.hpFont, size: 70))
                            .padding(.bottom, -50)
                        Text("Trivia")
                            .font(.custom(Constants.hpFont, size: 60))
                    }
                    .padding(.top,70)
                    Spacer()
                    VStack{
                        Text("Recent Scores")
                            .font(.title2)
                        Text("33")
                        Text("27")
                        Text("15")
                    }
                    .font(.title3)
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                    .background(.black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    Spacer()
                    HStack{
                        Spacer()
                        Button{
                            // show instruction screen
                        }label: {
                            Image(systemName: "info.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                                .shadow(radius: 5)
                        }
                        Spacer()
                        Button{
                            //start a new game
                        }label: {
                            Text("Play")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                                .padding(.vertical,7)
                                .padding(.horizontal,50)
                                .background(.brown)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                                .shadow(radius: 5)
                        }
                        //Animation for play button
                        .scaleEffect(scalePlayButton ? 1.2 : 1)
                        .onAppear{
                            withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                scalePlayButton.toggle()
                            }
                        }
                        

                        Spacer()
                        Button{
                            //show setting screem
                        }label: {
                            Image(systemName: "gearshape.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                                .shadow(radius: 5)
                        }
                        Spacer()
                    }.frame(width: geo.size.width)
                    Spacer()
                }
            }
            .frame(width:geo.size.width , height: geo.size.height)
            
            
        }
        .ignoresSafeArea()
//        .onAppear{
//            playAudio()
//        }

    }
    private func playAudio(){
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
        
    }
}

#Preview {
    ContentView()
}
