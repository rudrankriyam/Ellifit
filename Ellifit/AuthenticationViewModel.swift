//
//  AuthenticationViewModel.swift
//  Ellifit
//
//  Created by Rudrank Riyam on 05/05/21.
//

import Foundation
import Firebase
import GoogleSignIn

class AuthenticationViewModel: NSObject, ObservableObject {
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    
    override init() {
        super.init()
    }
    
    func signIn() {
        if GIDSignIn.sharedInstance.currentUser == nil {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }

            let configuration = GIDConfiguration(clientID: clientID)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
    
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                
                Auth.auth().signIn(with: credential) { (_, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self.state = .signedIn
                    }
                }
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            
            state = .signedOut
        } catch {
            print(error.localizedDescription)
        }
    }
}
