//
//  File.swift
//  Pitch Perfect
//
//  Created by Ian Kennedy on 10/20/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(inputFilePathUrl: NSURL, inputTitle: String) {
        filePathUrl = inputFilePathUrl
        title = inputTitle
    }
    
}