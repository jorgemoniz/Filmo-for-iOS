//
//  SignIn.swift
//  Filmo
//
//  Created by jorgemoniz on 1/6/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import Foundation
import Parse

class APISingIn: NSObject {
    
    var username : String?
    var password : String?
    
    init(pUsername : String, pPassword : String) {
        self.username = pUsername
        self.password = pPassword
    }
    
    func singInUser() throws {
        guard camposVacios() else {
            throw CustomError.campoVacio
        }
        guard validarDatosUsuario() else {
            throw CustomError.ingresoUsuarioError
        }
    }
    
    func camposVacios() -> Bool {
        if !(username?.isEmpty)! && !(password?.isEmpty)! {
            return true
        } else {
            return false
        }
    }
    
    func validarDatosUsuario() -> Bool {
        do {
            try PFUser.logIn(withUsername: username!, password: password!)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        if PFUser.current() != nil {
            return true
        } else {
            return false
        }
    }
}
