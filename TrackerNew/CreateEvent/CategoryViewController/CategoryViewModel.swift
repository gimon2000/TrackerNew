//
//  CategoryViewModel.swift
//  TrackerNew
//
//  Created by gimon on 06.08.2024.
//

import Foundation

protocol CategoryViewModelProtocol {
    var hiddenEmptyImageLabel: Binding? {set get}
    func trackerCategoryCount() -> Int
    func trackerCategoryIsEmpty() -> Bool
    func addLastCategory(categoryName: String)
    func addCategory(name: String)
    func getNameCategory(id: Int) -> (String, Bool)
}

typealias Binding = () -> Void

final class CategoryViewModel: CategoryViewModelProtocol {
    
    //MARK: - Public Property
    var hiddenEmptyImageLabel: Binding?
    
    //MARK: - Private Property
    private var trackerCategoryStore = TrackerCategoryStore()
    private var categories: [(String, Bool)] = []
    
    //MARK: - Public Methods
    func trackerCategoryIsEmpty() -> Bool {
        print(#fileID, #function, #line)
        return trackerCategoryStore.isCategoryCoreDataEmpty()
    }
    
    func trackerCategoryCount() -> Int {
        print(#fileID, #function, #line)
        updateCategories()
        print(#fileID, #function, #line, "categories.count: \(categories.count)")
        return categories.count
    }
    
    func getNameCategory(id: Int) -> (String, Bool) {
        print(#fileID, #function, #line)
        return categories[id]
    }
    
    func addLastCategory(categoryName: String) {
        trackerCategoryStore.cleanLastCategoryCoreData()
        trackerCategoryStore.addLastCategoryCoreData(categoryName: categoryName)
        updateCategories()
    }
    
    func addCategory(name: String) {
        print(#fileID, #function, #line, "name: \(name)")
        trackerCategoryStore.addCategoryCoreData(name: name)
        updateCategories()
        hiddenEmptyImageLabel?()
    }
    
    private func updateCategories() {
        let arrayCategory = trackerCategoryStore.getArrayNameCategoryCoreData()
        categories = arrayCategory.filter{
            $0.0 != "Закрепленные"
        }
    }
}
