//
//  ViewController3.swift
//  words_french
//
//  Created by Yuriy Zinkovets on 04.04.2018.
//  Copyright © 2018 Yuriy Zinkovets. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewController3 : UIViewController{
    @IBOutlet var words_french : UILabel!
    @IBOutlet var words_russian : UILabel!
    public var preText : String = ""
    public var preTextRu : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        words_french.text = preText
        words_russian.text = preTextRu
    }
}
