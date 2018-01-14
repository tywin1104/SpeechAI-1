//
//  Feedback.swift
//  SpeechAI
//
//  Created by James Park on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//

import Foundation


class Feedback {

    var wpm = 0.0
    var similarity = 0.0
    var pausing = ""
    var loudness = ""
    var score = 0.0
    var pastData = PastFeedback()

    var StartingSent = ""
    var WPMSent = ""
    var SimSent = ""
    var LoudSent = ""
    var PausSent = ""
    var overallSent = ""

    init(){

    }
}
