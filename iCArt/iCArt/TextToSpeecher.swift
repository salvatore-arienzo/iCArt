//
//  textToSpeecher.swift
//  iCArt
//
//  Copyright © 2019 team_7.6. All rights reserved.
//

import UIKit
import AVFoundation

public class TextToSpeecher
{
    //strings to be spoken
    var stringsToSpeech : [String];
    //Synthetizer
    var speechSynthetizer : AVSpeechSynthesizer;
    
    //initializator
    init (stringsToSpeech: [String], synth : AVSpeechSynthesizer)
    {
        self.stringsToSpeech = stringsToSpeech;
        self.speechSynthetizer = synth;
    }
    
    //method that speech the strings
    @IBAction func textToSpeech()
    {
        for s in stringsToSpeech
        {
            let speechUtterence = AVSpeechUtterance(string: s);
            speechUtterence.rate = 0.5;
            speechSynthetizer.speak(speechUtterence);
        }
    }
}
