//
//  TransactionListViewModel.swift
//  Bucks
//
//  Created by Abhirath Sujith on 11/07/22.
//

import Foundation
import Combine
import Collections

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]
 
final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getTransaction()
    }
    
    func getTransaction() {
        guard let url = URL(string: "https://designcode.io/data/transaction.json") else {
            print("Invaild URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{ ( data, response ) -> Data in
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink{ completion in
                switch completion {
                case .failure(let error):
                    print("Error!!!!!", error.localizedDescription)
                case .finished:
                    print("Finished fetching transaction")
                }
    
            } receiveValue: { [weak self] result in
                self?.transactions = result
               // dump(self?.transactions)
                
            }
            .store(in: &cancellables)
            
    }
    
    func groupTransactionByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
        
        let groupedTransactions = TransactionGroup(grouping: transactions) { $0.month }
            
        return groupedTransactions
    }
    
    func accumulateTransaction() -> TransactionPrefixSum {
        print("AccTrans")
        guard !transactions.isEmpty else { return [] }
        
        let today = "07/10/2022".dateParsed()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print("dateInterval", dateInterval)
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24) {
            let dailyExpenes = transactions.filter { $0.dateParsed == date && $0.isExpense }
            let dailyTotal = dailyExpenes.reduce(0) { $0 - $1.signedAmount }
            
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(), "dailyTotal:", dailyTotal, "sum:", sum)
        }
        
        return cumulativeSum
    }
}
