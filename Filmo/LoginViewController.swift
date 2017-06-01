//
//  LoginViewController.swift
//  Filmo
//
//  Created by jorgemoniz on 1/6/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class LoginViewController: UIViewController {

    //MARK: - Variables locales
    var player : AVPlayer!
    
    //MARK: - IBOutlets
    @IBOutlet weak var myUsernameTF: UITextField!
    @IBOutlet weak var myPasswordTF: UITextField!
    
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func doLoginACTION(_ sender: Any) {
        let signIn = APISingIn(pUsername: myUsernameTF.text!, pPassword: myPasswordTF.text!)
        do {
            try signIn.singInUser()
            self.performSegue(withIdentifier: "jumpToViewControllerFromLogin", sender: self)
        } catch let error {
            present(muestraVC("Lo sentimos", messageData: "\(error.localizedDescription)"), animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        muestraVideo()
        myActivityIndicator.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Utils
    func muestraVideo() {
        //Videos
        let videoPath = Bundle.main.path(forResource: "Nike_iOS", ofType: "mp4")
        player = AVPlayer(url: URL(fileURLWithPath: videoPath!))
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        let playerlayer = AVPlayerLayer(player: player)
        playerlayer.frame = self.view.frame
        playerlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.insertSublayer(playerlayer, at: 0)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd),
                                               name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        player.seek(to: kCMTimeZero)
        player.play()
    }
    
    func playerItemDidReachEnd() {
        player.seek(to: kCMTimeZero)
    }
}
