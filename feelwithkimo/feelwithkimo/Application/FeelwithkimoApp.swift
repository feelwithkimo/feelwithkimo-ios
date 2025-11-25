//
//  feelwithkimoApp.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 13/10/25.
//

import SwiftUI

@main
struct FeelwithkimoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            EntryView()
                .dynamicTypeSize(.xSmall ... .large)
        }
    }
}
