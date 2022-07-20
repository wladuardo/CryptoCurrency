//
//  CryptosListTableViewController.swift
//  CryptoCurrency
//
//  Created by Владислав Ковальский on 29.06.2022.
//

import UIKit

class CryptosListTableViewController: UIViewController {
    
    private lazy var homeVc = HomeViewController()
    
    private var viewModels = [CryptoTableViewCellModel]()
    
    private var searchedViewModels = [CryptoTableViewCellModel]()
    
    private lazy var isSearching = false
    
    private let favoriteCryptosDataService = FavoriteCryptosDataService()
    
    static private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        formatter.formatterBehavior = .default
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 5
        return formatter
    }()
    
    private lazy var currencyTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CryptosListTableViewCell.self, forCellReuseIdentifier: CryptosListTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 20
        tableView.rowHeight = 90
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        return tableView
    }()
    
    private lazy var cryptosListLabel: UILabel = {
        let cryptosListLabel = UILabel()
        cryptosListLabel.text = "Список валют"
        cryptosListLabel.textColor = .white
        cryptosListLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        cryptosListLabel.translatesAutoresizingMaskIntoConstraints = false
        return cryptosListLabel
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Введите название или тикер"
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
        searchBar.isTranslucent = true
        searchBar.searchTextField.textColor = .white
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCryptoData()
        setupCryptosListLabel()
        setupCurrencyTableView()
        setupSearchBar()
        customizeView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    private func setupCryptosListLabel() {
        view.addSubview(cryptosListLabel)
        NSLayoutConstraint.activate([
            cryptosListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cryptosListLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        ])
    }
    
    private func customizeView() {
        view.backgroundColor = .black
    }
    
    private func setupSearchBar() {
        currencyTableView.tableHeaderView = searchBar
        
    }
    
    private func setupCurrencyTableView() {
        view.addSubview(currencyTableView)
        NSLayoutConstraint.activate([
            currencyTableView.topAnchor.constraint(equalTo: cryptosListLabel.bottomAnchor, constant: 16),
            currencyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currencyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currencyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func getCryptoData() {
            APICaller.shared.getAllCryptoData { result in
                switch result {
                case .success(let models):
                    self.viewModels = models.compactMap({ model in

                        let price = model.price_usd ?? 0
                        let formatter = CryptosListTableViewController.numberFormatter
                        let priceString = formatter.string(from: NSNumber(value: price))
                        let iconUrl = URL(string: APICaller.shared.icons.filter({ icon in
                            icon.asset_id == model.asset_id
                        }).first?.url ?? "")

                        return CryptoTableViewCellModel.init(
                            name: model.name ?? "N/A",
                            symbol: model.asset_id,
                            price: priceString ?? "N/A",
                            iconUrl: iconUrl
                        )
                    })
                    DispatchQueue.main.async {
                        self.currencyTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}

extension CryptosListTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch isSearching {
        case false:
            return viewModels.count
        case true:
            return searchedViewModels.count
            
        }
    }
}

extension CryptosListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptosListTableViewCell.identifier, for: indexPath) as? CryptosListTableViewCell else {
            fatalError()
        }
        
        switch isSearching {
        case false:
            cell.configureCellStackView(with: viewModels[indexPath.row])
            cell.configureCrytoImageView(with: viewModels[indexPath.row])
                                         
        case true:
            cell.configureCellStackView(with: searchedViewModels[indexPath.row])
            cell.configureCrytoImageView(with: searchedViewModels[indexPath.row])
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .medium)
        let imageIcon = UIImage(systemName: "star.fill", withConfiguration: configuration)?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        let addAction = UIContextualAction(style: .normal, title: nil) { [self] (action, view, completionHandler) in
            switch isSearching {
            case false:
                favoriteCryptosDataService.update(coin: viewModels[indexPath.row])
            case true:
                favoriteCryptosDataService.update(coin: searchedViewModels[indexPath.row])
            }
            completionHandler(true)
        }
        addAction.image = imageIcon
        addAction.backgroundColor = .black
        return UISwipeActionsConfiguration(actions: [addAction])
    }
    
}

extension CryptosListTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedViewModels = viewModels.filter { $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.symbol.lowercased().prefix(searchText.count) == searchText.lowercased() }
        isSearching = true
        currencyTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        currencyTableView.reloadData()
    }
}

extension CryptosListTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

