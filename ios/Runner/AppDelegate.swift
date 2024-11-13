import UIKit
import CoreData
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "saveStickersOffline")
        
        if let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.pixel-parade.container") {
            let storeURL = appGroupURL.appendingPathComponent("saveStickersOffline.sqlite")
            let storeDescription = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [storeDescription]
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.pixelParade.sharedStorage", binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "saveData" {
               
                guard let args = call.arguments as? [String: Any],
                      
                        let key = args["key"] as? String,
                      let value = args["value"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                    return
                }
                
//                self.handleJsonData(value)
                 self.saveData(key: key, value: value)
                result(nil)
            } 
//            else if call.method == "retrieveData" {
//                guard let args = call.arguments as? [String: Any],
//                      let key = args["key"] as? String else {
//                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
//                    return
//                }
//                result(self.retrieveFromCoreData(key: key))}
            else {
                result(FlutterMethodNotImplemented)
            }
        }
        
//        getRecordsCount()
        
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
//    
//    private func retrieveFromCoreData(key: String) -> String? {
//        let context = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SaveStickers")
//        //                fetchRequest.predicate = NSPredicate(format: "key == %@", key)
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            if let result = results.first, let value = result.value(forKey: "id") as? String {
//                return value
//            }
//            print(results)
//            
//        } catch {
//            print("Failed to fetch data: \(error.localizedDescription)")
//        }
//        return nil
//        
//    }
    
//    func getRecordsCount() {
//        let context = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SaveStickers")
//        do {
//            let count = try context.count(for: fetchRequest)
//            print(count)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    
    func saveData(key: String, value: String) {
        
        let context = persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<SaveStickers> = SaveStickers.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", key)
        
        
        do {
            let existingStickers = try context.fetch(fetchRequest)
            
            
            if (existingStickers.isEmpty) {
                
                let person = SaveStickers(context: context)
                person.id = key
                person.totalStickers = value
                
                do {
                    try context.save()
                    print("All data saved successfully!")
                } catch {
                    print("Failed to save data: \(error)")
                }
            } else {
                print("data exists in local")
            }
        } catch {
            
        }
        
     
    }
    
    
    
    
    // Function to handle the JSON data
    func handleJsonData(_ jsonString: String) {
        // Convert JSON string to Data
        if let data = jsonString.data(using: .utf8) {
            do {
                // Decode JSON into an array of Person objects
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    print(jsonArray)
                    
                }
                                
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
    }
    
    
}

