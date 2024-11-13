////
////  MessagesViewController.swift
////  pixelparadeiMessage
////
////  Created by Chethan Jayaram on 03/10/24.
////

import UIKit
import Messages
import CoreData



struct Sticker {
    var id: String
    var stickerPackId: String
    var filename: String
    var position: String
}



class MessagesViewController: MSMessagesAppViewController, StickerPackViewControllerDelegate {
    func didSelectSticker(filename: String) {
        print("selected")
    }
    
    
    
    
    @IBOutlet var fakeTabBar: UICollectionView!
    @IBOutlet private var fakeTabBarBackgroundView: UIView!
    
    @IBOutlet private var arrowLeft: UIButton!
    @IBOutlet private var arrowRight: UIButton!
    
    
    
    @IBOutlet private var scrollRightWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var scrollLeftWidthConstraint: NSLayoutConstraint!
    
    
    weak var containerTabBarController: BaseTabBarController!
    
    var totalStickers = Array<Array<Dictionary<String,Any>>>()
    
    enum TabBarItemType {
        case shop
        case sticker
    }
    
    typealias TabBarItem = (type: TabBarItemType, pack: Array<Dictionary<String,Any>>?)
    
    var tabBarItems: [TabBarItem] = [TabBarItem(type: .shop, pack: nil)]
    var selectedIndex: Int = 1
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
        loadUi()
        
        reloadTabBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabBarController = segue.destination as? BaseTabBarController {
            containerTabBarController = tabBarController
        }
    }
    
    
    func  loadUi() {
        fakeTabBar.delegate = self
        fakeTabBar.dataSource = self
        fakeTabBar.register(UINib(nibName: "TabBarItemCell", bundle: nil),
                            forCellWithReuseIdentifier: "TabBarItemCell")
    }
    
    
    func reloadTabBar() {
            var controllers = containerTabBarController.viewControllers ?? []
            controllers.removeAll()
            self.tabBarItems = [TabBarItem(type: .shop, pack: nil)]
        for i in 0..<totalStickers.count {
                let indexPath = IndexPath(item: i, section: 0)
                let pack = totalStickers[i]
                self.tabBarItems.append(TabBarItem(type: .sticker, pack: pack))
            }
            self.tabBarItems.forEach { (tuple) in
                switch tuple.type {
                case .shop:
                    break
                default:
                    if let stikersViewController =  UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "StickerPackViewController") as? StickerPackViewController {
                        stikersViewController.pack = tuple.pack 
                        stikersViewController.delegate = self
                        controllers.append(stikersViewController)
                    }
                }
            }
            self.fakeTabBar.reloadData()
            self.containerTabBarController.viewControllers = controllers
            self.containerTabBarController.selectedIndex = self.selectedIndex - 1
            

   
    }
    
 
    
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
    func retrieveData() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SaveStickers")
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                
                
                if let value = result.value(forKey: "id") as? String {
                    print("Retrieved value: \(value)")
                }
                if let data = result.value(forKey: "totalStickers") as? String {
                    
                    if let Stringdata = data.data(using: .utf8) {
                        do {
                            // Decode JSON into an array of Person objects
                            if let jsonArray = try JSONSerialization.jsonObject(with: Stringdata, options: []) as? [[String: Any]] {
                                print(jsonArray)
                                if let value = result.value(forKey: "id") as? String {
                                    self.totalStickers.append(jsonArray)
                                }
                                
                            }
                            
                        } catch {
                            print("Failed to decode JSON: \(error)")
                        }
                    }
                    print("Retrieved value: \(data)")
                }
            }
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
        
        print(totalStickers)
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dismisses the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
}

