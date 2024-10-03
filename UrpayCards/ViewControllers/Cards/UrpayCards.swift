//
//  UrpayCards.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 29/09/2024.
//

import UIKit
import Combine

public class UrpayCards: BaseViewController {
    
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            if #available(iOS 17.4, *) {
                scrollView.bouncesVertically = false
            } else {
                scrollView.bounces = false
            }
        }
    }
    
    @IBOutlet var cardsCollectionView: UICollectionView!
    @IBOutlet var balanceLabel: CurrencyLabel!
    @IBOutlet var balanceButton: UIButton!
    @IBOutlet var appleWalletButton: UIControl!
    @IBOutlet var tableView: UITableView!
    
    // ViewModel instance
    private var viewModel: UrpayCardsViewModel!
    
    public static func configureTheme(_ config: ThemeConfig) {
        ThemeManager.shared.updateTheme(config: config)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize ViewModel
        viewModel = UrpayCardsViewModel()
        
        // Apply the current theme to this view controller
        ThemeManager.shared.applyTheme(to: self)
        
        // Configure UI elements
        configureCollectionView()
        configureTableView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$balanceDisplay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balanceDisplay in
                if self?.viewModel.isBalanceHidden == true {
                    self?.balanceLabel.text = "*******"
                } else {
                    self?.balanceLabel.updateAmount(self?.viewModel.balance ?? 0.0, currency: "SAR")
                }
            }
            .store(in: &cancellables)
        
        viewModel.$cards
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.cardsCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$options
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func viewBalance(_ sender: UIButton) {
        viewModel.toggleBalanceVisibility()
    }
    
    @IBAction func addAppleWallet(_ sender: AMControlView) {
        viewModel.addToAppleWallet(from: self)
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension UrpayCards: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func configureCollectionView() {
        cardsCollectionView.dataSource = self
        cardsCollectionView.delegate = self
        let bundle = Bundle(for: UrpayCards.self)
        cardsCollectionView.register(UINib(nibName: CardCell.className, bundle: bundle), forCellWithReuseIdentifier: CardCell.className)
        
        let layout = AdaptiveCollectionViewLayout()
        let cardwidth: CGFloat = cardsCollectionView.frame.width * 0.85
        let cardheight: CGFloat = cardsCollectionView.frame.height - 8
        layout.itemSize = CGSize(width: cardwidth, height: cardheight)
        cardsCollectionView.collectionViewLayout = layout
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cards.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.className, for: indexPath) as! CardCell
        let card = viewModel.cards[indexPath.row]
        // Configure the cell with card data
        cell.configure(with: card)
        return cell
    }
}

// MARK: - UITableView DataSource & Delegate

extension UrpayCards: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let bundle = Bundle(for: UrpayCards.self)
        tableView.register(UINib(nibName: OptionCell.className, bundle: bundle), forCellReuseIdentifier: OptionCell.className)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.className, for: indexPath) as! OptionCell
        let option = viewModel.options[indexPath.row]
        cell.configure(with: option)
        return cell
    }
}
