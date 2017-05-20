//
//  MovieManage+Mapping.swift
//  Filmo
//
//  Created by jorgemoniz on 20/5/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import Foundation

extension MovieManager {
    
    // Sobre cualquier objeto "manage" se podrá ejecutar el retorno de un objeto del tipo movieModel
    func mappedObject() -> MovieModel {
        return MovieModel(pId: self.id!,
                          pTitle: self.title!,
                          pOrder: Int(self.order),
                          pSummary: self.summary!,
                          pImage: self.image,
                          pCategory: self.category!,
                          pDirector: self.director!)
    }
}
