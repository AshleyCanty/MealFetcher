//
//  HomeVC.swift
//  MealFetcher
//
//  Created by ashley canty on 11/2/23.
//

import UIKit
import Combine
import CoreData

/// HomeVC
class HomeVC: BaseVC {
    
    /// Style struct
    struct Style {
        static let CellHeight: CGFloat = 124
        static let TableBGColor: UIColor = AppColors.BackgroundMain
        static let TopMargin: CGFloat = AppContraintConstants.TopMargin
    }

    /// Tableview
    private lazy var tableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = Style.TableBGColor
        table.dataSource = self
        table.delegate = self
        table.register(CategoryMealCell.self, forCellReuseIdentifier: CategoryMealCell.reuseId)
        return table
    }()
    
    ///  Category meal list
    var categoryMealList: CategoryMeals? {
        didSet {
            DispatchQueue.main.async {  [weak self] in
                guard let sSelf = self else { return }
                sSelf.hideSpinner()
                sSelf.tableView.reloadData()
            }
        }
    }
    
    /// Stores subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    /// Stores enum value for current category
    private var currentCatogory: APIs.MealDB.Category = .Dessert
    
    /// Stores url for a single category
    private lazy var categoryURL: URL = {
        switch self.currentCatogory {
        case .Dessert: return APIs.MealDB.Category.Dessert.urlWithQuery
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        fetchDessertMeals()
        navigationItem.title = currentCatogory.rawValue
    }
    
    /// Configure views
    fileprivate func configureViews() {
        view.addSubview(tableView)
        tableView.disableTranslatesAutoresizingMaskIntoContraints()
        tableView.topAnchor.fc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Style.TopMargin)
        tableView.bottomAnchor.fc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Style.TopMargin)
        tableView.leadingAnchor.fc_constrain(equalTo: view.leadingAnchor)
        tableView.trailingAnchor.fc_constrain(equalTo: view.trailingAnchor)
    }
    
    /// Fetch dessert meals and store in var
    func fetchDessertMeals() {
        DispatchQueue.main.async {
            self.showSpinner()
        }
        
        MealAPIService().fetchDessertList().sink(receiveCompletion: { status in
                switch status {
                case .finished:
                    print("Completed Request: \(status)")
                case .failure(let error):
                    fatalError("Error - failed to process: \(error.localizedDescription)")
                }
            }) { [weak self] categoryList in
                guard let sSelf = self else { return }
                sSelf.categoryMealList = categoryList
                sSelf.categoryMealList?.sortAlphabetically()
            }.store(in: &cancellables)
    }
}

// MARK: - UITableView Delegate Methods

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let mealID = categoryMealList?.meals[indexPath.row].id, let name = categoryMealList?.meals[indexPath.row].name else { return }
        let detailVC = MealDetailsVC(mealName: name, mealID: mealID)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CategoryMealCell.reuseId, for: indexPath) as? CategoryMealCell, let meals = categoryMealList?.meals {
            cell.titleLabel.text = meals[indexPath.row].name
            DispatchQueue.main.async {
                cell.thumbnail.showSpinner()
            }
            
            Task {
                do {
                    try await cell.thumbnail.downloadImage(from: URL(string: meals[indexPath.row].thumb)!)
                    cell.thumbnail.hideSpinner()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        return CategoryMealCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryMealList?.meals.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Style.CellHeight
    }
}


