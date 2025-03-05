//
//  DataModel.swift
//  My store
//
//  Created by Михаил Супрун on 3/4/25.
//

import SwiftUI
import ParseCore


class DataModel: ObservableObject {
    
    var parseManager = ParseManager()
    
    @Published var fetchedObjects: [PFObject] = []
    @Published var dispalayedObjects: [PFObject] = []
    @Published var categories: [String] = []
    
    func fetchAllProducts(){
        parseManager.fetchObjectArray(className: parseManager.classNameKey) { categoriesArray in
            if let categoriesArray {
                self.categories = categoriesArray.compactMap({ $0[self.parseManager.classNameKey] as? String })
                for categoty in self.categories{
                    self.parseManager.fetchObjectArray(className: categoty) { objectsArray in
                        if let objectsArray{
                            self.fetchedObjects.append(contentsOf: objectsArray)
                            self.dispalayedObjects = self.fetchedObjects
                        }
                    }
                }
            }
        }
    }
    func refreshData(category: String){
        dispalayedObjects.removeAll()
        if category == "All"{ dispalayedObjects = fetchedObjects} else {
            parseManager.fetchObjectArray(className: category) { objectsArray in
                if let objectsArray {
                    self.dispalayedObjects.append(contentsOf: objectsArray)
                }
            }
        }
    }
    func filterItems(category: String){
        dispalayedObjects.removeAll()
        if category == "All"{ dispalayedObjects = fetchedObjects} else {
            dispalayedObjects = fetchedObjects.compactMap { ($0.parseClassName == category) ? $0 : nil}
        }
    }
}
