//
//  ViewController.swift
//  DisplayFilterUI_v2
//
//  Created by Akanksha Gupta on 27/07/21.
//

import UIKit

class FilterListViewController: UIViewController {
    
    public var filterViewModel = FilterListViewModel()
    
    public var myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        styleCollectionView()
        filterViewModel.fetchFilterData {
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
        }
    }
}

extension FilterListViewController {
    
    public func setupCollectionView() {
        myCollectionView.register(FilterHeaderSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: FilterHeaderSection.self))
        myCollectionView.register(FilterListCell.self, forCellWithReuseIdentifier: String(describing: FilterListCell.self))
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    }
    
    public func styleCollectionView() {
        self.view.addSubview(myCollectionView)
        NSLayoutConstraint.activate([
            myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            myCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            myCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            myCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        myCollectionView.backgroundColor = .white
        myCollectionView.allowsMultipleSelection = true
    }
    
    public func containsExcludeList(indexPath: IndexPath) -> Bool {
        let selectedFilterSet = NSSet(array: filterViewModel.selectedFilterList)
        for excludeFilter in filterViewModel.excludeList {
            let excludeFilterSet  = NSSet(array: excludeFilter)
            if excludeFilterSet.isSubset(of: selectedFilterSet as! Set<AnyHashable>) {
                filterViewModel.selectedFilterList = filterViewModel.selectedFilterList.filter( { $0.category_id != "\(indexPath.section + 1)"})
                let messageAlert = UIAlertController(title: "Alert!", message: "Selection Not Available for the selected Filter", preferredStyle: UIAlertController.Style.alert)
                messageAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(messageAlert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}

extension FilterListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
       
        if let previousSelectedIndexArray = collectionView.indexPathsForSelectedItems?.filter( { $0.section == indexPath.section }) {
            if previousSelectedIndexArray.count > 0 {
                let previousSelectedIndex = previousSelectedIndexArray[0]
                let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndex) as! FilterListCell
                collectionView.deselectItem(at: previousSelectedIndex, animated: false)
                previousSelectedCell.isSelected = false
                filterViewModel.selectedFilterList = filterViewModel.selectedFilterList.filter( { $0.category_id != "\(previousSelectedIndex.section + 1)" })
            }
        }
        let cell = collectionView.cellForItem(at: indexPath) as! FilterListCell
        filterViewModel.selectedFilterList.append(ExcludeList(category_id: cell.categoryID, filter_id: cell.filterID))
        return containsExcludeList(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? FilterListCell
        cell?.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? FilterListCell
        filterViewModel.selectedFilterList = filterViewModel.selectedFilterList.filter( { $0.category_id != "\(indexPath.section + 1)"})
        cell?.isSelected = false
    }
}

extension FilterListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filterViewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterViewModel.numberOfRowsInSections(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilterListCell.self), for: indexPath) as? FilterListCell
        let filterName = filterViewModel.getFilterName(indexPath: indexPath)
        let categoryID = filterViewModel.getCategoryID(indexPath: indexPath)
        let filterID = filterViewModel.getFilterID(indexPath: indexPath)
        cell?.categoryID = categoryID
        cell?.filterID = filterID
        cell?.configure(filterName: filterName, isSelected: false)
        cell?.isSelected = true
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: FilterHeaderSection.self), for: indexPath) as! FilterHeaderSection
            sectionHeader.label.text = filterViewModel.getCategoryName(indexPath: indexPath)
             return sectionHeader
        } else {
             return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

extension FilterListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
}
