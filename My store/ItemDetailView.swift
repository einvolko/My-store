//
//  ItemDetailView.swift
//  My store
//
//  Created by Михаил Супрун on 1/26/25.
//


import SwiftUI
import ParseCore

struct ItemDetailView: View {
    var cart: Cart
    var product: PFObject
    private static let cornerRadius = 15.0
    @State private var feedbackGenerator: UIImpactFeedbackGenerator?
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
                        .font(.headline)
                        .bold()
                }
            Divider()
              
                if let description {
                    Text(description.description)
                }
            if let price {
                Text("Cost: \(price.description)" )
            }
            Spacer()
            Button("Add to basket") {
                cart.addToCart(product)
                feedbackGenerator?.impactOccurred()
            }
            .padding()
            .font(.headline)
            .foregroundColor(.white)
            .frame(minHeight: 44)
            .background(Color.blue)
            .cornerRadius(10)
            Spacer()
        }
        .padding()
        .task{
            let imageFile = product[ParseManager().imageKey] as? PFFileObject
            if let imageFile {
                ParseManager().downloadImage(file: imageFile) { uiimage in
                    image = uiimage
                }
            }
            name = product[ParseManager().nameKey] as? String
            price = product[ParseManager().costKey] as? Int
            description = product[ParseManager().descriptionKey] as? String
        }
        .onAppear{
            feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator?.prepare()
        }
    }
}

