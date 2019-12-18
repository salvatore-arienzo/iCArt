
import UIKit
import AVFoundation

class WelcomeViewController: UIViewController
{
    var speecher = AVSpeechSynthesizer();
    override func viewDidLoad()
    {
        super.viewDidLoad()
        speech();
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeActionPerformed));
        leftSwipe.direction = .left;
        self.view.addGestureRecognizer(leftSwipe);
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapActionPerfomed));
        tapGesture.numberOfTapsRequired = 1;
        self.view.addGestureRecognizer(tapGesture);
    }
    
    
    @objc func leftSwipeActionPerformed(gesture: UISwipeGestureRecognizer)
    {
        if gesture.direction == .left
        {
            speecher.stopSpeaking(at: AVSpeechBoundary.immediate);
            performSegue(withIdentifier: "WelcomeToPainting", sender: self)
        }
        
    }

    func speech()
    {
        var stringsToSpeech : Array<String> = Array();
        var textElemets = self.view.subviews.filter({$0 is UILabel});
        for element in textElemets
        {
            if (element is UILabel)
            {
                stringsToSpeech.append((element as! UILabel).text!);
            }
            else if (element is UITextView)
            {
                stringsToSpeech.append((element as! UITextView).text!);
            }
        }
        
        (TextToSpeecher(stringsToSpeech: stringsToSpeech, synth : speecher)).textToSpeech();
    }
  
    @objc func tapActionPerfomed(_ sender: UITapGestureRecognizer)
    {
        if(sender.state == .ended)
        {
            speech();
        }
    }

}
