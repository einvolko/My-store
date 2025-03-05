//
//  ItemViewContainer.swift
//  My store
//
//  Created by Михаил Супрун on 1/27/25.
//

import SwiftUI
import ParseCore

struct ItemViewContainer: View {
    var cart: Cart
    var product: PFObject
    @State private var image: UIImage?
    @State private var name: String?
    @State private var price: Int?
    private let itemSize: CGFloat = UIScreen.main.bounds.size.width / 2 - 10
    private let cornerRadius: CGFloat = 15.0
    var body: some View{
        ZStack(alignment: .bottom) {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: itemSize,
                           height: itemSize,
                           alignment: .center)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(cornerRadius)
            } else {
                Image(systemName: "text.below.photo")
            }
            HStack(alignment: .bottom){
                Spacer()
                if let name {
                    Text(name)
                        .frame(minHeight: 50)
                        .bold()
                }
                if let price {
                    Text(price.description)
                        .frame(minHeight: 50)
                }
                Spacer()
                Button(action: {
                    cart.addToBasket(product)
                },label: {Image(systemName: "basket.fill")})
                .frame(minHeight: 50)
                Spacer()
            }
            .foregroundColor(.primary)
            .background(Color.primary
                .colorInvert()
                .opacity(0.75))
        }
        .task{
            let imageFile = product[ParseManager().imageKey] as? PFFileObject
            if let imageFile {
                ParseManager().downloadImage(file: imageFile) { uiimage in
                    image = uiimage
                }
            }
            name = product[ParseManager().nameKey] as? String
            price = product[ParseManager().costKey] as? Int
        }
    }
}
