

import UIKit
import AVFoundation

class EmotionalDescriptionViewController: UIViewController
{

    @IBOutlet weak var emotionalTextArea: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    var synthetizer = AVSpeechSynthesizer();
    var player : AVAudioPlayer?;
    static var fromEmotional : Bool = true;
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emotionalTextArea.text = "The painting depicts a Japanese bridge over a pond, filled with lilies and surrounded by plants. The colors used are pastels, and the brush strokes are delicate, evoking a peaceful image. The bridge is cut off at the sides, making it seems as if it’s floating above the pond. This contributes to the dream like feeling it evokes. The sky is barely suggested, but it appears to be early morning, or late afternoon. The pond is completely covered in lilies, depicted with horizontal strokes. Meanwhile the background plants are depicted with vertical strokes, in green and yellow.";
        emotionalTextArea.isUserInteractionEnabled = false;
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapActionPerformed));
        tapGesture.numberOfTapsRequired = 1;
        self.view.addGestureRecognizer(tapGesture);
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionPerformed));
        rightSwipe.direction = .right;
        self.view.addGestureRecognizer(rightSwipe);
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action:#selector(swipeActionPerformed));
        downSwipe.direction = .down;
        self.view.addGestureRecognizer(downSwipe);
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionPerformed));
        upSwipe.direction = .up;
        self.view.addGestureRecognizer(upSwipe);
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler))
        doubleTapRecognizer.numberOfTapsRequired = 2;
        self.view.addGestureRecognizer(doubleTapRecognizer);
        
        tapGesture.require(toFail: doubleTapRecognizer);
        tapGesture.delaysTouchesBegan = true;
        doubleTapRecognizer.delaysTouchesBegan = true;
    }
    
    @objc func swipeActionPerformed(_ sender: UISwipeGestureRecognizer)
    {
        switch sender.direction
        {
            case .right:
                synthetizer.stopSpeaking(at: AVSpeechBoundary.immediate);
                player?.stop();
                performSegue(withIdentifier: "emotionalToInternet", sender: self);
            case .down:
                synthetizer.stopSpeaking(at: AVSpeechBoundary.immediate);
                player?.stop();
                EmotionalDescriptionViewController.fromEmotional = true;
                CorrelatedViewController.toFavorites = false;
                HomeScreenViewController.toFavorites = false;
                performSegue(withIdentifier: "toFavorites", sender: self);
        case .up:
            synthetizer.stopSpeaking(at: AVSpeechBoundary.immediate);
            HomeScreenViewController.toFavorites = true;
            EmotionalDescriptionViewController.fromEmotional = false;
            CorrelatedViewController.toFavorites = false;
            performSegue(withIdentifier: "backfrom1", sender: self)
            default:
                break;
        }
        
    }
    
    @objc func doubleTapHandler(_ sender: UITapGestureRecognizer)
    {
        if (sender.state == .ended)
        {
            CoreDataController.addFavorite(imagePath: (HomeScreenViewController.painting?.image)!, title: (HomeScreenViewController.painting?.name)!, author: (HomeScreenViewController.painting?.author)!);
        }
    }
    
    @objc func tapActionPerformed(_ sender: UITapGestureRecognizer)
    {
        if(sender.state == .ended)
        {
            var stringsToSpeech : Array<String> = Array();
            stringsToSpeech.append(titleLabel.text!);
            stringsToSpeech.append(emotionalTextArea.text!);
            playSound();
            (TextToSpeecher(stringsToSpeech: stringsToSpeech, synth: synthetizer)).textToSpeech();
        }
    }
    
    func playSound()
    {
        guard
            let path = Bundle.main.path(forResource: "1 Hour Nature Sounds-Relax-Birds Singing-Vogelgesang-le chant des oiseaux-Bird Song-[AudioTrimmer.com].mp3", ofType: nil)
            else
        {
            print ("URL not found");
            return
        }
        do
        {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            let url = URL(fileURLWithPath: path)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard
                let player = player
                else
            {
                return
            }
            player.setVolume(0.3, fadeDuration: 0.5)
            player.play()
            
        }
        catch let error
        {
            print(error.localizedDescription)
        }
    }

}
