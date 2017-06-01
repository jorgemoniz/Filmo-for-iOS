//
//  TutorialGalleryViewController.swift
//  Filmo
//
//  Created by jorgemoniz on 1/6/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import UIKit

class TutorialGalleryViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var myScrollViewGallery: UIScrollView!
    @IBOutlet weak var myPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let anchoImagen = self.view.frame.width
        let altoImagen = self.view.frame.height
        
        for c_imagen in 0..<8 {
            let imagenes = UIImageView(image: UIImage(named: String(format: "FOTO_%d.jpg", c_imagen)))
            imagenes.frame = CGRect(x: CGFloat(c_imagen) * anchoImagen, y: 0, width: anchoImagen, height: altoImagen)
            myScrollViewGallery.addSubview(imagenes)
        }
        
        myScrollViewGallery.delegate = self
        myScrollViewGallery.contentSize = CGSize(width: 7 * anchoImagen, height: altoImagen)
        myScrollViewGallery.isPagingEnabled = true
        myPageControl.numberOfPages = 7
        myPageControl.currentPage = 0
        
        // Do any additional setup after loading the view.
    }
}

extension TutorialGalleryViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = myScrollViewGallery.contentOffset.x / myScrollViewGallery.frame.size.width
        myPageControl.currentPage = Int(page)
    }
}
