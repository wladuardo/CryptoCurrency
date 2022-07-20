//
//  HomeViewTableViewCell.swift
//  CryptoCurrency
//
//  Created by Владислав Ковальский on 07.07.2022.
//

import UIKit

class HomeViewTableViewCell: UITableViewCell {
    
    static let identifier = "HomeViewCustomCell"
    
    private lazy var cryptoLabel: UILabel = {
        let cryptoLabel = UILabel()
        cryptoLabel.textColor = .white
        cryptoLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        cryptoLabel.translatesAutoresizingMaskIntoConstraints = false
        return cryptoLabel
    }()
    
    private lazy var cryptoSubLabel: UILabel = {
        let cryptoSubLabel = UILabel()
        cryptoSubLabel.textColor = .white
        cryptoSubLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        cryptoSubLabel.translatesAutoresizingMaskIntoConstraints = false
        return cryptoSubLabel
    }()
    
    private lazy var cryptoPriceLabel: UILabel = {
        let cryptoPriceLabel = UILabel()
        cryptoPriceLabel.textColor = .white
        cryptoPriceLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        cryptoPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        return cryptoPriceLabel
    }()
    
    private lazy var cryptoImageView: UIImageView = {
        let cryptoImage = UIImageView()
        cryptoImage.contentMode = .scaleAspectFit
        cryptoImage.translatesAutoresizingMaskIntoConstraints = false
        cryptoImage.clipsToBounds = true
        return cryptoImage
    }()
    
    private lazy var cellStackView: UIStackView = {
        let cellStackView = UIStackView()
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        return cellStackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0))
        setupCryptoImageView()
        setupCellStackView()
        setupCustomCell()
        setupCryptoPriceLabel()
    }
    
    func configureCellStackView(with viewModel: CryptoTableViewCellModel) {
       cryptoLabel.text = viewModel.name
       cryptoSubLabel.text = viewModel.symbol
       cryptoPriceLabel.text = viewModel.price
   }
    
    func configureCrytoImageView(with viewModel: CryptoTableViewCellModel) {
        if let data = viewModel.iconData {
            cryptoImageView.image = UIImage(data: data)
        } else if let url = viewModel.iconUrl {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self?.cryptoImageView.image = UIImage(data: data)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    private func setupCryptoImageView() {
        contentView.addSubview(cryptoImageView)
        NSLayoutConstraint.activate([
            cryptoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            cryptoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            cryptoImageView.heightAnchor.constraint(equalToConstant: 70),
            cryptoImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupCellStackView() {
        contentView.addSubview(cellStackView)
        [cryptoLabel, cryptoSubLabel].forEach({ cellStackView.addSubview($0) })
        
        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(equalTo: cryptoImageView.trailingAnchor, constant: 8),
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 15),
        ])
        NSLayoutConstraint.activate([
            cryptoLabel.topAnchor.constraint(equalTo: cellStackView.topAnchor),
            cryptoLabel.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            cryptoSubLabel.topAnchor.constraint(equalTo: cryptoLabel.bottomAnchor, constant: 4),
            cryptoSubLabel.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor)
        ])
    }
    
    private func setupCustomCell() {
        backgroundColor = .black
        selectionStyle = .none
        contentView.layer.cornerRadius = 15
        contentView.layer.backgroundColor = UIColor(red: 0.094, green: 0.094, blue: 0.11, alpha: 1).cgColor
    }
    
    private func setupCryptoPriceLabel() {
        contentView.addSubview(cryptoPriceLabel)
        NSLayoutConstraint.activate([
            cryptoPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cryptoPriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            cryptoPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
    }
    

}
