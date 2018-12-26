//
//  TouchBarIdentifiers.swift
//  TouchBar
//
//  Created by Andy Pereira on 10/31/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import AppKit

@available(OSX 10.12.2, *)
extension NSTouchBarItem.Identifier {
    static let appLabel = NSTouchBarItem.Identifier("com.dennishou.pomodorobar.appLabel")
    static let presetTimerSegmentedItem = NSTouchBarItem.Identifier("com.dennishou.pomodorobar.presetTimerSegmentedItem")
    static let timerBar = NSTouchBarItem.Identifier("com.dennishou.pomodorobar.timerBar")
    static let infoLabelItem = NSTouchBarItem.Identifier("com.dennishou.InfoLabel")
    static let visitedLabelItem = NSTouchBarItem.Identifier("com.dennishou.VisitedLabel")
    static let visitSegmentedItem = NSTouchBarItem.Identifier("com.dennishou.VisitedSegementedItem")
    static let visitedItem = NSTouchBarItem.Identifier("com.dennishou.VisitedItem")
    static let ratingScrubber = NSTouchBarItem.Identifier("com.dennishou.RatingScrubber")
    static let saveItem = NSTouchBarItem.Identifier("com.dennishou.SaveItem")
    
}



@available(OSX 10.12.2, *)
extension NSTouchBar.CustomizationIdentifier {
    static let travelBar = NSTouchBar.CustomizationIdentifier("com.dennishou.ViewController.TravelBar")
}

