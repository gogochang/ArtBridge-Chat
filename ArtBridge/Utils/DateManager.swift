//
//  timeStampConverter.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/22.
//

import Foundation
import Firebase

class DateManager {
    static func timeStampToString(_ timestamp: Timestamp) -> String {
        print("timeStampManager - timeStampToString")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let time = dateFormatter.string(from: timestamp.dateValue())
        
        return time
    }
}
