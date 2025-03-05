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
    @ObservedObject var cart: Cart
    @State var isFirstLaunch: Bool = true
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
                ForEach(dataModel.categories, id: \.self){ category in
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
                    ForEach (dataModel.dispalayedObjects, id: \.self) { product in
                        NavigationLink {
                            ItemDetailView(cart: cart, product: product)
                        } label: {
                            ItemViewContainer(cart: cart, product: product)
                        }
                    }
                }
            }
        }
        .refreshable {
            dataModel.refreshData(category: selectedCategory)
        }
        .task() {
            if isFirstLaunch {
                dataModel.fetchAllProducts()
                isFirstLaunch.toggle()
            }
            
        }
    }
}
