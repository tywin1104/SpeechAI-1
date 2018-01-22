//
//  RecordedAudioFile.swift
//  SpeechAI
//
//  Created by James Park on 2018-01-22.
//  Copyright © 2018 Speak. All rights reserved.
//

import Foundation


internal struct RecordedAudioParser {
   static func parse (with json: JSON) -> RecordedAudio? {
        guard
            let audioURL = json["url"] as? String,
            let audioData = json["data"] as? JSON,
            let score = audioData["score"] as? Double else {
                return nil
        }

        var recordedAudio = RecordedAudio()

        recordedAudio.audioFile = audioURL
        recordedAudio.score = round(score*100)

        return recordedAudio
    }


    static func parseListOfRecordedAudios (with jsonArray: [JSON]) -> [RecordedAudio] {
        var listOfRecordedAudio = [RecordedAudio]()
        for value in jsonArray {

            guard let aRecordedAudio = RecordedAudioParser.parse(with: value) else {
                    continue
            }

            listOfRecordedAudio.append(aRecordedAudio)
        }

        return listOfRecordedAudio
    }
    
}
