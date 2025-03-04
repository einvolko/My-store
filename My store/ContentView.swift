//
//  ContentView.swift
//  My store
//
//  Created by Михаил Супрун on 1/14/25.
//

import SwiftUI
import ParseCore

struct ContentView: View {
    @ObservedObject var dataModel: DataModel
    @ObservedObject var basketStorage: BasketStorage
   
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
                        dataModel.filterItems(category: selectedCategory)
                    }
                ForEach(dataModel.categoryArray, id: \.self){ category in
                    Text(category)
                        .padding()
                        .font(.headline)
                        .background(selectedCategory == category ? Color.green : Color.gray)
                        .clipShape(Capsule())
                        .onTapGesture {
                            selectedCategory = category
                            dataModel.filterItems(category: category)
                        }
                }
            }
            Spacer()
            ScrollView{
                LazyVGrid(columns: columns,alignment: .center, spacing: Self.itemSpacing) {
                    ForEach (dataModel.filteredObjectsArray, id: \.self) { object in
                        NavigationLink {
                            ItemDetailView(basketStorage: basketStorage, pfObject: object)
                        } label: {
                            ItemViewContainer(basketStorage: basketStorage ,pfObject: object)
                        }
                    }
                }
            }
        }
        .refreshable {
            dataModel.refreshData(category: selectedCategory)
        }
        .task() {                      // How to make task perform once when app start?
            dataModel.getCategoryArray()
        }
        .onChange(of: dataModel.categoryArray) { _, _ in
            dataModel.refreshData(category: selectedCategory)
        }
    }
}
