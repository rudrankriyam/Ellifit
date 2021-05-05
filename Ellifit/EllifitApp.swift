//
//  EllifitApp.swift
//  Ellifit
//
//  Created by Rudrank Riyam on 02/05/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct EllifitApp: App {
    @StateObject var viewModel = AuthenticationViewModel()
    
    init() {
        setupAuthentication()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

extension EllifitApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
}
