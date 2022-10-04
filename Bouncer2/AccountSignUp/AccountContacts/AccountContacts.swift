//
//  AccountContacts.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/7/22.
//
import UIKit
import Foundation
import MessageUI
import FirebaseAuth

class AccountContacts: UIViewController {
    
    struct Section: Hashable {
        let items: [Item]
        let title: String?
    }
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .greyColor()
        collectionView.register(ContactsCell.self, forCellWithReuseIdentifier: ContactsCell.id)
        collectionView.alwaysBounceVertical = true

        return collectionView
    }()
    
    private var inSearchMode: Bool {
        return (searchBar.searchTextField.isEditing || searchBar.searchTextField.isEnabled) && !searchBar.searchTextField.text!.isEmpty
    }
    var contacts = [Contact]()
    var filtered = [Contact]()
    var tapGesture: UITapGestureRecognizer!
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.setDimensions(height: .makeHeight(50), width: .makeWidth(320))
        searchBar.searchTextField.placeholder = "Search"
        searchBar.backgroundColor = .clear
        searchBar.delegate = self
        
        let placeholder = NSMutableAttributedString(
                   string: "Search",
                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.nearlyWhite(),
                                NSAttributedString.Key.font: UIFont.poppinsMedium(size: .makeWidth(14))])
        searchBar.searchTextField.setDimensions(height: .makeHeight(35), width: .makeWidth(320))
        searchBar.searchTextField.attributedPlaceholder = placeholder
        searchBar.searchTextField.borderStyle = UITextField.BorderStyle.roundedRect
        searchBar.searchTextField.layer.cornerRadius = .makeWidth(14)
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = .buttonGreyColor()
        return searchBar
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Invite Contacts"
        label.textColor = .white
        label.font = .poppinsMedium(size: .makeWidth(20))
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let finishButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(25))
        button.setImage(UIImage(systemName: "chevron.right", withConfiguration: config), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .greyColor()
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(endTyping))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(30))
        
        view.addSubview(finishButton)
        finishButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(30))
        finishButton.anchor(right: view.rightAnchor, paddingRight: .makeWidth(30))
        finishButton.addTarget(self, action: #selector(nextController), for: .touchUpInside)
        
        view.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: .makeHeight(180), width: .makeWidth(414), height: .makeHeight(896 - 180))
        collectionView.delegate = self
        
        view.addSubview(searchBar)
        searchBar.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: .makeHeight(130))
        
        //Cell Dequeue
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, contact in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactsCell.id, for: indexPath) as! ContactsCell
            cell.delegate = self
            cell.setup(contact)
            return cell
        })
        
        guard let contacts = AccountInfo.contacts else {
            print("No Contacts")
            return
        }
        self.contacts = contacts
        
        makeSnapshot()
        
    }
    
    func makeSnapshot(){
        if inSearchMode{
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let items = filtered.map({Item.contact($0)})
            let section = Section(items: items, title: "Contacts")
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        
            dataSource?.apply(snapshot, animatingDifferences: true)
        }else{
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let items = contacts.map({Item.contact($0)})
            let section = Section(items: items, title: "Contacts")
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func nextController(){
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as! UIWindowScene
        let window = windowScene.windows.first!
        
        Location.shared.start { info in
            User.setup()
            User.shared.locationInfo = info
            let navCont = UINavigationController(rootViewController: TabBarController())
            window.rootViewController = navCont
        }
       
        
    }
    
    //_: Called by SEARCH BAR - 'Cancel' / 'Search' && Tapping Background
    @objc func endTyping(){
        searchBar.searchTextField.endEditing(true)
    }
    
    
    //Keyboard Methods for pushing up view
    @objc func keyboardWillHide(notification: NSNotification) {
        self.animateViewForKeyboard()
    }
    
    @objc func keyboardDidAppear(notification: NSNotification){
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.animateViewForKeyboard(frame: keyboardSize)
            //}
        }
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.animateViewForKeyboard(frame: keyboardSize)
        }
    }
    
    func animateViewForKeyboard(frame: CGRect? = nil){
        if let frame = frame {
            let translate = ((frame.height > .makeHeight(100))) ? .makeHeight(100) : frame.height
            if self.view.frame.origin.y == 0{
                UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 2.2, options: .transitionCrossDissolve) {
                    self.view.frame.origin.y -= translate
                }
            }
        }else{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.6, initialSpringVelocity: 2.2, options: .transitionCrossDissolve) {
                self.view.frame.origin.y = 0
            }
        }
    }
}

extension AccountContacts: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .aspectGetSize(height: 100, width: 414)
    }
}
enum Item: Hashable {
    case contact(Contact)
}
extension AccountContacts: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty && searchText.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.filtered = contacts.filter({
                $0.number.lowercased().hasPrefix(searchText.lowercased()) ||
                $0.name.lowercased().hasPrefix(searchText.lowercased())
            })
            self.makeSnapshot()
            return
        }
        self.makeSnapshot()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(self.tapGesture)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(self.tapGesture)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endTyping()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.endTyping()
    }
}

extension AccountContacts: ContactDelegate{
    func sendText(_ number: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = """
                              https://apps.apple.com/us/app/bouncer-find-your-people/id1606862049
                              Get this app.
                              """
            controller.recipients = [number]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true) {
                //_: Variable persists contactCV Datasource (i.e filtered, contacts) when app is pushed to background
               
            }
        }
    }
}


protocol ContactDelegate: AnyObject{
    func sendText(_ number: String)
}

extension AccountContacts: MFMessageComposeViewControllerDelegate{
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        makeSnapshot()
        if result == .sent{
            if let number = controller.recipients?[0]{
//                self.sent.append(number)
                HapticsManager.shared.vibrate(for: .success)
                NotificationCenter.default.post(name: Notification.Name("awaitMessage"), object: self, userInfo: ["number": number])
            }
        }else{
            HapticsManager.shared.vibrate(for: .warning)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
