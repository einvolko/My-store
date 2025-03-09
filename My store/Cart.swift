//
//  StorageManager.swift
//  My store
//
//  Created by Михаил Супрун on 1/27/25.
//

import Foundation
import ParseCore


class Cart: ObservableObject {

    @Published var items: [PFObject: Int] = [:]
   
    var isEmpty: Bool {
        return items.isEmpty
    }
    func addToCart(_ object: PFObject){
        if let count = items[object]{
            items[object] = count + 1
        } else{
            items[object] = 1
        }
    }
    func removeFromCart(_ object: PFObject){
        if let count = items[object], count > 1 {
            items[object] = count - 1
        } else{
            items.removeValue(forKey: object)
        }
    }
    func getTotalPrice() -> Int{
        items.keys.map({$0[ParseManager().costKey] as! Int  * items[$0]!}).reduce(0, +)
    }
    func getOrderString()-> String{
        let orderString = items.keys.map({$0[ParseManager().nameKey] as! String}).joined(separator: ";")
        return orderString
    }
    
     func saveCartToUserDefaults() {
        let serializedDict = items.reduce(into: [String: Int]()) { result, pair in
            if let objectId = pair.key.objectId {
                result[objectId] = pair.value
            }
        }
        if let jsonData = try? JSONSerialization.data(withJSONObject: serializedDict, options: []) {
            UserDefaults.standard.set(jsonData, forKey: "savedItems")
        }
    }
    
    func loadCart(categories: [String]) {
        if let jsonData = UserDefaults.standard.data(forKey: "savedItems") {
            if let serializedDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Int] {
                // Восстанавливаем [PFObject: Int] из [String: Int]
                var restoredDict: [PFObject: Int] = [:]
                for (objectId, value) in serializedDict {
                    for category in categories{
                        PFQuery(className: category).getObjectInBackground(withId: objectId) { (object, error) in
                            if let object = object {
                                restoredDict[object] = value
                                self.items = restoredDict
                            }
                        }
                    }
                }
            }
        }
    }
}
