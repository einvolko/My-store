//
//  BasketView.swift
//  My store
//
//  Created by Михаил Супрун on 1/27/25.
//

import SwiftUI
import ParseCore
import Network

struct CartView: View {
    let monitor = NWPathMonitor()
    @ObservedObject var cart: Cart
    @State private var isPresented: Bool = false
    @State private var alertMessage: String = ""
    @State private var isConnected : Bool?
    private static let itemSize: CGFloat = UIScreen.main.bounds.size.width - 10
    private static let itemSpacing: CGFloat = 10.0
    private let columns = [GridItem(.fixed(itemSize), spacing: itemSpacing)]
    var body: some View {
        
            LazyVGrid(columns: columns, content: {
                ForEach(Array(cart.items.keys), id: \.self){
                    CartViewContainer(cart: cart, pfObject: $0)
                }.onDelete { indexSet in
                    cart.items.removeValue(forKey: Array(cart.items.keys)[indexSet.first!])
                }
            })
        Spacer()
            Button("Send order") {
                if isConnected ?? true {
                    if ParseManager().checkAuthenticationStatus(){
                        ParseManager().sendOrderToServer(orderString: cart.getOrderString(), userAddress: (PFUser.current()?["address"] as? String ?? "") + "/" + (PFUser.current()?["number"] as? String ?? "") + "/" + (PFUser.current()?["name"] as? String ?? ""), completion: {success, error in
                            if success {
                                alertMessage = "Order sent successfully!"
                                isPresented = success
                            }
                            if error != nil {
                                alertMessage = error?.localizedDescription ?? "Unknown error"
                                isPresented = true
                            }
                        })
                        cart.items.removeAll()
                    } else {
                        alertMessage = "Please, authorize yourself!"
                        isPresented = true}
                } else {
                    alertMessage = "Check network connection"
                    isPresented = true
                }
            }.onAppear(){
                startMonitoring()
            }
            .onDisappear(){
                stopMonitoring()
            }
            
            .disabled(cart.items.isEmpty)
            .font(.headline)
            //                .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 44)
            //                .background(Color.blue)
            .cornerRadius(10)
            .padding()
            Divider()
            Text("Total price: \(cart.getTotalPrice())")
                .font(.headline)
                .padding()
       
        .alert( alertMessage, isPresented: $isPresented) {
            Button("Ok", role: .cancel){ }
        }
    }
    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                isConnected = path.status == .satisfied
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    private func stopMonitoring() {
        monitor.cancel()
    }
}
