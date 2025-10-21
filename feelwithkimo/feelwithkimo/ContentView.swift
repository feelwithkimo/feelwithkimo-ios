//
//  ContentView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 13/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HomeView()
                EntryView()
                // Navigation button to BreathingView
                NavigationLink(destination: BreathingView()) {
                    HStack {
                        Text("MizuNoKoyku-JyuIchiNoKata-Nagi")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
        }
}

#Preview {
    ContentView()
}
