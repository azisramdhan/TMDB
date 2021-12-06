//
//  DetailViewModel.swift
//  TMDB
//
//  Created by Azis Ramdhan on 02/11/21.
//

import Foundation
import CoreData

class DetailViewModel {
    var onSuccessGetMovieDetail: (() -> Void)?
    var onErrorGetMovieDetail: ((String) -> Void)?

    var onSuccessGetReviews: (() -> Void)?
    var onErrorGetReviews: ((String) -> Void)?

    var onSuccessGetVideos: (() -> Void)?
    var onErrorGetVideos: ((String) -> Void)?

    init(service: DetailDataService) {
        self.service = service
    }

    private let service: DetailDataService?
    var movie: MovieDetail?
    var results: [Result] = []
    var videos: [Video] = []

    func getMovieDetail(_ id: Int) {
        service?.getMovieDetailWith(id, successHandler: { data in
            self.movie = data
            self.onSuccessGetMovieDetail?()
        }, errorHandler: { error in
            self.onErrorGetMovieDetail?(error)
        })
    }

    func getReviews(_ id: Int) {
        service?.getReviewsWith(id, successHandler: { data in
            self.results = data
            self.onSuccessGetReviews?()
        }, errorHandler: { error in
            self.onErrorGetReviews?(error)
        })
    }

    func getVideos(_ id: Int) {
        service?.getVideosWith(id, successHandler: { data in
            self.videos = data
            self.onSuccessGetVideos?()
        }, errorHandler: { error in
            self.onErrorGetVideos?(error)
        })
    }

    func addToFavorites(_ appDelegate: AppDelegate) {
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Entity", in: managedContext),
              let movie = movie else {
                  return
              }
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)

        managedObject.setValue(movie.id, forKeyPath: "id")
        managedObject.setValue(movie.posterPath, forKeyPath: "posterPath")
        managedObject.setValue(movie.title, forKeyPath: "title")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func removeFromFavorites(_ appDelegate: AppDelegate, id: Int) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        fetchRequest.fetchLimit = 1
        if let result = try? managedContext.fetch(fetchRequest), let movie = result.first as? Entity {
            managedContext.delete(movie)
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func isFavorites(_ appDelegate: AppDelegate, id: Int) -> Bool {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")

        do {
            let movies = try managedContext.fetch(fetchRequest)
            return movies.contains { managedObject in
                managedObject.value(forKey: "id") as? Int == id
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
}
