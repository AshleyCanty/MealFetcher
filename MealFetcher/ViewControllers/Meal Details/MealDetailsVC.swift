//
//  MealDetailsVC.swift
//  MealFetcher
//
//  Created by ashley canty on 11/5/23.
//

import Foundation
import UIKit
import Combine

/// MealDetailsVC
class MealDetailsVC: BaseVC {
    
    /// Style struct
    struct Style {
        static let BackgroundColor: UIColor = AppColors.BackgroundMain
        static let TitleFont: UIFont = AppFont.medium(size: 13)
        static let TitleTextColor: UIColor = AppColors.TextColorSecondary
        static let TitleTopMargin: CGFloat = AppContraintConstants.TopMargin
        static let StackSpacing: CGFloat = 12.0
        static let TopMargin: CGFloat = AppContraintConstants.TopMargin
        static let LeadingTrailingMargin: CGFloat = AppContraintConstants.LeadingTrailingMargin
    }
 
    /// Stores height of instructionTextView from MealInsructionDetailCell
    private var textViewHeight: CGFloat = 0.0
    /// Stores ingredient/measurement list
    private var ingredientlist: [Ingredient]? = nil
    /// Stores meal details
    private var mealDetails: MealDetails? = nil {
        didSet {
            self.ingredientlist = mealDetails?.getIngredientMeasureList()
            tableView.reloadData()
        }
    }
    /// Stores meal ID
    private lazy var mealId: String? = nil {
        didSet {
            fetchMealDetails()
        }
    }
    
    /// tableview
    private lazy var tableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = Style.BackgroundColor
        table.dataSource = self
        table.delegate = self
        table.register(MealInstructionDetailCell.self, forCellReuseIdentifier: MealInstructionDetailCell.reuseId)
        table.register(MealIngredientDetailCell.self, forCellReuseIdentifier: MealIngredientDetailCell.reuseId)
        return table
    }()
    
    /// Stores subscribers
    private var cancellables = Set<AnyCancellable>()

    init(mealName: String, mealID: String) {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = mealName
        self.mealId = mealID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    /// configures views
    private func configure() {
        view.addSubview(tableView)
        tableView.disableTranslatesAutoresizingMaskIntoContraints()
        tableView.topAnchor.fc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Style.TopMargin)
        tableView.bottomAnchor.fc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Style.TopMargin)
        tableView.leadingAnchor.fc_constrain(equalTo: view.leadingAnchor)
        tableView.trailingAnchor.fc_constrain(equalTo: view.trailingAnchor)
    }
    
    /// Fetch meal details using the meal ID
    func fetchMealDetails() {
        guard let mealId = mealId else { return }
        
        DispatchQueue.main.async {
            self.showSpinner()
        }
        
        MealAPIService().fetchMealDetails(mealId: mealId).sink(receiveCompletion: { status in
            switch status {
            case .finished:
                print("Completed Request: \(status)")
            case .failure(let error):
                fatalError("Error - failed to process: \(error.localizedDescription)") // refactor
            }
        }) { [weak self] data in
            guard let sSelf = self else { return }
            
            if let prettyString = data.prettyPrintedJSONString {
                sSelf.ingredientlist = IngredientRegexExtractor().findRegexMatchesForIngredients(withString: prettyString as String)
            }
            
            var mealdetailsList: MealDetailList?
            do {
                mealdetailsList = try JSONDecoder().decode(MealDetailList.self, from: data)
            } catch {
                print("Error occured: failed to decode")
                DispatchQueue.main.async {
                    sSelf.hideSpinner()
                }
            }

            guard let mealdetailsList = mealdetailsList, let mealDetails = mealdetailsList.details?.first else { return }
            DispatchQueue.main.async {
                sSelf.hideSpinner()
                sSelf.mealDetails = mealDetails
            }
        }.store(in: &cancellables)
    }
}

// MARK: - UITableView Delegate Methods

extension MealDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    /// enum for table section titles
    private enum SectionTitle: String {
        case Instructions = "Instructions"
        case Ingredients = "Ingredients and Measurements"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            guard indexPath.row == 0, let instructionCell = tableView.dequeueReusableCell(withIdentifier: MealInstructionDetailCell.reuseId, for: indexPath) as? MealInstructionDetailCell else { return MealInstructionDetailCell() }
            
            /// Update textView height and table rows after assigning string value to the instructionsTextView
            instructionCell.textView.text = mealDetails?.instructions
            instructionCell.cancellable = instructionCell.updateTextViewCellHeight.compactMap{$0}.sink(receiveValue: { [weak self] value in
                guard let sSelf = self else { return }
                    sSelf.textViewHeight = value
                DispatchQueue.main.async {
                    sSelf.tableView.beginUpdates()
                    sSelf.tableView.endUpdates()
                }
            })
            cell = instructionCell
        } else {
            guard let ingredientCell = tableView.dequeueReusableCell(withIdentifier: MealIngredientDetailCell.reuseId, for: indexPath) as? MealIngredientDetailCell, let item = ingredientlist?[indexPath.row] else { return cell }
            ingredientCell.titleLabel.text = "\(item.amount) \(item.name)"
            cell = ingredientCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return SectionTitle.Instructions.rawValue
        }
        return SectionTitle.Ingredients.rawValue
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return ingredientlist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return textViewHeight
        }
        return 30
    }
}
