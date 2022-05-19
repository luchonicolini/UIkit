//
//  ViewController.swift
//  TargetShooting
//
//  Created by luciano on 8/29/17.
//  Copyright © 2017 ClorindaGames. All rights reserved.
//

import UIKit
import QuartzCore

class HomeController: UIViewController {
   
    var currentValue : Int = 0
    var targetValue  : Int = 0
    var score        : Int = 0
    var round        : Int = 0
    var time         : Int = 0
    var timer        : Timer?
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupSlider()
        resetGame()
        updateLabels()
    }
    
//    func setupSlider(){
////        let thumbImageNormal =
////        let thumbImageHighlighted =
////        let trackLeftImage =
////        let trackRightImage =
//        
//        self.slider.setThumbImage(thumbImageNormal, for: .normal)
//        self.slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
//        
//        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
//        
//        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
//        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
//        
//        self.slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
//        self.slider.setMaximumTrackImage(trackRightResizable, for: .normal)
//    }
    

    @IBAction func showAlert() {
        
        let difference : Int = abs(self.currentValue - self.targetValue)
        
        var points = 100 - difference
        
        let title: String
        
        switch difference {
        case 0:
            title = "¡¡¡Puntuación perfecta!!!"
            points = Int(10.0*Float(points))
        case 1...5:
            title = "Casi perfecto!"
            points = Int(1.5*Float(points))
        case 6...12:
            title = "Te ha faltado poco..."
            points = Int(1.2*Float(points))
        default:
            title = "Has ido lejos..."
        }
        
        let message = "Has marcado \(points) puntos"
        
        self.score += points
        
        let alert = UIAlertController(title: title,
                                      message: message, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "LISTO", style: .default, handler:
        { action in
            self.startNewRound()
            self.updateLabels()
        })
        
        alert.addAction(action)
        present(alert, animated: true)
        
        
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        self.currentValue = lroundf(sender.value)
        
    }
    
    
    func startNewRound(){
        self.targetValue = 1 + Int(arc4random_uniform(100))
        self.currentValue = 50
        self.slider.value = Float(self.currentValue)
        self.round += 1
    }
    
    func updateLabels() {
        self.targetLabel.text = "\(self.targetValue)"
        self.scoreLabel.text  = "\(self.score)"
        self.roundLabel.text  = "\(self.round)"
        self.timeLabel.text   = "\(self.time)"
    }
    
    @IBAction func startNewGame(){
        resetGame()
        updateLabels()
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        self.view.layer.add(transition, forKey: nil)
    }
    
    func resetGame(){
        //Comprobamos puntuación máxima aquí
        var maxscore = UserDefaults.standard.integer(forKey: "maxscore")
        
        if maxscore < self.score {
            maxscore = self.score
            UserDefaults.standard.set(maxscore, forKey: "maxscore")
        }
        
        self.maxScoreLabel.text = "\(maxscore)"
        
        //Reiniciamos variables de juego
        self.score = 0
        self.round = 0
        self.time = 30
        
        //Reiniciamos el temporizador
        if timer != nil {
            timer?.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
        self.updateLabels()
        
        self.startNewRound()
    }
    
    @objc func tick(){
        
        self.time -= 1
        self.timeLabel.text   = "\(self.time)"
        
        if self.time <= 0 {
        self.resetGame()

        }
    }
}

