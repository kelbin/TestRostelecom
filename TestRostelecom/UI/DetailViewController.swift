//
//  DetailViewController.swift
//  TestRostelecom
//
//  Created by Савченко Максим Олегович on 2020. 10.27..
//  Copyright © 2020. Савченко Максим Олегович. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {

    @IBOutlet weak var simpleNoteTitleLabel: UILabel!
    @IBOutlet weak var simpleNoteTextTextView: UITextView!
    @IBOutlet weak var simpleNoteDate: UILabel!
    
    func configureView() {
        
        if let detail = detailItem {
            if let topicLabel = simpleNoteTitleLabel,
               let dateLabel = simpleNoteDate,
               let textView = simpleNoteTextTextView {
                topicLabel.text = detail.simpleNoteTitle
                dateLabel.text = SimpleNoteDateHelper.convertDate(date: Date.init(seconds: detail.simpleNoteTimeStamp))
                textView.text = detail.simpleNoteText
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    var detailItem: SimpleNote? {
        didSet {
            configureView()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChangeSimpleNoteSegue" {
            let changeSimpleNoteViewController = segue.destination as! SimpleNoteCreateChangeViewController
            if let detail = detailItem {
                changeSimpleNoteViewController.setChangingSimpleNote(
                    changingSimpleNote: detail)
            }
        }
    }
}

