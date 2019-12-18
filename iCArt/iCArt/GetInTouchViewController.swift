

import UIKit
import CoreLocation
import CoreBluetooth
import AudioToolbox
import AVFoundation

class GetInTouchViewController: UIViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate
{
    var speecher = AVSpeechSynthesizer();
    var locationManager: CLLocationManager!;
    var bluetoothPeripheralManager: CBPeripheralManager!;
    var flagb0 = false;
    var beaconRegion: CLBeaconRegion!;
    var oldState: Int = 0;
    var newState: Int = 0;
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapActionPerfomed));
        tapGesture.numberOfTapsRequired = 1;
        self.view.addGestureRecognizer(tapGesture);
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        requestLocationInUse();
        
        let options = [CBCentralManagerOptionShowPowerAlertKey:0]
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
    }

    func requestLocationInUse()
    {
        locationManager.requestAlwaysAuthorization()
        switch CLLocationManager.authorizationStatus()
        {
            case .notDetermined:
                break;
            case .restricted, .denied:
                self.openAlertToSettings(title: "Location in use disabled",
                                         description: "To enable the location change it in Settings.", bluetooth: true);
                break;
            case .authorizedWhenInUse, .authorizedAlways:
                break
            default:
                    break;
        }
    }
    
    private func openAlertToSettings(title: String, description: String, bluetooth: Bool)
    {
        let alertController = UIAlertController(
            title: title,
            message: description,
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default)
        { (action) in
            if bluetooth
            {
                if let url = URL(string:"App-Prefs:root=Bluetooth")
                {
                    UIApplication.shared.open(url)
                }
            }
            else
            {
                if let url = URL(string:UIApplication.openSettingsURLString)
                {
                    UIApplication.shared.open(url)
                }
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        locationManager.requestAlwaysAuthorization()
        switch status
        {
            case .notDetermined:
                print("Location: Not determined");
                break;
            case .restricted:
                print("Location: Restricted");
                self.openAlertToSettings(title: "Location in use disabled", description: "To enable the location change it in Settings.", bluetooth: false);
                break;
            case .denied:
                print("Location: Denied");
                self.openAlertToSettings(title: "Location in use disabled", description: "To enable the location change it in Settings.", bluetooth: false);
                break;
            case .authorizedWhenInUse:
                print("Location: Authorized when in use");
                break;
            case .authorizedAlways:
                print("Location: Authorized always");
                if (CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self))
                {
                    if (CLLocationManager.isRangingAvailable())
                    {
                        startScanning();
                    }
                }
                break;
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager)
    {
        switch (peripheral.state)
        {
            case CBManagerState.poweredOn:
                print("Bluetooth Status: Turned On");
                break;
            case CBManagerState.poweredOff:
                print("Bluetooth Status: Turned Off");
                self.openAlertToSettings(title: "Bluetooth is disabled. Activate it using Siri", description: "", bluetooth: true);
            case CBManagerState.resetting:
                print("Bluetooth Status: Resetting");
            case CBManagerState.unauthorized:
                print("Bluetooth Status: Not Authorized");
            case CBManagerState.unsupported:
                print("Bluetooth Status: Not Supported");
            default:
                print("Bluetooth Status: Unknown");
        }
    }
    
    func startScanning()
    {
        //B9407F30-F5F8-466E-AFF9-25556B57FE6D MIN 23763 MAJ 27161
       // let uuid = UUID(uuidString: "A5930908-19ED-49EB-821E-180DB7A60C20")!; maj 1, minor 12
        // let uuidb2 = UUID(uuidString: )!
        // let uuidb3 = UUID(uuidString: )!
        let uuid = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
        beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 27161, minor: 23763, identifier: "iOSBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion)
    {
        if (beacons.count > 0)
        {
            print("trovato qualcosa")
            newState = beacons[0].proximity.rawValue
            if(newState != oldState)
            {
                oldState = newState
                if (newState == 1)
                {
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    locationManager.stopMonitoring(for: beaconRegion)
                    locationManager.stopRangingBeacons(in: beaconRegion)
                    performSegue(withIdentifier: "vibrated", sender: self);
                    //stoppo la ricerca perché il beacon perde e riprende il segnale continuamente quindi la notifica viene mostrata piu volte.
                    //In questo modo invece, dopo che la notifica è stata mostrata, il beacon smette di essere visto quindi non viene rimostrata.
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//
//Per piu beacon: utilizzare questo costruttore
//let uuid = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
//// let uuidb2 = UUID(uuidString: )!
//// let uuidb3 = UUID(uuidString: )!
//beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "iOSBeacon")
//locationManager.startMonitoring(for: beaconRegion)
//locationManager.startRangingBeacons(in: beaconRegion)
//
//if beacons.count > 0 {
//    print("trovato qualcosa \(i)")
//    i = i + 1
//    let nearestBeacons = beacons.first!
//    updateDistance(nearestBeacons.proximity)
//    newState = nearestBeacons.proximity.rawValue
//
//    let major = CLBeaconMajorValue(nearestBeacons.major)
//    let minor = CLBeaconMinorValue(nearestBeacons.minor)
//    newMinor = minor
//
//    if( newMinor != oldMinor) {
//        //oldState = newState
//        oldMinor = newMinor
//        if newState == 1 {
//            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//            //                    locationManager.stopMonitoring(for: beaconRegion)
//            //                               locationManager.stopRangingBeacons(in: beaconRegion)
//            //
//            //stoppo la ricerca perché il beacon perde e riprende il segnale continuamente quindi la notifica viene mostrata piu volte.
//            //In questo modo invece, dopo che la notifica è stata mostrata, il beacon smette di essere visto quindi non viene rimostrata.
//
//            showNotifica(major: major, minor: minor)
//        }
//    }
//
//} else {
//    updateDistance(.unknown)
//}
//
// il major sarà uguale per tutti i beacon, ed il minor identifica il singolo, quindi si fanno controlli del tipo:
//func showNotifica(major: UInt16, minor: UInt16){
//
//    if major == 27161 && minor == 11
//    {
//        text1.text = "Beacon Menta"
//        print("Menta")
//
//    }else if major == 27161 && minor == 12 {
//        text1.text = "Beacon Mirtillo"
//        print("Mirtillo")
//    }else if major == 27161 && minor == 23763 {
//        text1.text = "Beacon Gelato Marshmallow"
//    }
//
//
//}
 
 

