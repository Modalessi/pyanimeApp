//
//  PersistenceManager.swift
//  pyanime
//
//  Created by Mohammed Alessi on 02/06/2022.
//

import Foundation
import CoreData

class PersistenceManager {
    
    let persistentContainer: NSPersistentContainer
    
    
    static let dataController: PersistenceManager = PersistenceManager(model: "pyanime")
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(model: String) {
        persistentContainer = NSPersistentContainer(name: model)
    }
    
    func load(completion: (()->Void)? = nil) {
        persistentContainer.loadPersistentStores { (description, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func getFavourites(completed: (Result<[Favourite], PAError>)->Void) {
        var favourites: [Favourite] = []
        
        let fetchRequest: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        let sortDecriptore: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDecriptore]
        
        do {
            favourites = try PersistenceManager.dataController.viewContext.fetch(fetchRequest)
            completed(.success(favourites))
        } catch {
            completed(.failure(.extractingData))
        }
        
    }
    
    
    func addToFavourites(show: Show, completed: ((PAError?)->Void)?) {
        let favourtie = Favourite(context: PersistenceManager.dataController.viewContext)
        favourtie.name = show.name
        favourtie.imageUrl = show.imageUrl
        favourtie.link = show.link
        favourtie.imageData = FaselhdAPI.shared.cache.object(forKey: show.link as NSString)?.jpegData(compressionQuality: 1.0)
        
        do {
            try PersistenceManager.dataController.viewContext.save()
            completed?(nil)
        } catch {
            completed?(.unkownError)
        }
    }
    
    
    func removeFromFavourites(_ favourite: Favourite, completed: ((PAError?)->Void)?) {
        PersistenceManager.dataController.viewContext.delete(favourite)
        do {
            try PersistenceManager.dataController.viewContext.save()
            completed?(nil)
        } catch {
            completed?(.unkownError)
        }
    }
    
    
    func getFavourite(for show: SearchResult)-> Favourite? {
        let fetchRequest: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        let sortDecriptore: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDecriptore]
        
        do {
            let favourites = try PersistenceManager.dataController.viewContext.fetch(fetchRequest)
            for favourite in favourites {
                if favourite.link == show.link { return favourite }
            }
            return nil
        } catch {
            return nil
        }
    }
    
}
