//
//  ChatViewVideoPlayer.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 10/16/23.
//

import Foundation
import AVKit

class ChatViewVideoPlayerVC: AVPlayerViewController{
    
    init(_ mediaURL: URL){
        super.init(nibName: nil, bundle: nil)
        self.player = AVPlayer(url: mediaURL)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
