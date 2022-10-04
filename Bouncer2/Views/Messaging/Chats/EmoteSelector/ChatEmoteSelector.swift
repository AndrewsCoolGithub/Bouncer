//
//  ChatEmoteSelector.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 9/16/22.
//

import FloatingPanel

class ChatEmoteSelectorCC: UIViewController{
   
    var inSearchMode: Bool {
        return (searchBar.searchTextField.isEditing || searchBar.searchTextField.isEnabled) && !searchBar.searchTextField.text!.isEmpty
    }
    
    var tapForDismiss: UITapGestureRecognizer!
    var dataSource: UICollectionViewDiffableDataSource<Section, Emoji>?
    enum Section: String{
        case reactions = "My Reactions"
        case recent = "Recents"
        case all = "All Emojis"
        case searchResult = " "
    }
    
    var message: Message!
    var myReactions = User.shared.emojis!
    var recent = User.shared.recentEmojis ?? []
    var allEmojis = [Emoji]()
    var filtered = [Emoji]()
    
    var delegate: ChatReactDelegate!
    var inCustomMode: Bool = false
    var customizeEmojiDelegate: CustomizeEmojiDelegate!
    init(){
        super.init(nibName: nil, bundle: nil)
        
        allEmojis = EmojiGallery.shared.emojis.filter({ !myReactions.contains($0) && !recent.contains($0)})
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCV()
        setupUI()
        makeSnapshot()
        
    }
    
    ///Setup UI
    fileprivate func setupUI(){
        view.backgroundColor = .greyColor()
        tapForDismiss = UITapGestureRecognizer(target: self, action: #selector(endTyping)) /// Dismiss Gesture
        tapForDismiss.cancelsTouchesInView = false
        let searchBar = searchBar ///Search Bar
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: .makeHeight(25), paddingLeft: .makeWidth(10))
        
        
        let cancelButton = cancelSearchButton ///Cancel Button
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: .makeHeight(22.5), paddingRight: .makeWidth(10))
        cancelButton.addTarget(self, action: #selector(dimissView), for: .touchUpInside)
        
        ///105 + 260
        let searchCollectionView = searchCollectionView ///Collection View
        searchCollectionView.delegate = self
        view.addSubview(searchCollectionView)
        searchCollectionView.frame = CGRect(x: 0, y: .makeHeight(105), width: .makeWidth(414), height: .makeHeight(530))
    }
    
    
    ///Setup CollectionView
    fileprivate func setupCV(){
        dataSource = UICollectionViewDiffableDataSource(collectionView: searchCollectionView, cellProvider: { collectionView, indexPath, emoteString in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoteCVCell.id, for: indexPath) as! EmoteCVCell
            cell.setup(emoteString)
            return cell
        })  ///Datasource
        
        dataSource?.supplementaryViewProvider = { [weak self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView?  in
            let header = self?.searchCollectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: EmoteCVSectionHeader.id, for: indexPath) as! EmoteCVSectionHeader
            guard let section = self?.dataSource?.sectionIdentifier(for: indexPath.section) else {return nil}
            header.setup(section.rawValue, delegate: self?.customizeEmojiDelegate)
            return header
        }  ///Header Cell
    }
    
    fileprivate func makeSnapshot(){
        if inSearchMode{
            var snapshot = NSDiffableDataSourceSnapshot<Section, Emoji>()
            snapshot.appendSections([.searchResult])
            snapshot.appendItems(filtered, toSection: .searchResult)
            dataSource?.apply(snapshot, animatingDifferences: true)
            
        }else{
            var snapshot = NSDiffableDataSourceSnapshot<Section, Emoji>()
            if inCustomMode{
                snapshot.appendSections([.all])
                snapshot.appendItems(allEmojis, toSection: .all)
            }else{
                if recent.isEmpty{
                    snapshot.appendSections([.reactions, .all])
                    snapshot.appendItems(myReactions, toSection: .reactions)
                    snapshot.appendItems(allEmojis, toSection: .all)
                }else{
                    snapshot.appendSections([.reactions, .recent, .all])
                    snapshot.appendItems(myReactions, toSection: .reactions)
                    snapshot.appendItems(recent, toSection: .recent)
                    snapshot.appendItems(allEmojis, toSection: .all)
                }
            }
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func dimissView(){
        print("Dismiss view")
    }
    
    @objc func endTyping(){
        searchBar.searchTextField.endEditing(true)
    }
    
    let searchCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmoteCVCell.self, forCellWithReuseIdentifier: EmoteCVCell.id)
        collectionView.register(EmoteCVSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmoteCVSectionHeader.id)
        collectionView.backgroundColor = .greyColor()
        return collectionView
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.barStyle = .black
        searchBar.tintColor = .white
        searchBar.backgroundColor = .greyColor()
        searchBar.barTintColor = .greyColor()
        searchBar.setDimensions(height: .makeHeight(60), width: .makeWidth(310))
        return searchBar
    }()
    
    let cancelSearchButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .poppinsMedium(size: .makeWidth(16.5))
        button.titleLabel?.textAlignment = .center
        button.setDimensions(height: .makeHeight(60), width: .makeWidth(85))
        return button
    }()
}

extension ChatEmoteSelectorCC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: .makeWidth(69), height: .makeWidth(69) * 1.29)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if inCustomMode{
            return .zero
        }
        return CGSize(width: .makeWidth(414), height: .makeHeight(28))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let emote = dataSource?.itemIdentifier(for: indexPath) {
            guard !inCustomMode else {
                
                
                customizeEmojiDelegate.replaceEmoji(with: emote, indexPath.row)
                return
            }
            
            delegate.emoteReaction(for: self.message, emote.emote)
            
            if !myReactions.contains(emote){
                if recent.isEmpty{
                    Task{
                        try await AuthManager.shared.updateRecents([emote])
                    }
                }else{
                    Task{
                        if !recent.contains(emote){
                            if recent.count == 6{
                                let _ = recent.popLast()
                            }
                            
                            recent.insert(emote, at: 0)
                            try await AuthManager.shared.updateRecents(recent)
                        }
                    }
                }
            }
            
            (self.parent as! ChatEmoteSelector).removePanelFromParent(animated: true)
        }
    }
}

extension ChatEmoteSelectorCC: UIScrollViewDelegate{
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        

        if actualPosition.y > 0 {
            let parent = self.parent as! ChatEmoteSelector
            if !inCustomMode{
                parent.move(to: .half, animated: true)
            }
           
            searchBar.searchTextField.endEditing(true)
        }else{
            searchBar.searchTextField.endEditing(true)
        }
    }
}

extension ChatEmoteSelectorCC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !searchText.isEmpty && searchText != " " {
            filtered = allEmojis.filter({$0.name.range(of: searchText, options: .caseInsensitive) != nil})
            makeSnapshot()
            return
        }
        makeSnapshot()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(self.tapForDismiss)
        let parent = self.parent as! ChatEmoteSelector
        parent.move(to: .full, animated: true)
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


//MARK: - Floating Panel Parent View
