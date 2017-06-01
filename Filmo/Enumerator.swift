//
//  Enumerator.swift
//  Filmo
//
//  Created by jorgemoniz on 1/6/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import Foundation

enum CustomError : Error {
    case campoVacio
    case emailInvalido
    case usuarioExistente
    case ingresoUsuarioError
}

extension CustomError : CustomStringConvertible {
    var description : String {
        switch self {
        case .campoVacio:
            return "Ingrese todos los campos"
        case .emailInvalido:
            return "Correo invalido"
        case .usuarioExistente:
            return "Ya existe ese usuario."
        case .ingresoUsuarioError:
            return "Datos incorrectos."
        }
    }
}
