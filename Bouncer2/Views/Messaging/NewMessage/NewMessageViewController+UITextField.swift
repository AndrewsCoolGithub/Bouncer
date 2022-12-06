//
//  NewMessageViewController+UITextField.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/6/22.
//

import UIKit

extension NewMessageViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        resetToDefault()
        updateSelected()
    }
   
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let searchText = textField.text!
        lastText = viewModel.text
        viewModel.text = searchText
        
        Task{
            if !searchText.isEmpty{
                let users = try await viewModel.searchUsers(searchText)
                updateSearch(users)
            }else{
                updateSearch(nil)
            }
        }
    }
}

extension  NewMessageViewController: CustomTextFieldDelegate{
    func textFieldDidDelete() {
        if lastText == ""{
            let selectedIndexs = viewModel.selectedUsers.indices.filter({viewModel.selectedUsers[$0].isRed == true})
            selectedIndexs.forEach { index in
                viewModel.selectedUsers.remove(at: index)
                ///Set cell to left of selected to red, if none exists set cell to the right
                if index == 0 && viewModel.selectedUsers.count == 1{ ///Make cell to the right red
                    viewModel.selectedUsers[0].isRed = true
                }else if index != 0{ ///Make cell to the left red
                    viewModel.selectedUsers[index - 1].isRed = true
                }
            }
            
            if selectedIndexs.isEmpty{
                guard viewModel.selectedUsers.count > 0 else {return}
                viewModel.selectedUsers[viewModel.selectedUsers.count - 1].isRed = true
            }
            
            updateSelected()
        }
        
        lastText = viewModel.text
    }
}

protocol CustomTextFieldDelegate: AnyObject {
    func textFieldDidDelete()
}

internal class NMTextField: UITextField {
    weak var customDelegate: CustomTextFieldDelegate?
    override func deleteBackward() {
        super.deleteBackward()
        customDelegate?.textFieldDidDelete()
    }
}
