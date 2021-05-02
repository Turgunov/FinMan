//
//  FMAccountListViewModel.swift
//  FinMan
//
//  Created by Karthick Selvaraj on 02/05/21.
//

import Foundation
import Combine

class FMAccountListViewModel: ObservableObject {
    
    @Published var accountRepository = FMAccountRepository()
    @Published var accountRowViewModel: [FMAccountRowViewModel] = []
    @Published var isFetching: Bool = true
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        accountRepository.$accounts.map { account in
            account.map(FMAccountRowViewModel.init)
        }
        .assign(to: \.accountRowViewModel, on: self)
        .store(in: &cancellables)
        
        accountRepository.$isFetching
            .map {
                print("🔵 Current fetching status: \($0)")
                return $0
            }
            .assign(to: \.isFetching, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Custom methods
    
    func addNew(account: FMAccount) {
        accountRepository.add(account)
    }
    
}

