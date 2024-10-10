//
//  CardBenefitsVC.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 10/10/2024.
//

import UIKit

class CardBenefitsVC: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    
    private var viewModel = CardBenefitsViewModel()
    
    private var tableViewDataSource: TableViewDataSource<CardBenefitModel, CardBenefitCell>!
    private var tableViewDelegate: TableViewDelegate<CardBenefitModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        applyTheme()
        navigationItem.title = "Card Benefits"
        configureTableView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        bindBenefits()
        bindError()
        bindLoading()
    }
    
    // MARK: - UI Configuration
    
    private func applyTheme() {
        ThemeManager.shared.applyTheme(to: self)
    }
    
    private func configureTableView() {
        tableView.register(cellType: CardBenefitCell.self)
        
        tableViewDataSource = TableViewDataSource(models: viewModel.cardBenefits) { cell, benefit in
            cell.configure(with: benefit)
        }
        tableView.dataSource = tableViewDataSource
        
        tableViewDelegate = TableViewDelegate(models: viewModel.cardBenefits) { [weak self] benefit in
            guard let self else { return }
            print(benefit, self.className)
        }
        
        tableView.delegate = tableViewDelegate
    }
    
    // MARK: - ViewModel Binding
    
    private func bindBenefits() {
        viewModel.$cardBenefits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] benefits in
                self?.tableViewDataSource.models = benefits
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func bindError() {
        viewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleError(error)
            }
            .store(in: &cancellables)
    }
    
    private func bindLoading() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
            }
            .store(in: &cancellables)
    }
}
