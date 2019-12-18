//
//  ViewController.swift
//  iCArt
//
//  Copyright © 2019 team_7.6. All rights reserved.
//

import UIKit
import AVFoundation

class HomeScreenViewController: UIViewController
{

    var pictureName: String?;
    var pictureAuthor: String?;
    var speechSynthetizer = AVSpeechSynthesizer();
    static var toFavorites : Bool = true;
    @IBOutlet weak var nearImage: UIImageView!
    @IBOutlet weak var nearLabel: UILabel!
    @IBOutlet weak var titleAuthorLabel: UILabel!
    @IBOutlet weak var swipeInstructionLabel: UILabel!
    static var painting : (image: String, name: String?, author: String?)?;
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //initializing the attributes. Note: it will be changed using the beacon
        self.pictureAuthor = "Claude Monet";
        self.pictureName = "Waterlily pond, green harmony";
        
        //setting the central image of the picture the user is near
        let image : UIImage = UIImage (named: "armonia verde")!;
        nearImage.image = image;
        HomeScreenViewController.painting = ("armonia verde", self.pictureName, self.pictureAuthor);
        //setting the text that will be showed when the user is near a certain picture
        nearLabel.text = "You are in proximity of:";
        titleAuthorLabel.text = "\(self.pictureName!), by \(self.pictureAuthor!)";
        swipeInstructionLabel.text = "Swipe left or right for more information";
        
        //preparing swipe actions
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionPerformed));
        leftSwipe.direction = .left;
        self.view.addGestureRecognizer(leftSwipe);
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionPerformed));
        rightSwipe.direction = .right;
        self.view.addGestureRecognizer(rightSwipe);
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionPerformed));
        downSwipe.direction = .down;
        self.view.addGestureRecognizer(downSwipe);
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionPerformed));
        upSwipe.direction = .up;
        self.view.addGestureRecognizer(upSwipe);
        
        //preparing tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapActionPerformed));
        tapGesture.numberOfTapsRequired = 1;
        self.view.addGestureRecognizer(tapGesture);
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler))
        doubleTapRecognizer.numberOfTapsRequired = 2;
        self.view.addGestureRecognizer(doubleTapRecognizer);
        
        
        tapGesture.require(toFail: doubleTapRecognizer);
        tapGesture.delaysTouchesBegan = true;
        doubleTapRecognizer.delaysTouchesBegan = true;
        
      
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
   
        
    
    @objc func doubleTapHandler(_ sender: UITapGestureRecognizer)
    {
        if (sender.state == .ended)
        {
            CoreDataController.addFavorite(imagePath: (HomeScreenViewController.painting?.image)!, title: (HomeScreenViewController.painting?.name)!, author: (HomeScreenViewController.painting?.author)!);
        }
    }
    
    @objc func swipeActionPerformed(sender: UISwipeGestureRecognizer)
    {
        switch(sender.direction)
        {
            case .right:
                speechSynthetizer.stopSpeaking(at: AVSpeechBoundary.immediate)
                performSegue(withIdentifier: "rightSwipe", sender: self)
            case .left:
                speechSynthetizer.stopSpeaking(at: AVSpeechBoundary.immediate)
                performSegue(withIdentifier: "leftSwipe", sender: self)
            case .down:
                //Connecting the favorites view
                speechSynthetizer.stopSpeaking(at: AVSpeechBoundary.immediate)
                HomeScreenViewController.toFavorites = true;
                EmotionalDescriptionViewController.fromEmotional = false;
                CorrelatedViewController.toFavorites = false;
                performSegue(withIdentifier: "swipeDown", sender: self)
            case .up:
                speechSynthetizer.stopSpeaking(at: AVSpeechBoundary.immediate)
                HomeScreenViewController.toFavorites = true;
                EmotionalDescriptionViewController.fromEmotional = false;
                CorrelatedViewController.toFavorites = false;
                performSegue(withIdentifier: "backfrom1", sender: self)
            
            default:
                break;
        }
    }
        
    @objc func tapActionPerformed(sender: UITapGestureRecognizer)
    {
        if (sender.state == .ended)
        {
            //getting text elements into the view
            var stringsToSpeech : Array<String> = Array();
            let textElemets = self.view.subviews.filter({$0 is UILabel});
            for element in textElemets
            {
                stringsToSpeech.append((element as! UILabel).text!);
            }
            //creating a speecher object and speeching the text
            (TextToSpeecher(stringsToSpeech: stringsToSpeech, synth: speechSynthetizer)).textToSpeech();
        }
    }
    
}

