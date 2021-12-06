//
//  HomeViewModel.swift
//  TMDB
//
//  Created by Azis Ramdhan on 01/11/21.
//

import Foundation
import CoreData

class HomeViewModel {

    var onSuccessGetMovies: (() -> Void)?
    var onErrorGetMovies: ((String) -> Void)?

    init(service: HomeDataService) {
        self.service = service
    }

    private let service: HomeDataService?
    var movies: [Movie] = []
    var favorites: [NSManagedObject] = []
    var page = 1
    var canLoadMore = true

    func reset() {
        page = 1
        canLoadMore = true
        movies = []
    }

    func getMovies(_ type: RequestType) {
        if canLoadMore {
            service?.getPopularMoviesWith(type, page: page, successHandler: { data in
                if data.isEmpty {
                    self.canLoadMore = false
                }

                if self.page == 1 {
                    self.movies = data
                } else {
                    self.movies.append(contentsOf: data)
                }
                self.page += 1
                self.onSuccessGetMovies?()
            }, errorHandler: { error in
                self.onErrorGetMovies?(error)
            })
        }
    }

    func getFavoriteMovies(_ appDelegate: AppDelegate) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        do {
            let results = try managedContext.fetch(fetchRequest)
            favorites = results
            self.onSuccessGetMovies?()
        } catch let error as NSError {
            self.onErrorGetMovies?("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}
