//
//  ViewController.swift
//  dabTimer3.0
//
//  Created by Justin Reed on 9/29/17.
//  Copyright © 2017 RD concepts. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import GoogleMobileAds

class ViewController: UIViewController {
    
    //Google Adwords
    
    @IBOutlet weak var GoogleBannerView: GADBannerView!
    
    
    
    
    
    
    
    
    
    var audioPlayer = AVAudioPlayer()
    //Adjust heatUpSeconds and coolDownSeconds to user defaults
    var heatUpSeconds = 20
    var coolDownSeconds = 50
    var heatUpTimer = Timer()
    var coolDownTimer = Timer()
    
    
    @IBOutlet weak var heatUpLabel: UILabel!
    @IBOutlet weak var coolDownLabel: UILabel!
    
    @IBOutlet weak var heatUpStepperOutlet: UIStepper!
    @IBAction func heatUpStepper(_ sender: UIStepper) {
        heatUpSeconds = Int(sender.value)
        heatUpLabel.text = String(heatUpSeconds)
        
        UserDefaults.standard.set(heatUpLabel.text, forKey: "heatUpSeconds")
    }
    
    @IBOutlet weak var coolDownStepperOutlet: UIStepper!
    @IBAction func coolDownStepper(_ sender: UIStepper) {
        coolDownSeconds = Int(sender.value)
        coolDownLabel.text = String(coolDownSeconds)
        
        UserDefaults.standard.set(coolDownLabel.text, forKey: "coolDownSeconds")
    }
    
    
    @IBOutlet weak var startOutlet: UIButton!
    @IBAction func start(_ sender: Any) {
        heatUpSeconds = Int(heatUpLabel.text!)!
        coolDownSeconds = Int(coolDownLabel.text!)!
        heatUpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.heatUpCounter), userInfo: nil, repeats: true)
        
        coolDownStepperOutlet.isHidden = true
        heatUpStepperOutlet.isHidden = true
        startOutlet.isHidden = true
    }
    
    func coolDownCounter() {
        coolDownSeconds -= 1
        coolDownLabel.text = String(coolDownSeconds)
        
        if coolDownSeconds == 0 {
            coolDownTimer.invalidate()
            audioPlayer.play()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            //for _ in 1...3 {
            //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            //    sleep(1)
            //}
            //TODO FEEDBACK ask Dabman for feedback if users should have to hit the reset button to make the rest of the buttons apear
            //coolDownStepperOutlet.isHidden = false
            //heatUpStepperOutlet.isHidden = false
            //startOutlet.isHidden = false
        }
    }
    
    func heatUpCounter() {
        heatUpSeconds -= 1
        heatUpLabel.text = String(heatUpSeconds)
        
        if (heatUpSeconds == 0) {
            heatUpTimer.invalidate()
            audioPlayer.play()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            coolDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.coolDownCounter), userInfo: nil, repeats: true)
        }
    }
    
    
    @IBOutlet weak var stopOutlet: UIButton!
    @IBAction func reset(_ sender: Any) {
        //cool down reset
        coolDownTimer.invalidate()
        if let y = UserDefaults.standard.object(forKey: "coolDownSeconds") as? String {
            coolDownSeconds = Int(y)!
            coolDownLabel.text = String(coolDownSeconds)
            coolDownStepperOutlet.value = Double(coolDownSeconds)
        } else {

        coolDownSeconds = 50
        coolDownLabel.text = String(coolDownSeconds)
        coolDownStepperOutlet.value = Double(coolDownSeconds)
        }
        
        
        //heatup reset
        heatUpTimer.invalidate()
        if let x = UserDefaults.standard.object(forKey: "heatUpSeconds") as? String {
            heatUpSeconds = Int(x)!
            heatUpLabel.text = String(heatUpSeconds)
            heatUpStepperOutlet.value = Double(heatUpSeconds)
        } else {
            heatUpSeconds = 20
            heatUpLabel.text = String(heatUpSeconds)
            heatUpStepperOutlet.value = Double(heatUpSeconds)
                }
        
        
        audioPlayer.stop()
        coolDownStepperOutlet.isHidden = false
        heatUpStepperOutlet.isHidden = false
        startOutlet.isHidden = false
   
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // google Adwords
        GoogleBannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        GoogleBannerView.rootViewController = self
        GoogleBannerView.load(GADRequest())
        
        
        
        do {
            let audioPath = Bundle.main.path(forResource: "text_notification", ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }
        catch {
            //ERROR
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "heatUpSeconds") as? String {
            heatUpLabel.text = x
            //set the stepper value to the label value
            heatUpStepperOutlet.value = Double(x)!
        } else{
            heatUpStepperOutlet.value = 20.0
        }
        
        
        if let y = UserDefaults.standard.object(forKey: "coolDownSeconds") as? String {
            coolDownLabel.text = y
            
            //set the stepper value to the label value
            coolDownStepperOutlet.value = Double(y)!
            
        } else {
           coolDownStepperOutlet.value = 50.0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

