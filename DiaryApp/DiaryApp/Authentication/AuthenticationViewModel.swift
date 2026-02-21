//
//  AuthenticationViewModel.swift
//  DiaryApp
//
//  Created by Adrian Gutierrez on 30/01/26.
//

import Foundation
import LocalAuthentication

class AuthenticationViewModel {
    
    var onAuthSuccess: (() -> Void)?
    var onAuthError: ((String) -> Void)?
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Desbloquea tu Diario"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authError in
                DispatchQueue.main.async {
                    if success {
                        self?.onAuthSuccess?()
                    } else {
                        self?.onAuthError?(authError?.localizedDescription ?? "Error desconocido")
                    }
                }
            }
        } else {
            debugPrint("Biometría no disponible, accediendo...")
            onAuthSuccess?()
        }
    }
}
