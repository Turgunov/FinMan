//
//  FMIncomeListView.swift
//  FinMan (iOS)
//
//  Created by Karthick Selvaraj on 09/04/21.
//

import Foundation
import SwiftUI

struct FMIncomeListView: View {
    
    @StateObject var viewModel = FMIncomeListViewModel()
    @StateObject var accountViewModel = FMAccountListViewModel()
    
    @State var shouldPresentAddIncomeView: Bool = false
    @State var shouldPresentAddAccountView: Bool = false
    @State var shouldPresentAddExpenseView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                FMAccountListView(viewModel: accountViewModel)
                    .frame(height: 150, alignment: .center)
                    .padding()
                List {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .frame(height: 100, alignment: .center)
                        .overlay(
                            VStack {
                                Text("Total Income")
                                    .foregroundColor(.secondary)
                                Text("\(viewModel.totalIncome(), specifier: "%0.2f")")
                                    .font(.largeTitle)
                                    .foregroundColor(.primary)
                                    .bold()
                            }
                        )
                        .redacted(reason: viewModel.isFetching ? .placeholder : [])
                    ForEach(viewModel.incomeRowViewModel, id: \.id) { incomeRowViewModel in
                        NavigationLink(
                            destination: FMIncomeDetail(incomeRowViewModel: incomeRowViewModel),
                            label: { FMIncomeRow(incomeRowViewModel: incomeRowViewModel) }
                        )
                    }
                    .onDelete { (indexSet) in
                        if let index = indexSet.first {
                            viewModel.incomeRowViewModel[index].delete()
                        }
                    }
                }
                .frame(minWidth: 250)
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Income")
            .toolbar(content: {
                Menu {
                    Button(action: {
                        shouldPresentAddAccountView.toggle()
                    }, label: {
                        Label("Add Account", systemImage: "person.badge.plus")
                    })
                    .sheet(isPresented: $shouldPresentAddAccountView, content: {
                        FMAddAccountView(shouldPresentAddAccountView: $shouldPresentAddAccountView, viewModel: accountViewModel)
                    })
                    Button(action: {
                        shouldPresentAddIncomeView.toggle()
                    }, label: {
                        Label("Add Income", systemImage: "bag.badge.plus")
                    })
                    Button(action: {
                        shouldPresentAddExpenseView.toggle()
                    }, label: {
                        Label("Add Expense", systemImage: "cart.badge.minus")
                    })
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                }
            })
            .sheet(isPresented: $shouldPresentAddIncomeView, content: {
                FMAddIncomeview(viewModel: viewModel, shouldPresentAddIncomeView: $shouldPresentAddIncomeView)
            })
        }
    }
    
}

struct FMIncomeListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = FMIncomeListViewModel()
        let rowViewModel = FMIncomeRowViewModel(income: FMIncome.sampleData.first!)
        viewModel.incomeRowViewModel = [rowViewModel]
        return FMIncomeListView(viewModel: viewModel, shouldPresentAddIncomeView: false)
    }
    
}

