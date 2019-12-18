

import UIKit

class TurnVoiceoverOffViewController: UIViewController
{
    let launchedBefore = UserDefaults.standard.bool(forKey: "hasLaunched")
    let launchStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
    var vc: UIViewController?
//    var window: UIWindow?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapActionPerformed));
        tapGesture.numberOfTouchesRequired = 1;
        self.view.addGestureRecognizer(tapGesture);
        // Do any additional setup after loading the view.
    }
    
    @objc func tapActionPerformed(_ sender: UITapGestureRecognizer)
    {
        
        if (sender.state == .ended)
        {
            if (!UIAccessibility.isVoiceOverRunning)
            {
                if launchedBefore {
                    performSegue(withIdentifier: "afterVoiceoverOff", sender: self);
                }else{
                    
                    vc = launchStoryboard.instantiateViewController(withIdentifier: "WelcomeStoryboard")
                    UserDefaults.standard.set(true, forKey: "hasLaunched")
                    UserDefaults.standard.set(false, forKey: "hasActive")
                    present(vc!, animated: true, completion: nil)
//                    self.window?.rootViewController = vc
//                    self.window?.makeKeyAndVisible()
                
                }
            }
        }
    }
//    override func viewWillAppear(_ animated: Bool)
//    {
//        if (!UIAccessibility.isVoiceOverRunning)
//        {
//            UserDefaults.standard.set(false, forKey: "hasActive")
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
