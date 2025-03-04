//
//  StorageManager.swift
//  My store
//
//  Created by Михаил Супрун on 1/27/25.
//

import Foundation
import ParseCore

class BasketStorage: ObservableObject {
    @Published var basketArray: [PFObject] = []
     var isEmpty: Bool {
        return basketArray.isEmpty
    }
    func addToBasket(_ object: PFObject){
        self.basketArray.append(object)
    }
    func getTotalPrice() -> Int{
        basketArray.map({$0[ParseManager().costKey] as! Int}).reduce(0, +)
    }
    func getOrderString()-> String{
       let orderString = basketArray.map({$0[ParseManager().nameKey] as! String}).joined(separator: ";")
        return orderString
    }
}
   
