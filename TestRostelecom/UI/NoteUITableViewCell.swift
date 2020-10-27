//
//  SimpleNoteListCellView.swift
//  TestRostelecom
//
//  Created by Савченко Максим Олегович on 2020. 10.27..
//  Copyright © 2020. Савченко Максим Олегович. All rights reserved.
//

import UIKit

final class SimpleNoteUITableViewCell : UITableViewCell {
    private(set) var simpleNoteTitle : String = ""
    private(set) var simpleNoteText  : String = ""
    private(set) var simpleNoteDate  : String = ""
 
    @IBOutlet weak var simpleNoteTitleLabel: UILabel!
    @IBOutlet weak var simpleNoteTextLabel: UILabel!
    @IBOutlet weak var simpleNoteDateLabel: UILabel!
}
