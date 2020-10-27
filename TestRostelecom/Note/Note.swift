//
//  Item.swift
//  TestRostelecom
//
//  Created by Савченко Максим Олегович on 2020. 10.27..
//  Copyright © 2020. Савченко Максим Олегович. All rights reserved.
//

import Foundation

final class SimpleNote {
    private(set) var simpleNoteId        : UUID
    private(set) var simpleNoteTitle     : String
    private(set) var simpleNoteText      : String
    private(set) var simpleNoteTimeStamp : Int64
    
    init(simpleNoteTitle:String, simpleNoteText:String, simpleNoteTimeStamp:Int64) {
        self.simpleNoteId        = UUID()
        self.simpleNoteTitle     = simpleNoteTitle
        self.simpleNoteText      = simpleNoteText
        self.simpleNoteTimeStamp = simpleNoteTimeStamp
    }

    init(simpleNoteId: UUID, simpleNoteTitle:String, simpleNoteText:String, simpleNoteTimeStamp:Int64) {
        self.simpleNoteId        = simpleNoteId
        self.simpleNoteTitle     = simpleNoteTitle
        self.simpleNoteText      = simpleNoteText
        self.simpleNoteTimeStamp = simpleNoteTimeStamp
    }
}
