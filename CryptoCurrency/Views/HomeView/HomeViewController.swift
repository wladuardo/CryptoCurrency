//
//  HomeViewController.swift
//  CryptoCurrency
//
//  Created by Владислав Ковальский on 09.06.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var searchedViewModels: [CryptoTableViewCellModel] = []
    
    private var isSearching = false
    
    private var favoriteViewModels = [CryptoTableViewCellModel]()
    
    private let favoriteCryptosDataService = FavoriteCryptosDataService()
    
    private lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.layer.cornerRadius = 20
        headerView.layer.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.15, alpha: 1).cgColor
        return headerView
    }()
    
    static private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        formatter.formatterBehavior = .default
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 5
        return formatter
    }()
    
    private lazy var headerStackView: UIStackView = {
        let headerStackView = UIStackView()
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        return headerStackView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Привет"
        welcomeLabel.font = UIFont(name: "Arial", size: 14)
        welcomeLabel.textColor = .white
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        return welcomeLabel
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Владислав"
        nameLabel.font = UIFont(name: "Arial", size: 18)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var nameLabelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "investor")
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(red: 0.725, green: 0.757, blue: 0.851, alpha: 1).cgColor
        return imageView
    }()
    
    private lazy var topCryptosView: UIView = {
        let favoriteChartView = UIView()
        favoriteChartView.translatesAutoresizingMaskIntoConstraints = false
        favoriteChartView.layer.cornerRadius = 20
        favoriteChartView.layer.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.15, alpha: 1).cgColor
        return favoriteChartView
    }()
    
    private lazy var watchListLabel: UILabel = {
        let watchListLabel = UILabel()
        watchListLabel.text = "Отслеживаемые"
        watchListLabel.textColor = .white
        watchListLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        watchListLabel.translatesAutoresizingMaskIntoConstraints = false
        return watchListLabel
    }()
    
    private lazy var favoriteCurrencyTableView: UITableView = {
        let favoriteCurrencyTableView = UITableView()
        favoriteCurrencyTableView.register(HomeViewTableViewCell.self, forCellReuseIdentifier: HomeViewTableViewCell.identifier)
        favoriteCurrencyTableView.translatesAutoresizingMaskIntoConstraints = false
        favoriteCurrencyTableView.backgroundColor = .clear
        favoriteCurrencyTableView.layer.cornerRadius = 20
        favoriteCurrencyTableView.rowHeight = 90
        favoriteCurrencyTableView.dataSource = self
        favoriteCurrencyTableView.delegate = self
        favoriteCurrencyTableView.allowsSelection = true
        return favoriteCurrencyTableView
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
    
    private lazy var topCryptosLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Лидеры роста"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        updateViewModels()
        customizeHomeView()
        setupHeaderView()
        setupHeaderStackView()
        setupTopCryprosView()
        setupWatchListLabel()
        setupFavoriteCurrencyTableView()
        setupSearchController()
        
    }
    
    private func updateViewModels() {
        favoriteCryptosDataService.getCryptos()
        
        OperationQueue.main.addOperation { [self] in
            let savedEntities = favoriteCryptosDataService.savedEntities
            switch savedEntities.isEmpty {
            case true:
                print("Nothing to present")
            case false:
                favoriteViewModels = savedEntities.compactMap({ model in
                    let name = model.name ?? ""
                    let symbol  = model.symbol ?? ""
                    let price = model.price ?? ""
                    let iconUrl = model.iconUrl
                    
                    var readyCell: CryptoTableViewCellModel?
                    
                    switch name == "" {
                    case true:
                        return nil
                    case false:
                        readyCell = .init(name: name, symbol: symbol, price: price, iconUrl: iconUrl)
                    }
                    return readyCell
                })
            }
            favoriteCryptosDataService.getCryptos()
            favoriteCurrencyTableView.reloadData()
        }

    }
    
    @objc private func loadList(notification: NSNotification){
        updateViewModels()
    }
    
    private func setupSearchController() {
        favoriteCurrencyTableView.tableHeaderView = searchBar
    }
    
    private func customizeHomeView() {
        view.backgroundColor = .black
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    private func setupHeaderStackView() {
        headerView.addSubview(headerStackView)
        [welcomeLabel, nameLabelImageView, nameLabel].forEach({ headerStackView.addSubview($0) })
        NSLayoutConstraint.activate([
            headerStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 32),
            headerStackView.topAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -196),
            headerStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 94)
        ])
        NSLayoutConstraint.activate([
            nameLabelImageView.leadingAnchor.constraint(equalTo: headerStackView.leadingAnchor),
            nameLabelImageView.topAnchor.constraint(equalTo: headerStackView.topAnchor),
            nameLabelImageView.widthAnchor.constraint(equalToConstant: 42),
            nameLabelImageView.heightAnchor.constraint(equalToConstant: 42)
        ])
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: nameLabelImageView.trailingAnchor, constant: 8),
            welcomeLabel.topAnchor.constraint(equalTo: headerStackView.topAnchor)
            
        ])
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: nameLabelImageView.trailingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 4)
        ])
    }
    
    private func setupTopCryprosView() {
        view.addSubview(topCryptosView)
        topCryptosView.addSubview(topCryptosLabel)
        NSLayoutConstraint.activate([
            topCryptosView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            topCryptosView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topCryptosView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            topCryptosView.heightAnchor.constraint(equalToConstant: 165)
        ])
        
        NSLayoutConstraint.activate([
            topCryptosLabel.leadingAnchor.constraint(equalTo: topCryptosView.leadingAnchor, constant: 15),
            topCryptosLabel.topAnchor.constraint(equalTo: topCryptosView.topAnchor, constant: 10)
        ])
    }
    
    private func setupWatchListLabel() {
        view.addSubview(watchListLabel)
        NSLayoutConstraint.activate([
            watchListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            watchListLabel.topAnchor.constraint(equalTo: topCryptosView.bottomAnchor, constant: 19)
        ])
    }
    
    private func setupFavoriteCurrencyTableView() {
        view.addSubview(favoriteCurrencyTableView)
        NSLayoutConstraint.activate([
            favoriteCurrencyTableView.topAnchor.constraint(equalTo: watchListLabel.bottomAnchor, constant: 12),
            favoriteCurrencyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoriteCurrencyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteCurrencyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch isSearching {
        case false:
            return favoriteViewModels.count
        case true:
            return searchedViewModels.count
            
        }
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewTableViewCell.identifier, for: indexPath) as? HomeViewTableViewCell else {
            fatalError()
        }
        switch isSearching {
        case false:
            cell.configureCellStackView(with: favoriteViewModels[indexPath.row])
            cell.configureCrytoImageView(with: favoriteViewModels[indexPath.row])
        case true:
            cell.configureCellStackView(with: searchedViewModels[indexPath.row])
            cell.configureCrytoImageView(with: searchedViewModels[indexPath.row])
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .medium)
        let imageIcon = UIImage(systemName: "trash.fill", withConfiguration: configuration)?.withTintColor(.red, renderingMode: .alwaysOriginal)
        let deleteAction = UIContextualAction(style: .normal, title: nil) { [self] (action, view, completionHandler) in
            switch isSearching {
            case false:
                let operation = OperationQueue.main
                operation.addOperation { [self] in
                    favoriteCryptosDataService.delete(coin: favoriteViewModels[indexPath.row])
                }
                operation.addOperation { [self] in
                    favoriteViewModels.remove(at: indexPath.row)
                    favoriteCurrencyTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            case true:
                let operation = OperationQueue.main
                operation.addOperation { [self] in
                    favoriteCryptosDataService.delete(coin: searchedViewModels[indexPath.row])
                    favoriteViewModels.removeAll(where: { $0.name == searchedViewModels[indexPath.row].name})
                }
                operation.addOperation { [self] in
                    searchedViewModels.remove(at: indexPath.row)
                    favoriteCurrencyTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            completionHandler(true)
        }
        deleteAction.image = imageIcon
        deleteAction.backgroundColor = .black
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedViewModels = favoriteViewModels.filter { $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.symbol.lowercased().prefix(searchText.count) == searchText.lowercased() }
        isSearching = true
        favoriteCurrencyTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        favoriteCurrencyTableView.reloadData()
    }
}

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

