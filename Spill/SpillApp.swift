//
//  SpillApp.swift
//  Spill
//
//  Created by User on 2025-01-10.
//

import SwiftUI
import FirebaseCore

extension Color {
    static let baseGoogleBackgroundColor = Color(#colorLiteral(red: 0.05637089163, green: 0.4261392653, blue: 0.7405287027, alpha: 1))
    static let baseAppleBackgroundColor = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    static let baseBackgroundColor = Color(#colorLiteral(red: 0.08627451211, green: 0.08627451211, blue: 0.08627451211, alpha: 1))
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct SpillApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
