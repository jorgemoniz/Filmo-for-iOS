//
//  API_HELPERS.swift
//  Filmo
//
//  Created by jorgemoniz on 1/6/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import Foundation
import SwiftyJSON
import MessageUI

let customPrefs = UserDefaults.standard

func muestraVC(_ titleData: String, messageData : String) -> UIAlertController {
    let alertVC = UIAlertController(title: titleData, message: messageData, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    return alertVC
}

func configuredMailComposeVC() -> MFMailComposeViewController {
    let mailCompose = MFMailComposeViewController()
    mailCompose.setToRecipients([""])
    mailCompose.setSubject("Ayuda con la app de iOS")
    mailCompose.setMessageBody("Escriba aquí su mensaje", isHTML: false)
    return mailCompose
}

public func dimeString(_ json: JSON, nombre : String) -> String {
    if let stringResult = json[nombre].string {
        return stringResult
    } else {
        return ""
    }
}
