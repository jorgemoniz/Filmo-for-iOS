//
//  FilmDetailViewController.swift
//  Filmo
//
//  Created by jorgemoniz on 20/5/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import UIKit
import Kingfisher

class FilmDetailViewController: UIViewController {
    
    //MARK: - Variables locales
    var movie : MovieModel?
    let dataProvider = LocalCoreDataService()
    
    //MARK: - IBOutlets
    @IBOutlet weak var myFilmImage: UIImageView!
    @IBOutlet weak var myFilmTitle: UILabel!
    @IBOutlet weak var myFilmDirector: UILabel!
    @IBOutlet weak var myFilmCategory: UILabel!
    @IBOutlet weak var myInterestedBTN: UIButton!
    @IBOutlet weak var myFilmDescription: UITextView!
    
    //MARK: - IBActions
    @IBAction func favoriteFilmACTION(_ sender: Any) {
        if let movieData = movie {
        dataProvider.markUnMarkFavorite(movieData)
        configuredFavoriteBTN()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // setData
        if let movieData = movie {
            // image
            if let imageData = movieData.image {
                myFilmImage.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!))
            }
            // title
            myFilmTitle.text = movieData.title
            self.title = movieData.title
            // summary
            myFilmDescription.text = movieData.summary
            // category
            myFilmCategory.text = movieData.category
            // director
            myFilmDirector.text = movieData.director
            
            configuredFavoriteBTN()
        }
    }

    //MARK: - UTILS
    func configuredFavoriteBTN() {
        if let movieData = movie {
            if dataProvider.isFavorite(movieData) {
                myInterestedBTN.setBackgroundImage(#imageLiteral(resourceName: "btn-on"), for: .normal)
                myInterestedBTN.setTitle("Wanna see it!", for: .normal)
            } else {
                myInterestedBTN.setBackgroundImage(#imageLiteral(resourceName: "btn-off"), for: .normal)
                myInterestedBTN.setTitle("Not interested!", for: .normal)
            }
        }
    }
}
