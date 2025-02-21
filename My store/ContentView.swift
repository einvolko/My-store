//
//  ContentView.swift
//  My store
//
//  Created by Михаил Супрун on 1/14/25.
//

import SwiftUI
import ParseCore

struct ContentView: View {
    @State  var parseManager = ParseManager()
    var globalStorage: BasketStorage
    @State private var categoryArray: [String] = []
    @State private var fetchedObjectsArray: [PFObject] = []
    @State private var filteredObjectsArray: [PFObject] = []
    @State private var selectedCategory: String = "All"
    private static let itemSize: CGFloat = UIScreen.main.bounds.size.width / 2 - 10
    private static let itemSpacing: CGFloat = 10.0
    private let columns = [GridItem(.fixed(itemSize), spacing: itemSpacing),
                           GridItem(.fixed(itemSize), spacing: itemSpacing)]
   
    var body: some View {
        NavigationStack{
            Spacer()
            HStack(alignment: .center) {
                Text("All categories")
                    .padding()
                    .font(.headline)
                    .background(selectedCategory == "All" ? Color.green : Color.gray)
                    .clipShape(Capsule())
                    .onTapGesture {
                        selectedCategory = "All"
                        filterItems(category: selectedCategory)
                    }
                ForEach(categoryArray, id: \.self){ category in
                    Text(category)
                        .padding()
                        .font(.headline)
                        .background(selectedCategory == category ? Color.green : Color.gray)
                        .clipShape(Capsule())
                        .onTapGesture {
                            selectedCategory = category
                            filterItems(category: category)
                        }
                }
            }
            Spacer()
            ScrollView{
                LazyVGrid(columns: columns,alignment: .center, spacing: Self.itemSpacing) {
                    ForEach (filteredObjectsArray, id: \.self) { object in
                        NavigationLink {
                            ItemDetailView(pfObject: object)
                        } label: {
                            ItemViewContainer(basketStorage: globalStorage ,pfObject: object)
                        }
                    }
                }
            }
        }
        .refreshable {
            refreshData(category: selectedCategory)
        }
        .task() {                      // How to make task perform once when app start?
            getCategoryArray()
        }
        .onChange(of: categoryArray) { _, _ in
            refreshData(category: selectedCategory)
        }
    }
    func getCategoryArray(){
        parseManager.fetchObjectArray(className: parseManager.classNameKey) { objectsArray in
            guard let objectsArray = objectsArray else {return}
            categoryArray = objectsArray.compactMap({ $0[parseManager.classNameKey] as? String })
        }
    }
    func refreshData(category: String){
        fetchedObjectsArray.removeAll()
        for key in categoryArray {
            parseManager.fetchObjectArray(className: key) { objectsArray in
                if let objectsArray {
                    for object in objectsArray{
                        fetchedObjectsArray.append(object)
                        filterItems(category: category)
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
