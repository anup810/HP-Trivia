//
//  SettingsView.swift
//  HP Trivia
//
//  Created by Anup Saud on 2024-08-16.
//

import SwiftUI



struct SettingsView: View {
    @Environment(\.dismiss) private var dimiss
    @EnvironmentObject private var store : Store
    var body: some View {
        ZStack{
            InfoBackgroundImage()
            VStack{
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                ScrollView{
                    LazyVGrid(columns:[GridItem(),GridItem()]){
                        ForEach(0..<7){i in
                            if store.books[i] == .active || (store.books[i] == .locked && store.purchasedIDs.contains("hp\(i+1)")){
                                ZStack(alignment:.bottomTrailing) {
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundStyle(.green)
                                        .shadow(radius: 1)
                                        .padding(3)
                                }
                                .task{
                                    store.books[i] = .active
                                }
                                .onTapGesture {
                                    store.books[i] = .inactive
                   
                                }
                            }
                            else if store.books[i] == .inactive{
                                ZStack(alignment:.bottomTrailing){
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.33))
                                    Image(systemName: "circle")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundStyle(.green.opacity(0.5))
                                        .shadow(radius: 1)
                                        .padding(3)
                                    
                                }
                                .onTapGesture {
                                    store.books[i] = .active
                                }
                            }
                            else{
                                ZStack{
                                    Image(.hp3)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.6))
                                    
                                    Image(systemName: "lock.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .shadow(color: .white.opacity(0.75), radius: 3)
                                }
                                .onTapGesture {
                                    let products = store.products[i-3]
                                    Task{
                                        await store.purchase(products)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                Button("Done"){
                    dimiss()
                }
                .doneButton()
            }
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(Store())
}
