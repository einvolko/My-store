//
//  BasketViewContainer.swift
//  My store
//
//  Created by Михаил Супрун on 1/27/25.
//


import SwiftUI
import ParseCore


struct CartViewContainer: View{
    @ObservedObject var cart: Cart
    var pfObject: PFObject
    @State private var image: UIImage?
    @State private var name: String?
    @State private var price: Int?
    private let itemSize: CGFloat = UIScreen.main.bounds.size.width / 4 - 10
    private let cornerRadius: CGFloat = 15.0
    var body: some View {
        HStack{
            if let image{
                Image(uiImage:image)
                    .resizable()
                    .frame(width: itemSize,
                           height: itemSize,
                           alignment: .center)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(cornerRadius)
            }
            Spacer()
            VStack{
                if let name{Text(name)}
                if let price{Text(price.description)}
            }
            Spacer()
            
            Button(action: {
                cart.removeFromCart(pfObject)
                cart.saveCartToUserDefaults()
            },label: {Image(systemName: "minus.circle")})
           
            Text(cart.items[pfObject]?.description ?? "")
                .padding()
     
            Button(action: {
                cart.addToCart(pfObject)
                cart.saveCartToUserDefaults()
            },label: {Image(systemName: "plus.circle")})
            .padding(.trailing)
        }
        .task {
            let imageFile = pfObject[ParseManager().imageKey] as? PFFileObject
            if let imageFile {
                ParseManager().downloadImage(file: imageFile) { uiimage in
                    image = uiimage
                }
            }
            name = pfObject[ParseManager().nameKey] as? String
            price = pfObject[ParseManager().costKey] as? Int
        }
    }
}
