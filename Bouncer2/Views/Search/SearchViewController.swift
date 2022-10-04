//
//  SearchViewController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/21/22.
//

import Foundation
import UIKit

class SearchViewController: UIViewController{
    
    let components = SearchViewComponents()
    private var inSearchMode: Bool {
        return (components.searchBar.searchTextField.isEditing || components.searchBar.searchTextField.isEnabled) && !components.searchBar.searchTextField.text!.isEmpty
    }
    
    var tapForDismiss: UITapGestureRecognizer!
    var dataSource: UICollectionViewDiffableDataSource<Section, Profile>?
    
    var filtered = [Profile]()
    var suggested = [Profile]()
    var lastDocGroup: SearchManager.LastDocumentGroup?
    
    enum Section{
        case filtered
        case suggested
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        setupCV()
        setupSuggestions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupUI()
    }
    
    //MARK: Setup UI Elements
    
    fileprivate func setupUI(){
        view.backgroundColor = .greyColor()
        tapForDismiss = UITapGestureRecognizer(target: self, action: #selector(endTyping)) // Dismiss Gesture
        let searchBar = components.searchBar //Search Bar
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: .makeHeight(10), paddingLeft: .makeWidth(10))
        
        let cancelButton = components.cancelSearchButton //Cancel Button
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: .makeHeight(7.5), paddingRight: .makeWidth(10))
        cancelButton.addTarget(self, action: #selector(dimissView), for: .touchUpInside)
        
        let searchCollectionView = components.searchCollectionView //Collection View
        searchCollectionView.delegate = self
        view.addSubview(searchCollectionView)
        searchCollectionView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, width: .makeWidth(414), height: (.makeHeight(896) - (SafeArea.topSafeArea() + .makeHeight(70))))
    }
    
    //MARK: Setup CollectionView
    fileprivate func setupCV(){
        let searchCollectionView = components.searchCollectionView
        searchCollectionView.prefetchDataSource = self  //Prefetch
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: searchCollectionView, cellProvider: { collectionView, indexPath, profile in
    
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileSearchCell.id, for: indexPath) as! ProfileSearchCell
            cell.setupCell(with: profile, followCache: nil)
            return cell
        })  //Datasource
        
        dataSource?.supplementaryViewProvider = { [weak self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView?  in
            
            let header = searchCollectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: SearchHeaderCell.id, for: indexPath) as! SearchHeaderCell
            if self?.dataSource?.sectionIdentifier(for: indexPath.section) == .suggested{
                header.setup()
            }
            return header
        }  //Header Cell
    }
    
    
    fileprivate func setupSuggestions() {
        let suggestCache = SearchManager.shared.suggested
        if suggestCache.count > 0 {
            suggested = suggestCache
            makeSnapshot()
        }else{
            Task{
                let contacts = ContactsManager.instance.contacts
                let except = try await ContactsManager.instance.fetchContactsWAccount(contacts)
                suggested += try await SearchManager.shared.suggestedUsers(except: except.map {$0.id!}) //filter out contacts
                suggested += except
                makeSnapshot()
                SearchManager.shared.suggested = suggested
            }
        }
    }
    
    fileprivate func makeSnapshot(){
        if inSearchMode{
            var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
            
            let profiles = filtered
            snapshot.appendSections([.filtered])
            snapshot.appendItems(profiles, toSection: .filtered)
        
            dataSource?.apply(snapshot, animatingDifferences: true)
        }else{
            var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
            
            let profiles = suggested
            snapshot.appendSections([.suggested])
            snapshot.appendItems(profiles, toSection: .suggested)
        
            dataSource?.apply(snapshot, animatingDifferences: true, completion: {
                self.filtered = []
            })
        }
    }
    
    fileprivate var isWaiting: Bool = false
    fileprivate func doPaging() {
        if let lastDocGroup = lastDocGroup, !isWaiting{
            Task{
                isWaiting = true
                let newUsers = try await SearchManager.shared.fetchMore(lastDocuments: lastDocGroup, filtered: filtered)
                self.filtered += newUsers.0
                self.lastDocGroup = newUsers.1
                self.makeSnapshot()
                
                isWaiting = false
            }
        }
    }
    
    
    @objc func dimissView(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func endTyping(){
        components.searchBar.searchTextField.endEditing(true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .aspectGetSize(height: 95, width: 414)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if dataSource?.sectionIdentifier(for: section)  == .suggested{
            return CGSize(width: .makeWidth(170), height: .makeWidth(70))
        }else{
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let profile = dataSource?.itemIdentifier(for: indexPath) {
            var profileVC: ProfileViewController!
            if profile.id == User.shared.id!{
                profileVC = ProfileViewController()
            }else{
                profileVC = ProfileViewController(profile: profile)
            }
           
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        return
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == self.filtered.count{
            doPaging()
        }
    }
}

extension SearchViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        endTyping()
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchText.isEmpty && searchText != " " {
            Task{
                let searchResult = try await SearchManager.shared.fetchUsers(searchText, for: .username)
                filtered = searchResult.0
                lastDocGroup = searchResult.1
                makeSnapshot()
            }
            return
        }
        
        makeSnapshot()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(self.tapForDismiss)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(self.tapForDismiss)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endTyping()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.endTyping()
    }
}
