//
//  UrpayCardsViewController.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 29/09/2024.
//

import UIKit
import Combine
import PassKit

class UrpayCardsViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    @IBOutlet weak var balanceLabel: CurrencyLabel!
    @IBOutlet weak var balanceButton: UIButton!
    @IBOutlet weak var appleWalletButton: UIControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var viewModel = UrpayCardsViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ViewModel already initialized
    }
    
    override func setupUI() {
        super.setupUI()
        applyTheme()
        configureScrollView()
        configureCollectionView()
        configureTableView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        bindBalance()
        bindCards()
        bindOptions()
        bindError()
        bindLoading()
    }
    
    // MARK: - UI Configuration
    
    private func applyTheme() {
        // Apply the current theme to UI elements
        let theme = ThemeManager.shared.config
        ThemeManager.shared.applyTheme(to: self)
        navigationItem.title = theme.navigationTitle
        // Apply theme to other UI elements as needed
    }
    
    private func configureScrollView() {
        if #available(iOS 17.4, *) {
            scrollView.bouncesVertically = false
        } else {
            scrollView.bounces = false
        }
    }
    
    private func configureCollectionView() {
        cardsCollectionView.dataSource = self
        cardsCollectionView.delegate = self
        let bundle = Bundle(for: UrpayCardsViewController.self)
        cardsCollectionView.register(
            UINib(nibName: CardCell.className, bundle: bundle),
            forCellWithReuseIdentifier: CardCell.className
        )
        
        let layout = AdaptiveCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(
            width: view.frame.width * 0.85,
            height: cardsCollectionView.frame.height - 8
        )
        cardsCollectionView.collectionViewLayout = layout
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let bundle = Bundle(for: UrpayCardsViewController.self)
        tableView.register(
            UINib(nibName: OptionCell.className, bundle: bundle),
            forCellReuseIdentifier: OptionCell.className
        )
    }
    
    // MARK: - ViewModel Binding
    
    private func bindBalance() {
        viewModel.$balanceDisplay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balanceDisplay in
                if self?.viewModel.isBalanceHidden == true {
                    self?.balanceLabel.text = "*******"
                    self?.balanceButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
                } else {
                    self?.balanceLabel.updateAmount(self?.viewModel.balance ?? 0.0, currency: "SAR")
                    self?.balanceButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindCards() {
        viewModel.$cards
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.cardsCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func bindOptions() {
        viewModel.$options
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
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
    
    private func bindPaymentStatus() {
        viewModel.$lastPaymentWasSuccessful
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                guard let self = self else { return }
                if success {
                    showAlert(title: "Payment Successful", message: "Your payment was processed successfully.")
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction func viewBalance(_ sender: UIButton) {
        viewModel.toggleBalanceVisibility()
    }
    
    @IBAction func addAppleWallet(_ sender: UIControl) {
        let amount = NSDecimalNumber(string: "10.00") // Replace with the actual amount
        viewModel.payWithApplePay(amount: amount, from: self)
//        if let selectedCard = viewModel.selectedCard {
//            viewModel.addToAppleWallet(card: selectedCard, from: self)
//        } else {
//            handleError(NSError(domain: "NoSelectedCardError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No card selected. Please select a card to add to Apple Wallet."]))
//        }
    }
    
    @IBAction func payWithApplePay(_ sender: UIButton) {
        let amount = NSDecimalNumber(string: "10.00") // Replace with the actual amount
        viewModel.payWithApplePay(amount: amount, from: self)
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension UrpayCardsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.className, for: indexPath) as! CardCell
        let card = viewModel.cards[indexPath.row]
        cell.configure(with: card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedCard = viewModel.cards[indexPath.row]
        // Optionally, perform any action when a card is selected
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateSelectedCard()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateSelectedCard()
        }
    }
    
    private func updateSelectedCard() {
        let visibleRect = CGRect(origin: cardsCollectionView.contentOffset, size: cardsCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let indexPath = cardsCollectionView.indexPathForItem(at: visiblePoint) {
            viewModel.selectedCard = viewModel.cards[indexPath.row]
        }
    }
}

// MARK: - UITableView DataSource & Delegate

extension UrpayCardsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.className, for: indexPath) as! OptionCell
        let option = viewModel.options[indexPath.row]
        cell.configure(with: option)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        handleOptionSelection(option)
    }
    
    private func handleOptionSelection(_ option: OptionModel) {
        switch option.type {
        case .addMoney:
            // Implement add money functionality
            print("Add Money selected")
        case .cardInformation:
            // Implement card information functionality
            print("Card Information selected")
        case .cardSettings:
            // Implement card settings functionality
            print("Card Settings selected")
        case .qrCodeCashWithdrawal:
            // Implement QR code cash withdrawal functionality
            print("QR Code Cash Withdrawal selected")
        case .cardBenefits:
            // Implement card benefits functionality
            print("Card Benefits selected")
        }
    }
}
