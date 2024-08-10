//
//  CategoryViewModel.swift
//  TrackerNew
//
//  Created by gimon on 06.08.2024.
//

import Foundation

typealias Binding = () -> Void

final class CategoryViewModel {
    
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
        categories = trackerCategoryStore.getArrayNameCategoryCoreData()
        print(#fileID, #function, #line, "categories.count: \(categories.count)")
        return categories.count
    }
    
    func getNameCategory(id: Int) -> (String, Bool) {
        print(#fileID, #function, #line)
        return categories[id]
    }
    
    func addLastCategory(categoryName: String){
        trackerCategoryStore.cleanLastCategoryCoreData()
        trackerCategoryStore.addLastCategoryCoreData(categoryName: categoryName)
        categories = trackerCategoryStore.getArrayNameCategoryCoreData()
    }
    
    func addCategory(name: String) {
        print(#fileID, #function, #line, "name: \(name)")
        trackerCategoryStore.addCategoryCoreData(name: name)
        categories = trackerCategoryStore.getArrayNameCategoryCoreData()
        hiddenEmptyImageLabel?()
    }
}
