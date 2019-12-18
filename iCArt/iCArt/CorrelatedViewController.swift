

import UIKit
import AVFoundation


class CorrelatedViewController: UIViewController
{

    @IBOutlet weak var corByAuthor1: UIImageView!
    @IBOutlet weak var corByAuthor2: UIImageView!
    @IBOutlet weak var corByAuthor3: UIImageView!
    @IBOutlet weak var corByDate1: UIImageView!
    @IBOutlet weak var corByDate2: UIImageView!
    @IBOutlet weak var corByDate3: UIImageView!
    @IBOutlet weak var corByAuthorName1: UILabel!
    @IBOutlet weak var corByAuthorName2: UILabel!
    @IBOutlet weak var corByAuthorName3: UILabel!
    @IBOutlet weak var corByDateName1: UILabel!
    @IBOutlet weak var corByDateName2: UILabel!
    @IBOutlet weak var corByDateName3: UILabel!
    static var toFavorites : Bool = true;
    var speecher = AVSpeechSynthesizer();
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionPerformed));
        leftSwipe.direction = .left;
        self.view.addGestureRecognizer(leftSwipe);
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionPerformed));
        downSwipe.direction = .down;
        self.view.addGestureRecognizer(downSwipe);
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionPerformed));
        upSwipe.direction = .up;
        self.view.addGestureRecognizer(upSwipe);
        
        //setting the images
        corByAuthor1.image = UIImage(named: "cor1");
        corByAuthor1.layer.cornerRadius = 45
        corByAuthor1.layer.masksToBounds = true
        corByAuthor2.image = UIImage(named: "cor2");
        corByAuthor2.layer.cornerRadius = 45
        corByAuthor2.layer.masksToBounds = true
        corByAuthor3.image = UIImage(named: "cor3");
        corByAuthor3.layer.cornerRadius = 45
        corByAuthor3.layer.masksToBounds = true
        corByDate1.image = UIImage(named: "corDate1");
        corByDate1.layer.cornerRadius = 45
        corByDate1.layer.masksToBounds = true
        corByDate2.image = UIImage(named: "corDate2");
        corByDate2.layer.cornerRadius = 45
        corByDate2.layer.masksToBounds = true
        corByDate3.image = UIImage(named: "corDate3");
        corByDate3.layer.cornerRadius = 45
        corByDate3.layer.masksToBounds = true
        //setting the names
        corByAuthorName1.text = "Water lilies, 1916";
        corByAuthorName2.text = "Saint-Georges major dusk";
        corByAuthorName3.text = "Poppies";
        corByDateName1.text = "The Magpie"
        corByDateName2.text = "Saint-Lazare station";
        corByDateName3.text = "Impression, Rising Sun";
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapActionPerfomed));
        tapGesture.numberOfTapsRequired = 1;
        self.view.addGestureRecognizer(tapGesture);
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler))
        doubleTapRecognizer.numberOfTapsRequired = 2;
        self.view.addGestureRecognizer(doubleTapRecognizer);
        
        tapGesture.require(toFail: doubleTapRecognizer);
        tapGesture.delaysTouchesBegan = true;
        doubleTapRecognizer.delaysTouchesBegan = true;
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
    
    @objc func doubleTapHandler(_ sender: UITapGestureRecognizer)
    {
        if (sender.state == .ended)
        {
            CoreDataController.addFavorite(imagePath: (HomeScreenViewController.painting?.image)!, title: (HomeScreenViewController.painting?.name)!, author: (HomeScreenViewController.painting?.author)!);
        }
    }
    
    @objc func swipeActionPerformed(_ sender: UISwipeGestureRecognizer)
    {
        switch(sender.direction)
        {
            case .left:
               
                 speecher.stopSpeaking(at: AVSpeechBoundary.immediate);
                performSegue(withIdentifier: "InternettoEmotional", sender: self);
            case .down:
                speecher.stopSpeaking(at: AVSpeechBoundary.immediate);
                CorrelatedViewController.toFavorites = true;
                EmotionalDescriptionViewController.fromEmotional = false;
                HomeScreenViewController.toFavorites = false;
                performSegue(withIdentifier: "correlatedToFavorites", sender: self);
        case .up:
            
           speecher.stopSpeaking(at: AVSpeechBoundary.immediate);
            performSegue(withIdentifier: "backfrom1", sender: self)
            default:
                break;
        }
    }

}
