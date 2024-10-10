//
//  CardBenefitsViewModel.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 10/10/2024.
//

import Combine

class CardBenefitsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var cardBenefits: [CardBenefitModel] = []
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        fetchCardBenefits()
    }
    
    // MARK: - Methods
    
    func fetchCardBenefits() {
        // Fetch or generate CardBenefits
        cardBenefits = CardBenefitModel.mockData()
    }
    
}
