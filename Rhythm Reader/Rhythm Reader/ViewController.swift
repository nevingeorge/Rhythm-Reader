//
//  ViewController.swift
//  Rhythm Reader
//
//  Created by Nevin George on 4/24/18.
//  Copyright © 2018 Nevin George. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var viewLines: UIView!
    @IBOutlet weak var percussionLine1: UIImageView!
    @IBOutlet weak var pLine2: UIImageView!
    @IBOutlet weak var linesStackView: UIStackView!
    private var beats = [Double]()
    var beat: AVAudioPlayer = AVAudioPlayer()
    var size = 0
    var tempo = 120
    var posx = 55
    var posy = 0
    var curTag = 1
    var cursorPos = 0
    var pLineTag = 10000
    @IBOutlet weak var cursor: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let musicFile = Bundle.main.path(forResource: "UpdateBeat", ofType: "mp3")
        do {
            try beat = AVAudioPlayer(contentsOf: URL (fileURLWithPath: musicFile!))
        }
        catch {
            print(error)
        }
    
        posy = Int(percussionLine1.frame.origin.y) + 47
        percussionLine1.tag = pLineTag
        pLineTag = pLineTag + 1
        pLine2.tag = pLineTag
        pLineTag = pLineTag + 1
        cursor.frame = CGRect(x: 46, y: posy, width: 3, height: 23)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func reset(_ sender: UIButton) {
        
        let refreshAlert = UIAlertController(title: "Reset", message: "Are you sure you want to reset?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.beats.removeAll()
            self.size = 0
            
            for view in self.linesStackView.subviews {
                if(!(view.tag == 10000)&&(!(view.tag == 10001))){
                    view.removeFromSuperview()
                    self.pLineTag = self.pLineTag - 1
                }
            }
            
            for view in self.viewLines.subviews {
                if(!(view.tag == -1)){
                    view.removeFromSuperview()
                }
            }
            
            self.posx = 51
            self.posy = Int(self.percussionLine1.frame.origin.y) + 47
            
            self.cursor.frame = CGRect(x: 46, y: self.posy, width: 3, height: 23)
            self.cursorPos = 0
            
            self.curTag = 1
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }

    func resetD() {
        
        self.size = 0
        
        for view in self.linesStackView.subviews {
            if(!(view.tag == 10000)&&(!(view.tag == 10001))){
                view.removeFromSuperview()
                self.pLineTag = self.pLineTag - 1
            }
        }
        
        for view in self.viewLines.subviews {
            if(!(view.tag == -1)){
                view.removeFromSuperview()
            }
        }
        
        self.posx = 51
        self.posy = Int(self.percussionLine1.frame.origin.y) + 47
        
        self.cursor.frame = CGRect(x: 46, y: self.posy, width: 3, height: 23)
        self.cursorPos = 0
        
        self.curTag = 1
        
    }
    
    @IBAction func deleteLast(_ sender: UIButton) {
    
        if(cursorPos>0){
            
            let tempCur = cursorPos
            
            resetD()

            for (index,element) in beats.enumerated() {
                
                if(!(index==tempCur-1)){
                    
                    if(element==4){
                        wholeNote(nil)
                    }
                    else if(element==2){
                        halfNote(nil)
                    }
                    else if(element==1){
                        quarterNote(nil)
                    }
                    else if(element==0.5){
                        eighthNote(nil)
                    }
                    else if(element==0.25){
                        sixteenthNote(nil)
                    }
                    beats.removeLast()
                    
                }
                
            }
            
            beats.remove(at: tempCur-1)

            cursorPos = tempCur - 1
            if(cursorPos==0){
                
                cursor.frame = CGRect(x: 46, y: Int(percussionLine1.frame.origin.y) + 47, width: 3, height: 23)
                
            }
            else {
                
                let imageTag = viewLines.viewWithTag(cursorPos)
                let x = Int(imageTag!.frame.maxX)
                var y = 0
                if((Int(imageTag!.frame.origin.y)-(Int(percussionLine1.frame.origin.y) + 47))%70==0){
                    let temp = ((Int(imageTag!.frame.origin.y))-(Int(percussionLine1.frame.origin.y) + 47))/70
                    let pImageTag = viewLines.viewWithTag(10000+temp)
                    y = Int(pImageTag!.frame.origin.y)
                }
                else if((Int(imageTag!.frame.origin.y)-(Int(percussionLine1.frame.origin.y) + 47 - 42))%70==0){
                    let temp = ((Int(imageTag!.frame.origin.y))-(Int(percussionLine1.frame.origin.y) + 47))/70
                    let pImageTag = viewLines.viewWithTag(10000+temp)
                    y = Int(pImageTag!.frame.origin.y)
                }
                cursor.frame = CGRect(x: x + 5, y: y + 47, width: 3, height: 23)
                
            }
            
        }

    }
    
    @IBAction func wholeNote(_ sender: UIButton?) {
        
        beats.append(4)
        size = size + 1
        
        let image = UIImage(named: "Whole Note.png")
        let imageView = UIImageView(image: image)
        imageView.tag = curTag
        curTag = curTag + 1
        imageView.tintColor = .black
        viewLines.addSubview(imageView)

        let width = Int(image!.size.width * image!.scale)
        let height = Int(image!.size.height * image!.scale)
        
        imageView.frame = CGRect(x: posx, y: posy, width: width, height: height)
        posx = posx + 51
        
        if(posx+80>=Int(percussionLine1.bounds.size.width)) {
            posx = 51
            posy = posy + 70
            
            if(posy>85){
                let image = UIImage(named: "percussionLine.png")
                let imageView = UIImageView(image: image)
                imageView.tag = pLineTag
                pLineTag = pLineTag + 1
                linesStackView.addArrangedSubview(imageView)
            }
        }
        
    }
    
    @IBAction func halfNote(_ sender: UIButton?) {
        
        beats.append(2)
        size = size + 1
        
        let image = UIImage(named: "Half Note.png")
        let imageView = UIImageView(image: image)
        imageView.tag = curTag
        curTag = curTag + 1
        imageView.tintColor = .black
        viewLines.addSubview(imageView)
        
        let width = Int(image!.size.width * image!.scale)
        let height = Int(image!.size.height * image!.scale)
        
        imageView.frame = CGRect(x: posx, y: posy-42, width: width, height: height)
        posx = posx + 51
        
        if(posx+80>=Int(percussionLine1.bounds.size.width)) {
            posx = 51
            posy = posy + 70
            
            if(posy>85){
                let image = UIImage(named: "percussionLine.png")
                let imageView = UIImageView(image: image)
                imageView.tag = pLineTag
                pLineTag = pLineTag + 1
                linesStackView.addArrangedSubview(imageView)
            }
        }
        
    }
    
    @IBAction func quarterNote(_ sender: UIButton?) {
        
        beats.append(1)
        size = size + 1
        
        let image = UIImage(named: "Quarter Note.png")
        let imageView = UIImageView(image: image)
        imageView.tag = curTag
        curTag = curTag + 1
        imageView.tintColor = .black
        viewLines.addSubview(imageView)
        
        let width = Int(image!.size.width * image!.scale)
        let height = Int(image!.size.height * image!.scale)
        
        imageView.frame = CGRect(x: posx, y: posy-42, width: width, height: height)
        posx = posx + 51
        
        if(posx+80>=Int(percussionLine1.bounds.size.width)) {
            posx = 51
            posy = posy + 70
            
            if(posy>85){
                let image = UIImage(named: "percussionLine.png")
                let imageView = UIImageView(image: image)
                imageView.tag = pLineTag
                pLineTag = pLineTag + 1
                linesStackView.addArrangedSubview(imageView)
            }
        }
        
    }
    
    
    @IBAction func eighthNote(_ sender: UIButton?) {
        
        beats.append(0.5)
        size = size + 1
        
        let image = UIImage(named: "Eighth Note.png")
        let imageView = UIImageView(image: image)
        imageView.tag = curTag
        curTag = curTag + 1
        imageView.tintColor = .black
        viewLines.addSubview(imageView)
        
        let width = Int(image!.size.width * image!.scale)
        let height = Int(image!.size.height * image!.scale)
        
        imageView.frame = CGRect(x: posx, y: posy-42, width: width, height: height)
        posx = posx + 51
        
        if(posx+80>=Int(percussionLine1.bounds.size.width)) {
            posx = 51
            posy = posy + 70
            
            if(posy>85){
                let image = UIImage(named: "percussionLine.png")
                let imageView = UIImageView(image: image)
                imageView.tag = pLineTag
                pLineTag = pLineTag + 1
                linesStackView.addArrangedSubview(imageView)
            }
        }
        
    }
    
    @IBAction func sixteenthNote(_ sender: UIButton?) {
        
        beats.append(0.25)
        size = size + 1
        
        let image = UIImage(named: "Sixteenth Note.png")
        let imageView = UIImageView(image: image)
        imageView.tag = curTag
        curTag = curTag + 1
        imageView.tintColor = .black
        viewLines.addSubview(imageView)
        
        let width = Int(image!.size.width * image!.scale)
        let height = Int(image!.size.height * image!.scale)
        
        imageView.frame = CGRect(x: posx, y: posy-42, width: width, height: height)
        posx = posx + 51
        
        if(posx+80>=Int(percussionLine1.bounds.size.width)) {
            posx = 51
            posy = posy + 70
            
            if(posy>85){
                let image = UIImage(named: "percussionLine.png")
                let imageView = UIImageView(image: image)
                imageView.tag = pLineTag
                pLineTag = pLineTag + 1
                linesStackView.addArrangedSubview(imageView)
            }
        }
        
    }
    
    @IBAction func play(_ sender: UIButton) {
        
        if(cursorPos<size){
            
            playBeat(index: cursorPos)
            
        }
        
    }

    @objc func playBeat(index: Int) {
        
        beat.play()
        let imageTag = viewLines.viewWithTag(index+1)
        imageTag?.tintColor = .red
        
        delay(beats[index]*60.0/Double(tempo)){
            imageTag?.tintColor = .black
            if(index<self.size-1){
                self.playBeat(index: index + 1)
            }
        }
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
        
    }
    
    @IBOutlet weak var tempoLbl: UILabel!
    @IBAction func tempoSlider(_ sender: UISlider) {
        
        tempo = Int(sender.value)
        tempoLbl.text = String(tempo)
        
    }
    
    @IBAction func left(_ sender: UIButton) {
        
        if(cursorPos>1){
            cursorPos = cursorPos - 1
            let imageTag = viewLines.viewWithTag(cursorPos)
            let x = Int(imageTag!.frame.maxX)
            var y = 0
            if((Int(imageTag!.frame.origin.y)-(Int(percussionLine1.frame.origin.y) + 47))%70==0){
                let temp = ((Int(imageTag!.frame.origin.y))-(Int(percussionLine1.frame.origin.y) + 47))/70
                let pImageTag = viewLines.viewWithTag(10000+temp)
                y = Int(pImageTag!.frame.origin.y)
            }
            else if((Int(imageTag!.frame.origin.y)-(Int(percussionLine1.frame.origin.y) + 47 - 42))%70==0){
                let temp = ((Int(imageTag!.frame.origin.y))-(Int(percussionLine1.frame.origin.y) + 47))/70
                let pImageTag = viewLines.viewWithTag(10000+temp)
                y = Int(pImageTag!.frame.origin.y)
            }
            cursor.frame = CGRect(x: x + 5, y: y + 47, width: 3, height: 23)
        }
            
        else if(cursorPos==1){
            cursorPos = cursorPos - 1
            cursor.frame = CGRect(x: 46, y: Int(percussionLine1.frame.origin.y) + 47, width: 3, height: 23)
        }
        
    }
    
    @IBAction func right(_ sender: UIButton) {
        
        if(cursorPos<size){
            cursorPos = cursorPos + 1
            let imageTag = viewLines.viewWithTag(cursorPos)
            let x = Int(imageTag!.frame.maxX)
            if((Int(imageTag!.frame.origin.y)-(Int(percussionLine1.frame.origin.y) + 47))%70==0){
                let temp = ((Int(imageTag!.frame.origin.y))-(Int(percussionLine1.frame.origin.y) + 47))/70
                let pImageTag = viewLines.viewWithTag(10000+temp)
                let y = Int(pImageTag!.frame.origin.y)
                cursor.frame = CGRect(x: x + 5, y: y + 47, width: 3, height: 23)
            }
            else if((Int(imageTag!.frame.origin.y)-(Int(percussionLine1.frame.origin.y) + 47 - 42))%70==0){
                let temp = ((Int(imageTag!.frame.origin.y))-(Int(percussionLine1.frame.origin.y) + 47))/70
                let pImageTag = viewLines.viewWithTag(10000+temp)
                let y = Int(pImageTag!.frame.origin.y)
                cursor.frame = CGRect(x: x + 5, y: y + 47, width: 3, height: 23)
            }
        }
        
    }
    
    @IBAction func beginning(_ sender: UIButton) {
        
        cursorPos = 0
        cursor.frame = CGRect(x: 46, y: Int(percussionLine1.frame.origin.y) + 47, width: 3, height: 23)
        
    }
    
    
    
}

