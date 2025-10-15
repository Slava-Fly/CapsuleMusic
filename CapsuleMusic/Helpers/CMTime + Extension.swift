//
//  CMTime + Extension.swift
//  CapsuleMusic
//
//  Created by Славка Корн on 13.10.2025.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        let timeFormatSting = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatSting
    }
    
}
