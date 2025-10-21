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
            }
        }
    }
}

#Preview {
    ContentView()
}
