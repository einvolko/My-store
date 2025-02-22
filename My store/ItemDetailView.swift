//
//  ItemDetailView.swift
//  My store
//
//  Created by Михаил Супрун on 1/26/25.
//


import SwiftUI
import ParseCore

struct ItemDetailView: View {
    var basketStorage: BasketStorage
    var pfObject: PFObject
    private static let cornerRadius = 15.0
    
    @State private var image: UIImage?
    @State private var name: String?
    @State private var price: Int?
    @State private var description: String?
    
    var body: some View {
        VStack{
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(Self.cornerRadius)
                    .padding()
            } else {
                Image(systemName: "text.below.photo")
            }
                if let name {
                    Text(name)
                        .bold()
                }
                if let price {
                    Text(price.description)
                }
                if let description {
                    Text(description.description)
                }
            Spacer()
            Button("Add to basket") {
                basketStorage.addToBasket(pfObject)
            }
            .buttonStyle(.bordered)
            Spacer()
        }
        .task{
            let imageFile = pfObject[ParseManager().imageKey] as? PFFileObject
            if let imageFile {
                ParseManager().downloadImage(file: imageFile) { uiimage in
                    image = uiimage
                }
            }
            name = pfObject[ParseManager().nameKey] as? String
            price = pfObject[ParseManager().costKey] as? Int
            description = pfObject[ParseManager().descriptionKey] as? String
        }
    }
}

