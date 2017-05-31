//
//  API_UTILS.swift
//  Filmo
//
//  Created by jorgemoniz on 19/5/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import Foundation
import UIKit

let CONSTANTES = Constantes()

struct Constantes {
    let COLORES_BASE = Colores()
    let USER_DEFAULT = CustomUserDefault()
    let PARSE_DATA = ParseData()
}

struct Colores {
    let COLOR_GRIS_TAB_NAV_BAR = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    let COLOR_ROJO_GENERAL = #colorLiteral(red: 0.5019607843, green: 0, blue: 0, alpha: 1)
    let BLANCO_TEXTO_NAV = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}

struct ParseData {
    let NOMBRE_TABLA_IMAGEN = "ImageProfile"
    let IMAGE_URL = "imageFile"
    let USERNAME_PARSE = "username"
}

struct CustomUserDefault {
    let VISTA_GALERIA_INICIAL = "vistaGaleriaInicial"
}
