//
//  BasketView.swift
//  My store
//
//  Created by Михаил Супрун on 1/27/25.
//

import SwiftUI
import ParseCore
import Network
struct BasketView: View {
    @ObservedObject var basketStorage: BasketStorage
    @State private var isPresented: Bool = false
    @State private var alertMessage: String = ""
    @State private var isConnected : Bool?
    let monitor = NWPathMonitor()
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(basketStorage.basketArray, id: \.self){
                    BasketViewContainer(pfObject: $0)
                }.onDelete { indexSet in
                    basketStorage.basketArray.remove(atOffsets: indexSet)
                }
            }
            Button("Send order") {
                if isConnected ?? true {
                    if ParseManager().checkAuthenticationStatus(){
                        ParseManager().sendOrderToServer(orderString: basketStorage.getOrderString(), userAddress: (PFUser.current()?["address"] as? String ?? "") + "/" + (PFUser.current()?["number"] as? String ?? "") + "/" + (PFUser.current()?["name"] as? String ?? ""), completion: {success, error in
                            if success {
                                alertMessage = "Order sent successfully!"
                                isPresented = success
                            }
                            if error != nil {
                                alertMessage = error?.localizedDescription ?? "Unknown error"
                                isPresented = true
                            }
                        })
                        basketStorage.basketArray.removeAll()
                    } else {
                        alertMessage = "Please, authorize yourself!"
                        isPresented = true}
                } else {
                    alertMessage = "Check network connection"
                    isPresented = true
                }
            }.disabled(basketStorage.isEmpty)
                .font(.headline)
//                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 44)
//                .background(Color.blue)
                .cornerRadius(10)
                .padding()
            Divider()
            Text("Total price: \(basketStorage.getTotalPrice())")
                .font(.headline)
                .padding()
        }.onAppear(){
            startMonitoring()
        }
        .onDisappear(){
            stopMonitoring()
        }
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
