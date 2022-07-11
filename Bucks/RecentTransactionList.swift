//
//  RecentTransactionList.swift
//  Bucks
//
//  Created by Abhirath Sujith on 11/07/22.
//

import SwiftUI

struct RecentTransactionList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    var body: some View {
        VStack {
            HStack {
                
                Text("Recent Transactions")
                    .bold()
                
                Spacer()
                
                NavigationLink {
                    TransactionList()
                    
                } label: {
                    HStack(spacing: 4) {
                        Text("See All")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(Color.text)
                    
                }
            }
            .padding(.top)
            
            ForEach(Array(transactionListVM.transactions.prefix(5).enumerated()), id: \.element) { index, transition in
                TransactionRow(transaction: transition)
                
                
                Divider()
                    .opacity(index == 4 ? 0 : 1)
            }
            
            
            
        }
        .padding()
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .shadow(color: Color.primary.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct RecentTransactionList_Previews: PreviewProvider {
    
    static let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    } ()
    static var previews: some View {
        Group {
            RecentTransactionList()
            RecentTransactionList()
                .preferredColorScheme(.dark)
        }
        .environmentObject(transactionListVM)
    }
}
