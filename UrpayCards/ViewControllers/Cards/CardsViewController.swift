//
//  CardsViewController.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 29/09/2024.
//

import UIKit
import Combine
import PassKit

class CardsViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var cardsCollectionView: UICollectionView!
    @IBOutlet var balanceLabel: CurrencyLabel!
    @IBOutlet var balanceButton: UIButton!
    @IBOutlet var appleWalletButton: UIControl!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    
    private var viewModel = CardsViewModel()
    
    private var tableViewDataSource: TableViewDataSource<OptionModel, OptionCell>!
    private var tableViewDelegate: TableViewDelegate<OptionModel>!
    private var collectionViewDataSource: CollectionViewDataSource<CardModel, CardCell>!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ViewModel already initialized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let theme = ThemeManager.shared.config
        self.navigationItem.title = theme.navigationTitle
        setNavigationBarColor(UIColor.navigationBarColor2)
        //self.isLoading = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        applyTheme()
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
        bindPaymentStatus()
    }
    
    // MARK: - UI Configuration
    
    private func applyTheme() {
        // Apply the current theme to UI elements
        let theme = ThemeManager.shared.config
        ThemeManager.shared.applyTheme(to: self)
        // Apply theme to other UI elements as needed
        navigationItem.title = theme.navigationTitle
    }
    
    private func configureScrollView() {
        if #available(iOS 17.4, *) {
            scrollView.bouncesVertically = false
        } else {
            scrollView.bounces = false
        }
    }
    
    private func configureCollectionView() {
        cardsCollectionView.register(cellType: CardCell.self)
        
        let layout = AdaptiveCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(
            width: view.frame.width * 0.85,
            height: cardsCollectionView.frame.height - 8
        )
        cardsCollectionView.collectionViewLayout = layout
        
        collectionViewDataSource = CollectionViewDataSource(models: viewModel.cards) { cell, card in
            cell.configure(with: card)
        }
        cardsCollectionView.dataSource = collectionViewDataSource
        
        cardsCollectionView.delegate = self
    }
    
    private func configureTableView() {
        tableView.register(cellType: OptionCell.self)
        
        tableViewDataSource = TableViewDataSource(models: viewModel.options) { cell, option in
            cell.configure(with: option)
        }
        tableView.dataSource = tableViewDataSource
        
        tableViewDelegate = TableViewDelegate(models: viewModel.options) { [weak self] option in
            self?.handleOptionSelection(option)
        }
        
        tableView.delegate = tableViewDelegate
    }
    
    // MARK: - ViewModel Binding
    
    private func bindBalance() {
        Publishers.CombineLatest(viewModel.$balance, viewModel.$isBalanceHidden)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balance, isBalanceHidden in
                self?.balanceLabel.text = self?.viewModel.formattedBalanceDisplay
                let imageName = isBalanceHidden ? "eye.slash.fill" : "eye.fill"
                self?.balanceButton.setImage(UIImage(systemName: imageName), for: .normal)
            }
            .store(in: &cancellables)
    }
    
    private func bindCards() {
        viewModel.$cards
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cards in
                self?.collectionViewDataSource.models = cards
                self?.cardsCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func bindOptions() {
        viewModel.$options
            .receive(on: DispatchQueue.main)
            .sink { [weak self] options in
                self?.tableViewDataSource.models = options
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
                    showAlert(
                        title: NSLocalizedString("Payment Successful", comment: ""),
                        message: NSLocalizedString("Your payment was processed successfully.", comment: "")
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction func viewBalance(_ sender: UIButton) {
        viewModel.toggleBalanceVisibility()
    }
    
    @IBAction func addAppleWallet(_ sender: UIControl) {
        if let selectedCard = viewModel.selectedCard {
            viewModel.addToAppleWallet(card: selectedCard, from: self)
        } else {
            handleError(NSError(domain: "NoSelectedCardError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No card selected. Please select a card to add to Apple Wallet."]))
        }
    }
}

// MARK: - UICollectionView Delegate

extension CardsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.updateAuthToken()
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

// MARK: - UITableView handleOptionSelection

extension CardsViewController {
    
    private func handleOptionSelection(_ option: OptionModel) {
        switch option.type {
        case .addMoney:
            showPaymentMethods()
        case .cardInformation:
            showCardInformation()
        case .cardSettings:
            showCardSettings()
        case .qrCodeCashWithdrawal:
            showQRCodeScanner()
        case .cardBenefits:
            showCardBenefits()
        }
    }
    
    func showPaymentMethods() {
        if let paymentMethodsVC = instantiateViewController(storyboardName: "URCards", viewControllerClass: PaymentMethodsVC.self) {
            // If PaymentMethodsVC has a completion handler property
            paymentMethodsVC.completionHandler = { [weak self] method in
                guard let self else { return }
                // Your code to handle the selected payment method
                switch method.type {
                case .bankCard:
                    print("bank card")
                case .accountDetails:
                    print("account details")
                case .cashDeposit:
                    print("cash deposit")
                case .applePay:
                    self.showAmount()
                }
            }
            // Present the view controller with custom presentation
            presentViewController(paymentMethodsVC, withCustomPresentation: true)
        }
    }
    
    func showAmount() {
        if let amountViewController = instantiateViewController(storyboardName: "URCards", viewControllerClass: AmountViewController.self) {
            amountViewController.completionHandler = { [weak self] amount in
                guard let self else { return }
                let amount = NSDecimalNumber(string: amount)
                self.viewModel.payWithApplePay(amount: amount, from: self)
            }
            self.show(amountViewController, sender: nil)
        }
    }
    
    func showCardInformation() {
        if let cardInformationVC = instantiateViewController(storyboardName: "URCards", viewControllerClass: CardInformationVC.self) {
            self.show(cardInformationVC, sender: nil)
        }
    }
    
    func showCardSettings() {
        if let cardSettingsVC = instantiateViewController(storyboardName: "URCards", viewControllerClass: CardSettingsVC.self) {
            self.show(cardSettingsVC, sender: nil)
        }
    }
    
    func showQRCodeScanner() {
        let qrScannerVC = QRCodeScannerVC { [weak self] qrCode in
            guard let self else { return }
            // Handle the scanned QR code
            print("Scanned QR Code: \(qrCode)")
            self.dismiss(animated: true, completion: nil)
        }
        qrScannerVC.modalPresentationStyle = .fullScreen
        present(qrScannerVC, animated: true)
    }
    
    func showCardBenefits() {
        if let cardBenefitsVC = instantiateViewController(storyboardName: "URCards", viewControllerClass: CardBenefitsVC.self) {
            self.show(cardBenefitsVC, sender: nil)
        }
    }
}
