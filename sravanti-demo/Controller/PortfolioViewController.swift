//
//  PortfolioViewController.swift
//  sravanti-demo
//
//  Created by Sravanti on 01/11/25.
//

import UIKit

class PortfolioViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: PortFolioViewModel
    
    // MARK: - UI Components
    private let tableView = UITableView()
    private let portFolioView = PortFolioView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Initializer
    init(viewModel: PortFolioViewModel = PortFolioViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        loadData()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "HOLDINGS"
        view.backgroundColor = .systemBackground
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HoldingTableViewCell.self, forCellReuseIdentifier: "HoldingCell")
        tableView.separatorStyle = .singleLine
        //tableView.tableFooterView = summaryView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Refresh Control
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // Activity Indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        // Error Label
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.textColor = .secondaryLabel
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        
        // Portfolio Summary
        view.addSubview(portFolioView)
        portFolioView.translatesAutoresizingMaskIntoConstraints = false
        
//                view.addSubview(newSumm)
//        newSumm.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: portFolioView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            portFolioView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            portFolioView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            portFolioView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)

        ])
        
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.onHoldingsUpdated = { [weak self] in
            self?.tableView.reloadData()
            if let summary = self?.viewModel.portfolioSummary {
                
                self?.portFolioView.configure(with: summary)
                
            }
            self?.errorLabel.isHidden = true
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.onError = { [weak self] message in
            self?.errorLabel.text = message
            self?.errorLabel.isHidden = false
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Data Loading
    private func loadData() {
        Task {
            await viewModel.fetchHoldings()
        }
    }
    
    @objc private func handleRefresh() {
        Task {
            await viewModel.fetchHoldings()
        }
    }
}

// MARK: - UITableView Delegate & DataSource

extension PortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfHoldings()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HoldingCell", for: indexPath) as? HoldingTableViewCell,
              let holding = viewModel.holding(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configure(with: holding)
        return cell
    }
}


