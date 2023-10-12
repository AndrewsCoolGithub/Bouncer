//
//  ChatViewController+MessagesDatasource.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/24/23.
//

import MessageKit

extension ChatViewController: MessagesDataSource {
    func currentSender() -> MessageKit.SenderType {
        sender
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
   
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        guard let data = messages[section] as? Message, data.emojiReactions != nil else {return .zero}
        return CGSize(width: 35, height: 20)
    }
    
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        guard let data = (messages[section] as? Message)?.toCodable(),
              let replyRec = data.replyReceipt,
              let dataType = DataType(rawValue: replyRec.dataType) else {return .zero}
        
        switch dataType {
        case .text:
            let size = replyRec.text!.sizeOfString(usingFont: UIFont.systemFont(ofSize: 12), maxHeight: 120, maxWidth: .makeWidth(300))
            return CGSize(width: size.width, height: size.height + 40)
        case .audio:
            return .zero
        case .image:
            return .zero
        case .video:
            return .zero
        }
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section == messages.count - 1{
            return 15
        }
        return 0
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section == 0 {
            return .wProportioned(80)
        }else{
            return 0
        }
    }
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let message = message as! Message
        if !isNextMessageSameSender(at: indexPath), isFromCurrentSender(message: message), message.isDelivered {
            guard let readReceipts = message.readReceipts else {
                return NSAttributedString(
                  string: "Delivered",
                  attributes: [NSAttributedString.Key.font: UIFont.poppinsRegular(size: .makeHeight(15)), NSAttributedString.Key.foregroundColor: UIColor.nearlyWhite()])
            }
            
            let timeRead = readReceipts.sorted(by: {$0.timeRead < $1.timeRead})[0].timeRead
            let timeSince = (-timeRead.timeIntervalSince(.now)).timeInUnits
            
            return NSAttributedString(
              string: "Seen \(timeSince) ago",
              attributes: [NSAttributedString.Key.font: UIFont.poppinsRegular(size: .makeHeight(15)), NSAttributedString.Key.foregroundColor: UIColor.nearlyWhite()])
            
        }else if !message.isDelivered{
            return NSAttributedString(
              string: "Sending",
              attributes: [NSAttributedString.Key.font: UIFont.poppinsRegular(size: .makeHeight(15)),
                            NSAttributedString.Key.foregroundColor: UIColor.nearlyWhite()])
        }
        return nil
    }
    
    
}
