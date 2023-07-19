//
//  EditRangeService.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 01.08.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import CoreData

struct EditRangeService {
    let context: NSManagedObjectContext
    let undoManager: UndoManager?
    
    /**
     Add time to subtitles in the specified time range
     
     The subtitles whos start time is *at or after* `startTime` and *before or at* `endTime` will be taken to change.
     */
    func addTimeToSubtitlesInRange(startTime: Double, endTime: Double, add time: Double) throws {
        undoManager?.beginUndoGrouping()
        defer {
            undoManager?.endUndoGrouping()
        }
        guard let entityName = Subtitle.entity().name else {
            let error = NSError(domain: "SubtitleEditorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not get the subtitles entity name."])
            throw error
        }
        let request = NSFetchRequest<Subtitle>(entityName: entityName)
        request.predicate = NSPredicate(format: "startTime >= %f && startTime <= %f", startTime, endTime)
        
        let subtitles = try context.fetch(request)
        for subtitle in subtitles {
            subtitle.changeStartTime(newStartTime: subtitle.startTime + time, keepDuration: true)
        }
    }
    
    func addTimeToAllSubitles(_ time: Double) throws {
        undoManager?.beginUndoGrouping()
        defer {
            undoManager?.endUndoGrouping()
        }
        guard let entityName = Subtitle.entity().name else {
            let error = NSError(domain: "SubtitleEditorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not get the subtitles entity name."])
            throw error
        }
        let request = NSFetchRequest<Subtitle>(entityName: entityName)
        
        let subtitles = try context.fetch(request)
        for subtitle in subtitles {
            subtitle.changeStartTime(newStartTime: subtitle.startTime + time, keepDuration: true)
        }
    }
}
