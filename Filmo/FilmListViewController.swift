//
//  FilmListViewController.swift
//  Filmo
//
//  Created by jorgemoniz on 20/5/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import UIKit
import Kingfisher

class FilmListViewController: UIViewController {
    
    //MARK: - Variables locales
    var movies = [MovieModel]()
    var collectionViewPadding : CGFloat = 0
    var customRefreshControl = UIRefreshControl()
    var dataProvider = LocalCoreDataService()
    var tapGR : UITapGestureRecognizer!
    
    //MARK: - IBOutlets
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var mySearchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        customRefreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        myCollectionView.refreshControl?.tintColor = CONSTANTES.COLORES_BASE.COLOR_ROJO_GENERAL
        
        tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        loadData()
        
        setupPadding()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        mySearchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UTILS
    func loadData() {
        // Código de CoreData
        dataProvider.topMovie({ (localResult) in
            if let moviesData = localResult {
                self.movies = moviesData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            } else {
                print("No hay registros en CoreData")
            }
            
        }) { (remoteResult) in
            if let moviesData = remoteResult {
                self.movies = moviesData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                    self.customRefreshControl.endRefreshing()
                }
            } else {
                print("No se han encontrado registros en CoreData")
            }
        }
    }
    
    func hideKeyboard() {
        mySearchBar.resignFirstResponder()
        self.view.removeGestureRecognizer(tapGR)
    }
} //TODO: - FIN DE LA CLASE

extension FilmListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    func setupPadding() {
        // Divide el resto sobrante de las celdas para ajustar el padding
        let anchoPantalla = self.view.frame.width
        collectionViewPadding = (anchoPantalla - (3 * 113))/4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewPadding, left: collectionViewPadding, bottom: collectionViewPadding, right: collectionViewPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewPadding
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let customCell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilmCustomCell
        
        let movieData = movies[indexPath.row]
        
        // Método de creación de celda
        configuredCell(customCell, withMovie: movieData)
        
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 113, height: 170)
    }
    
    /***** SEARCHBAR *****/
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.addGestureRecognizer(tapGR)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            // Se ejecuta la búsqueda
            loadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            // Invoca CoreData
            dataProvider.searchMovies(term, remoteHandler: { (resultMovies) in
                if let moviesData = resultMovies {
                    self.movies = moviesData
                    // Hilo principal
                    DispatchQueue.main.async {
                        self.myCollectionView.reloadData()
                        searchBar.resignFirstResponder()
                    }
                }
            })
        }
    }
    
    //MARK: - UTILS - DELEGATE
    func configuredCell(_ cell : FilmCustomCell, withMovie movie: MovieModel) {
        if let imageData = movie.image {
            cell.myImageMovie.kf.setImage(with: ImageResource(downloadURL: URL(string : imageData)!),
                                          placeholder: #imageLiteral(resourceName: "img-loading"),
                                          options: nil,
                                          progressBlock: nil,
                                          completionHandler: nil)
        }
    }
}
