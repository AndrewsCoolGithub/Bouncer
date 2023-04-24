//
//  ChatEmoteView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 9/14/22.
//

import MessageKit

class ChatEmoteView: MessageReusableView{
    
    static let id: String = "chat_emote_view"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2.5
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
//        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.alignment = .center
        return stackView
    }()
    
    /// [ 💙 : [uids] ]
    var dictionary = [String: [String]]()
    
    ///Viewmodel is included for profile pics
    func setup(with emotes: [EmoteReaction], _ viewModel: ChatViewModel, _ cellX: CGFloat){
        dictionary = [:]
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        stackView.removeFromSuperview()
        guard !emotes.isEmpty else {return}
        addSubview(stackView)
        stackView.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: cellX, constant: -5)
        stackView.backgroundColor = .lightGreyColor()
        stackView.layer.cornerRadius = 17.5
        stackView.layer.masksToBounds = true
        stackView.clipsToBounds = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 2.5, leading: 5, bottom: 2.5, trailing: 5)
        let uniqueEmojisCount = findUniqueEmojis(emotes)
        if uniqueEmojisCount >= 2 {
            ///Multiple emojis with n reactions
            var userCount = 0
            dictionary.values.forEach { uids in
                userCount += uids.count
            }
            
            let topRange = min(3, dictionary.keys.count)
            for index in 0...topRange-1{
                let emoteImageView = UIImageView(image: emotes[index].emote.emojiStringToImage(CGSize(width: 25, height: 30)))
                stackView.addArrangedSubview(emoteImageView)
            }
            
            if userCount > dictionary.keys.count{
                let label = UILabel()
                label.text = "\(userCount)"
                label.textColor = .white
                label.font = .poppinsMedium(size: 13)
                stackView.addArrangedSubview(label)
            }
        }else{
            guard let uids = dictionary[emotes[0].emote], uids.count > 1 else {
               
                ///Single user reaction
                let emoteImageView = UIImageView(image: emotes[0].emote.emojiStringToImage(CGSize(width: 25, height: 30)))
                stackView.addArrangedSubview(emoteImageView)
                stackView.arrangedSubviews.forEach({$0.layer.masksToBounds = true})
                return
            }
            print("DICT: \(self.dictionary)")
            ///Single emoji, with n reactions
            let topRange = min(3, viewModel.profiles.count)
            let imageURLs = viewModel.profiles[0...topRange-1].compactMap({$0.image_url})
            print("Create ImageViews")
//            createStackWImageViews(imageURLs, uids.count, emotes[0].emote)
        }
        
        
        
    }
        
    func findUniqueEmojis(_ reactions: [EmoteReaction]) -> Int{
        for reaction in reactions {
            guard dictionary[reaction.emote] != nil else {
                dictionary[reaction.emote] = [reaction.uid]
                continue
            }
            
            
            if !dictionary[reaction.emote]!.contains(reaction.uid){
                dictionary[reaction.emote]!.append(reaction.uid)
            }
            
        }
        return dictionary.count
    }
    
//    fileprivate func createStackWImageViews(_ imageURLs: [String], _ count: Int,  _ emoji: String){
    //
    //        //Fetch Images First
    //        fetchUIImages(imageURLs) { [weak self] images in
    //            //Create ImageViews
    //            let emoteImageView = UIImageView(image: emoji.emojiStringToImage(CGSize(width: 26, height: 26)))
    //            self?.stackView.insertSubview(emoteImageView, at: 0)
    //            images.forEach { image in
    //                let profileImageView = UIImageView(image: image)
    //                profileImageView.contentMode = .scaleAspectFill
    //                profileImageView.setDimensions(height: 25, width: 25)
    //                profileImageView.layer.cornerRadius = 12.5
    //                profileImageView.layer.masksToBounds = true
    //                self?.stackView.addArrangedSubview(profileImageView)
    //            }
    //            ///Add number label if > 3
    //            if count > 3 {
    //                let label = UILabel()
    //                label.text = "\(count)"
    //                label.textColor = .white
    //                label.font = .poppinsMedium(size: 13)
    //                self?.stackView.addArrangedSubview(label)
    //            }
    //        }
    //    }
    //
    //    fileprivate func fetchUIImages(_ imageURLs: [String], completion: @escaping([UIImage]) -> Void){
    //
    //        var images = [UIImage]()
    //
    //        var count = 0
    //        imageURLs.forEach { url in
    //            UIImageView().sd_setImage(with: URL(string: url)) { i, e, c, u in
    //                guard let image = i else {
    //                    count += 1
    //                    return
    //                }
    //
    //                images.append(image)
    //
    //                if images.count + count == imageURLs.count{
    //                    return completion(images)
    //                }
    //            }
    //        }
    //    }
    
}
