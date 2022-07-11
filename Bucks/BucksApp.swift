//
//  BucksApp.swift
//  Bucks
//
//  Created by Abhirath Sujith on 10/07/22.
//

import SwiftUI

@main
struct BucksApp: App {
    @StateObject var transactionListVM = TransactionListViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListVM)
        }
    }
}
