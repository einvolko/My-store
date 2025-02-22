//
//  BasketView.swift
//  My store
//
//  Created by Михаил Супрун on 1/27/25.
//

import SwiftUI
import ParseCore
 
struct BasketView: View {
    @ObservedObject var basketStorage: BasketStorage
    @State private var isPresented: Bool = false
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(basketStorage.basketArray, id: \.self){
                    BasketViewContainer(pfObject: $0)
                }.onDelete { IndexSet in
                    removeItems(at: IndexSet)
                }
            }
            Button("Send order") {
                if ParseManager().checkAuthenticationStatus(){
                    ParseManager().sendOrderToServer(orderString: basketStorage.getOrderString(), userAddress: (PFUser.current()?["address"] as? String ?? "") + "/" + (PFUser.current()?["number"] as? String ?? "") + "/" + (PFUser.current()?["name"] as? String ?? ""))
                    basketStorage.basketArray.removeAll()
                } else {isPresented = true}
            }.disabled(basketStorage.basketArray.isEmpty)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
            Divider()
            Text("Total price: \(basketStorage.getTotalPrice())")
                .font(.headline)
                .padding()
        }.alert("Please, authentification", isPresented: $isPresented) {
            Button("Ok", role: .cancel){ }
            }
    }
    func removeItems(at offsets: IndexSet) {
        basketStorage.basketArray.remove(atOffsets: offsets)
    }
   
}
