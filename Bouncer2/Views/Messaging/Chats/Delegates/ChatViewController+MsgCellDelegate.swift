//
//  ChatViewController+MsgCellDelegate.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 10/11/23.
//

import MessageKit

extension ChatViewController: MessageCellDelegate{
    //TODO: Open profile by avatar tap
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Open user profile")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Tapped Message")
    }
    
    func didTapBackground(in cell: MessageCollectionViewCell) {
        print("Did tap background")
    }
    func didTapImage(in cell: MessageCollectionViewCell) {
        print("Did tap image, present full screen video player")
        let index = messagesCollectionView.indexPath(for: cell)
        let data = messages[index!.section]
        print(data)
    }

}
