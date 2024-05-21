//
//  RealmManager.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    private var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    // MARK: - Initialization
    
    private init() {
        // Perform Realm configuration, such as setting encryption key, schema version, etc.
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // Perform data migration if needed
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: - CRUD Operations
    
    func saveObject<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .modified) // Use .modified to update existing objects
            }
        } catch {
            print("Error saving object: \(error.localizedDescription)")
        }
    }
    
    func deleteObject<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("Error deleting object: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Querying
    
    func queryObjects<T: Object>(_ objectType: T.Type) -> Results<T> {
        return realm.objects(objectType)
    }
    
    // Example of advanced query
    func fetchObjects<T: Object>(ofType objectType: T.Type, predicate: NSPredicate? = nil, sortedBy keyPath: String? = nil, ascending: Bool = true) -> Results<T> {
        var results = realm.objects(objectType)
        if let predicate = predicate {
            results = results.filter(predicate)
        }
        if let keyPath = keyPath {
            results = results.sorted(byKeyPath: keyPath, ascending: ascending)
        }
        return results
    }
    
    // MARK: - Notifications
    
    func observeRealmChanges<T: Object>(_ objectType: T.Type, completion: @escaping ([T]) -> Void) -> NotificationToken {
        let results = realm.objects(objectType)
        return results.observe { changes in
            switch changes {
            case .initial(let objects), .update(let objects, _, _, _):
                completion(Array(objects))
            case .error(let error):
                print("Realm notification error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Error Handling
    
    func handle(error: Error) {
        // Implement custom error handling logic
        print("Realm error: \(error.localizedDescription)")
    }
}
