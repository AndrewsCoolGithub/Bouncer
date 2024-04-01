//
//  MessageCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/23/22.
//

import UIKit
import Combine

class MessageCell: UICollectionViewCell{
    static let id = "message-cell"
    var views = MessageCellViews()
   
    var cancellable: AnyCancellable?
    var imageCancellable: AnyCancellable?
    @Published var profiles: [Profile] = []
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
        imageCancellable?.cancel()
    }
    
    func setup(_ messageDetail: MessageCellViewModel){
        
        arrangeViews()
        setProfileImage(messageDetail)
        if let lastActivity = messageDetail.messageDetail.lastMessage?.toMessage(){
            detailLabelText(lastActivity)
        }
        nameLabelText(messageDetail.messageDetail)
    }
    
    fileprivate func arrangeViews(){
        contentView.backgroundColor = .greyColor()
        
        let profilePhoto = views.profileImage
        let nameLabel = views.nameLabel
        let detailLabel = views.detailLabel
        
        contentView.addSubview(profilePhoto)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
        
        profilePhoto.centerY(inView: contentView, leftAnchor: contentView.leftAnchor, paddingLeft: .makeWidth(15))
        nameLabel.anchor(left: profilePhoto.rightAnchor, paddingLeft: .makeWidth(15))
        nameLabel.anchor(top: profilePhoto.topAnchor, paddingTop: .makeHeight(15))
        detailLabel.anchor(left: profilePhoto.rightAnchor, paddingLeft: .makeWidth(15))
        detailLabel.anchor(bottom: profilePhoto.bottomAnchor, paddingBottom: .makeHeight(15))
    }
    
    fileprivate func nameLabelText(_ messageDetail: MessageDetail){
        let name = messageDetail.chatName
        views.nameLabel.text = name
    }
    
    fileprivate func setProfileImage(_ messageCellViewModel: MessageCellViewModel){
        imageCancellable = messageCellViewModel.$userData.receive(on: DispatchQueue.main).sink{ [weak self] profiles in
            self?.profiles = Array(profiles.values)
            let profilePhoto = self?.views.profileImage
            profilePhoto?.layer.addSublayer(self?.views.skeletonGradient ?? CALayer())
            guard let imageUrl = profiles.values.first(where: {$0.id != User.shared.id})?.image_url else {return}
            profilePhoto?.sd_setImage(with: URL(string: imageUrl)) { [weak self] i, e, c, u in
                self?.views.skeletonGradient.removeFromSuperlayer()
            }
        }
    }
    
    fileprivate func detailLabelText(_ lastActivity: Message) {
        if lastActivity.sender.senderId == User.shared.id!{ //Last Message from me
            //Sent a read message
            if let readReceipts = lastActivity.readReceipts, readReceipts.count > 0{
                let first = -readReceipts[0].timeRead.timeIntervalSinceNow
                let string = first.timeInSmallUnits == "Just now" ?  "Seen \(first.timeInSmallUnits)" : "Seen \(first.timeInSmallUnits) ago"
                views.detailLabel.text = string
                updateLabel(.seen, date: readReceipts[0].timeRead)
            }else{
                //Sent an unread message
                let timeDif = -lastActivity.sentDate.timeIntervalSinceNow
                let string = timeDif.timeInSmallUnits == "Just now" ?  "Sent \(timeDif.timeInSmallUnits.lowercased())" : "Sent \(timeDif.timeInSmallUnits.lowercased()) ago"
                views.detailLabel.text = string
                updateLabel(.sent, date: lastActivity.sentDate)
            }
        }else{ //Last Message from another user
            var messageDisplayed: String!
            switch lastActivity.kind{
            case let .text(i):
                messageDisplayed = i.count > 30 ? "\(i.prefix(30))..." : i
            default:
                return
            }
                
            
           
            let greyColor = [NSAttributedString.Key.foregroundColor : UIColor.nearlyWhite()]
            
            //Show message with spacer and timeNUnits since delivered:
            let timeSinceDelivered = -lastActivity.sentDate.timeIntervalSinceNow
            
            //UNREAD
            guard let readReceipts = lastActivity.readReceipts, readReceipts.contains(where: {$0.uid == User.shared.id!}) else {
                //TODO: - Add unread symbol && make name label semi bold
                let whiteColor = [NSAttributedString.Key.foregroundColor : UIColor.white]
                let firstPart = NSMutableAttributedString(string: messageDisplayed, attributes: whiteColor)
                let middle = NSMutableAttributedString(string:"﹒", attributes: greyColor)
                let secondPart = NSMutableAttributedString(string: timeSinceDelivered.timeInSmallUnits, attributes: greyColor)
                firstPart.append(middle)
                firstPart.append(secondPart)
                views.detailLabel.attributedText = firstPart
                updateLabel(.unread, date: lastActivity.sentDate)
                return
            }
          
            //READ
            let firstPart = NSMutableAttributedString(string: messageDisplayed, attributes: greyColor)
            let middle = NSMutableAttributedString(string:"﹒", attributes: greyColor)
            let secondPart = NSMutableAttributedString(string: timeSinceDelivered.timeInSmallUnits, attributes: greyColor)
            firstPart.append(middle)
            firstPart.append(secondPart)
            views.detailLabel.attributedText = firstPart
            updateLabel(.read, date: lastActivity.sentDate)
        }
    }
    
    private func updateLabel(_ type: MessageCell.LabelType, messageDisplayed: String? = nil, date: Date){
        
       cancellable = Timer.publish(every: 60, on: .main, in: .default).autoconnect().sink { [weak self] _  in
            let timeInterval = -date.timeIntervalSinceNow
            switch type {
            case .seen:
                self?.views.detailLabel.text = "Seen \(timeInterval.timeInSmallUnits) ago"
            case .sent:
                self?.views.detailLabel.text = "Sent \(timeInterval.timeInSmallUnits) ago"
            case .unread:
                guard let messageDisplayed = messageDisplayed else {return}
                let whiteColor = [NSAttributedString.Key.foregroundColor : UIColor.white]
                let greyColor = [NSAttributedString.Key.foregroundColor : UIColor.nearlyWhite()]
                let firstPart = NSMutableAttributedString(string: messageDisplayed, attributes: whiteColor)
                let middle = NSMutableAttributedString(string:"﹒", attributes: greyColor)
                let secondPart = NSMutableAttributedString(string: timeInterval.timeInSmallUnits, attributes: greyColor)
                firstPart.append(middle)
                firstPart.append(secondPart)
                self?.views.detailLabel.attributedText = firstPart
            case .read:
                guard let messageDisplayed = messageDisplayed else {return}
                let greyColor = [NSAttributedString.Key.foregroundColor : UIColor.nearlyWhite()]
                let firstPart = NSMutableAttributedString(string: messageDisplayed, attributes: greyColor)
                let middle = NSMutableAttributedString(string:"﹒", attributes: greyColor)
                let secondPart = NSMutableAttributedString(string: timeInterval.timeInSmallUnits, attributes: greyColor)
                firstPart.append(middle)
                firstPart.append(secondPart)
                self?.views.detailLabel.attributedText = firstPart
            }
        }
    }
    
    private enum LabelType{
        case seen
        case sent
        case unread
        case read
    }
}
