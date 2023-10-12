//
//  File.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 10/11/23.
//

import MessageKit

extension ChatViewController: MessagesLayoutDelegate{
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
            return CGSize(width: .makeHeight(50), height: .makeHeight(50))
    }
    
    
    
    func messageBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment? {
        return LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6))
    }
}
