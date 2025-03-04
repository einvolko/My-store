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
    
    @Published var fetchedObjectsArray: [PFObject] = []
    @Published var filteredObjectsArray: [PFObject] = []
    @Published var categoryArray: [String] = []
    
    func getCategoryArray(){
        parseManager.fetchObjectArray(className: parseManager.classNameKey) { objectsArray in
            guard let objectsArray = objectsArray else {return}
            self.categoryArray = objectsArray.compactMap({ $0[self.parseManager.classNameKey] as? String })
        }
    }
    func refreshData(category: String){
        fetchedObjectsArray.removeAll()
        for key in categoryArray {
            parseManager.fetchObjectArray(className: key) { objectsArray in
                if let objectsArray {
                    for object in objectsArray{
                        self.fetchedObjectsArray.append(object)
                        self.filterItems(category: category)
                    }
                }
            }
        }
    }
    func filterItems(category: String){
        filteredObjectsArray.removeAll()
        if category == "All"{ filteredObjectsArray = fetchedObjectsArray} else {
            filteredObjectsArray = fetchedObjectsArray.compactMap { ($0.parseClassName == category) ? $0 : nil}
        }
    }
}
