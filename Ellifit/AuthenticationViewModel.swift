//
//  AuthenticationViewModel.swift
//  Ellifit
//
//  Created by Rudrank Riyam on 05/05/21.
//

import Foundation
import Firebase
import GoogleSignIn

class AuthenticationViewModel: ObservableObject {
  enum SignInState {
    case signedIn
    case signedOut
  }
  
  @Published var state: SignInState = .signedOut
  
  func signIn() {
    // 1
    if GIDSignIn.sharedInstance.hasPreviousSignIn() {
      GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
        authenticateUser(for: user, with: error)
      }
    } else {
      // 2
//      guard let clientID = FirebaseApp.app()?.options.clientID else { return }
      
      // 3
//      let configuration = GIDConfiguration(clientID: clientID)
      
      // 4
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
      guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
      
      // 5
//      GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
//        authenticateUser(for: user, with: error)
//      }
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] signInResult, error in
//            self.authenticateUser(for: user, with: error)
            self.authenticateUser(for: signInResult?.user, with: error)
        }
    }
  }
  
  private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
    // 1
    if let error = error {
      print(error.localizedDescription)
      return
    }
    
    // 2
//    guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
//
//    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
    
      guard let idToken = user!.idToken?.tokenString else { return  };
      let accessToken = user!.accessToken.tokenString;
       let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

    // 3
    Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
      if let error = error {
        print(error.localizedDescription)
      } else {
        state = .signedIn
      }
    }
  }
  
  func signOut() {
    // 1
    GIDSignIn.sharedInstance.signOut()
    
    do {
      // 2
      try Auth.auth().signOut()
      
      state = .signedOut
    } catch {
      print(error.localizedDescription)
    }
  }
}
