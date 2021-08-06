//
//  FilterViewModel.swift
//  DisplayFilterUI_v2
//
//  Created by Akanksha Gupta on 03/08/21.
//

import UIKit

class FilterListViewModel: NSObject {
        
    public var categoryList = [Category]()
    public var excludeList = [[ExcludeList]]()
    public var selectedFilterList = [ExcludeList]()
    public var apiservice = APIService()
    
}

extension FilterListViewModel {
    
    public func numberOfSections() -> Int {
        return categoryList.count
    }
    
    public func numberOfRowsInSections(section: Int) -> Int {
        return categoryList[section].filters?.count ?? 0
    }
    
    func updatefilterList(with filterModel: FilterModel?) {
        guard let filterModel = filterModel else {
            return
        }
        self.categoryList = filterModel.data?.categories ?? []
        self.excludeList = filterModel.data?.exclude_list ?? []
        }
    
    public func fetchFilterData(completion: @escaping () -> Void) {
        apiservice.fetchProductDetails(completion: { (result) in
            self.updatefilterList(with: result)
            completion()
        })
    }
    
    
    public func getCategoryName(indexPath: IndexPath) -> String {
        return categoryList[indexPath.section].name ?? ""
    }
    
    public func getFilterName(indexPath: IndexPath) -> String {
        return categoryList[indexPath.section].filters![indexPath.item].name ?? ""
    }
    
    public func getCategoryID(indexPath: IndexPath) -> String {
        return categoryList[indexPath.section].category_id ?? ""
    }
    
    public func getFilterID(indexPath: IndexPath) -> String {
        return categoryList[indexPath.section].filters?[indexPath.row].id ?? ""
    }
}
