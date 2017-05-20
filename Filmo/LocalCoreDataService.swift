//
//  LocalCoreDataService.swift
//  Filmo
//
//  Created by jorgemoniz on 20/5/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import Foundation
import CoreData

class LocalCoreDataService {
    
    // 1 -> desde local service se va a invocar a remote service
    let remoteMovieService = RemoteMovieService()
    let stack = CoreDataStack.shared
    
    func searchMovies(_ byTerm : String, remoteHandler : @escaping ([MovieModel]?) -> ()) {
        
        // 2
        remoteMovieService.searchMovie(byTerm) { (result) in
            if let movieData = result {
                var modelMovies = [MovieModel]()
                for c_movie in movieData {
                    let obj = MovieModel(pId: c_movie["id"]!,
                                         pTitle: c_movie["title"]!,
                                         pOrder: nil,
                                         pSummary: c_movie["summary"]!,
                                         pImage: c_movie["image"]!,
                                         pCategory: c_movie["category"]!,
                                         pDirector: c_movie["director"]!)
                    modelMovies.append(obj)
                }
                remoteHandler(modelMovies)
                
            } else {
                print("Error mientras se llama a los servicios de la API")
                remoteHandler(nil)
            }
        }
    }
    
    func topMovie(_ localHandler : @escaping ([MovieModel]?) -> (), remoteHandler : @escaping ([MovieModel]?) -> ()) {
        
        localHandler(queryTopMovies())
        
        remoteMovieService.getTopMovies { (result) in
            
            if let moviesData = result {
                // Proceso de Sync -> que nos marque todos los objetos como no sincronizados
                self.markAllMoviesUnsync()
                var order = 1
                for c_movieDiccionario in moviesData {
                    
                    // Consulta si tenemos la película en CoreData
                    if let movieData = self.getMovieById(c_movieDiccionario["id"]!, favorite: false) {
                        // update
                        self.updateMovie(c_movieDiccionario, movie: movieData, order: order)
                    } else {
                        // insert
                        self.insertMovie(c_movieDiccionario, order: order)
                    }
                    order += 1
                }
                // Borrar lo no sincronizado
                self.removeAllnotFavoriteMovies()
                
                remoteHandler(self.queryTopMovies())
            } else {
                print("Error mientras se lama a los servicios de la API")
                remoteHandler(nil)
            }
        }
    }
    
    func queryTopMovies() -> [MovieModel]? {
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        // Nadie empieza como favorito
        let customPredicate = NSPredicate(format: "favorite = \(false)")
        request.predicate = customPredicate
        
        do {
            let fetchMovies = try context.fetch(request)
            // Creamos un array de películas
            var movie = [MovieModel]()
            
            for c_manage in fetchMovies {
                movie.append(c_manage.mappedObject())
            }
            return movie
        } catch {
            print("Error mientras se obtienen las películas desde CoreData")
            return nil
        }
    }
    
    func markAllMoviesUnsync() {
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        
        let customPredicate = NSPredicate(format: "favorite = \(false)")
        request.predicate = customPredicate
        
        do {
            let fetchMovies = try context.fetch(request)
            for c_manage in fetchMovies {
                // Cambio de la propiedad "Sync"
                c_manage.sync = false
            }
        } catch {
            print("Error mientras se actualizan las pelícualas desde CoreData")
        }
    }
    
    func getMovieById(_ id : String, favorite : Bool) -> MovieManager? {
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "id = \(id) and favorite = \(favorite)")
        request.predicate = customPredicate
        
        do {
            let fetchmovies = try context.fetch(request)
            // Si tiene algún registro, debería retornar 1
            if fetchmovies.count > 0 {
                return fetchmovies.last
            } else {
                return nil
            }
        } catch {
            print("Error mientras se obtienen las películas desde CoreData")
            return nil
        }
    }
    
    func insertMovie(_ movieDiccionario : [String : String], order : Int) {
        let context = stack.persistentContainer.viewContext
        let movie = MovieManager(context: context)
        movie.id = movieDiccionario["id"]
        updateMovie(movieDiccionario, movie : movie, order : order)
    }
    
    func updateMovie(_ movieDiccionario : [String : String], movie : MovieManager, order : Int) {
        let context = stack.persistentContainer.viewContext
        movie.order = Int16(order)
        movie.title = movieDiccionario["title"]
        movie.summary = movieDiccionario["summary"]
        movie.category = movieDiccionario["category"]
        movie.director = movieDiccionario["director"]
        movie.image = movieDiccionario["image"]
        movie.sync = true
        
        // Actualiza CoreData
        do {
            try context.save()
        } catch {
            print("Error mientras se actualiza CoreData")
        }
    }
    
    func removeAllnotFavoriteMovies() {
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "favorite = \(false)")
        request.predicate = customPredicate
        
        do {
            let fetchMovies = try context.fetch(request)

            for c_manageMovie in fetchMovies {
                if !c_manageMovie.sync {
                    context.delete(c_manageMovie)
                }
            }
            try context.save()
        } catch {
            print("Error durante el borrado de CoreData")
        }
    }
    
    func getFavoriteMovie() -> [MovieModel]? {
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "favorite = \(true)")
        request.predicate = customPredicate
        
        do {
            let fetchMovies = try context.fetch(request)
            var movies = [MovieModel]()
            
            for c_movieData in fetchMovies {
                movies.append(c_movieData.mappedObject())
            }
            return movies
        } catch {
            print("Error mientras se obtienen los favoritos")
            return nil
        }
    }
    
    func isFavorite(_ movie : MovieModel) -> Bool {
        if let _ = getMovieById(movie.id!, favorite: true) {
            return true
        } else {
            return false
        }
    }
    
    func markUnMarkFavorite (_ movie : MovieModel) {
        // Si existe con es id, se borra
        let context = stack.persistentContainer.viewContext
        if let existe = getMovieById(movie.id!, favorite: true) {
            context.delete(existe)
        } else {
            let favorite = MovieManager(context: context)
            favorite.id = movie.id!
            favorite.title = movie.title!
            favorite.summary = movie.summary!
            favorite.category = movie.category!
            favorite.director = movie.director!
            favorite.image = movie.image!
            favorite.favorite = true
            
            do {
                try context.save()
            } catch {
                print("Error mientras se marca como favorito")
            }
        }
        // Actualizamos el Badge
        updateFavoriteBadge()
    }
    
    func updateFavoriteBadge() {
        if let totalFavorites = getFavoriteMovie()?.count {
            let customNotification = Notification.init(name: Notification.Name("updateFavoriteBadgeNotification"),
                                                       object: totalFavorites,
                                                       userInfo: nil)
            NotificationCenter.default.post(customNotification)
        }
    }
}
