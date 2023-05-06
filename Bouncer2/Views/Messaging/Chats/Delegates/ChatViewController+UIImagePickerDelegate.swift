//
//  ChatViewController+UIImagePickerDelegate.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/29/23.
//

import UIKit

extension ChatViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
           
        }
    }
}
