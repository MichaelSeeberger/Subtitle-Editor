//
//  EditRangeService.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 01.08.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import CoreData

struct EditRangeService {
    let document: SubRipDocument
    let undoManager: UndoManager?
    
    /**
     Add time to subtitles in the specified time range
     
     The subtitles whos start time is *at or after* `startTime` and *before or at* `endTime` will be taken to change.
     */
    func addTimeToSubtitlesInRange(startTime: Double, endTime: Double, add time: Double) {
        undoManager?.beginUndoGrouping()
        defer {
            undoManager?.endUndoGrouping()
        }
        
        let subtitles = document.orderedSubtitles.filter { subtitle in
            subtitle.endTime >= startTime && subtitle.startTime <= endTime
        }
        for subtitle in subtitles {
            document.updateSubtitle(with: subtitle.id, startTime: subtitle.startTime + time)
        }
    }
    
    func addTimeToAllSubitles(_ time: Double) {
        undoManager?.beginUndoGrouping()
        defer {
            undoManager?.endUndoGrouping()
        }
        
        let subtitles = document.orderedSubtitles
        for subtitle in subtitles {
            document.updateSubtitle(with: subtitle.id, startTime: subtitle.startTime + time)
        }
    }
}
