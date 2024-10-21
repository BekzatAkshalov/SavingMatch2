//
//  ViewController.swift
//  match2_project
//
//  Created by Bekzat on 18/10/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelTimer: UILabel!
    
    @IBOutlet weak var movesLabel: UILabel!
    
    @IBOutlet weak var StartTimerButton: UIButton!
    
    var timer = Timer()
   
    
    var images = ["1", "2", "3", "4", "5", "6", "7", "8", "1", "2", "3", "4", "5", "6", "7", "8"]
    
   var state = [Int](repeating: 0, count: 16) //массив в котором хранятся ходы
 var winState = [[0, 8], [1, 9], [2, 10], [3, 11], [4, 12], [5, 13], [6, 14], [7, 15]] //тут хранятся выигрышные комбинации
 
var isActive = false
    
    var moves = 0
    var time = 0
    var savedTime = 0
    
    
    var isTimeRunning = false
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTimer.text = timeString(time: time)
        savedTime = time
        movesLabel.text = String(moves)
    }
    

    @IBAction func StartTimer(_ sender: UIButton) {
        if isTimeRunning {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        isTimeRunning = true
    }
    
    @objc func updateTime() {
        labelTimer.text = timeString(time: time)
        time += 1

    }
    
    func updateTimeLabel() {
        labelTimer.text = timeString(time: time)
    }
    
    @IBAction func game(_ sender: UIButton) {
        print(sender.tag)
        
        if state[sender.tag - 1] != 0 || isActive {  // != нельзя нажимать уже открытую картинку, isActive true
            return
        }
        
        if isTimeRunning == false {
            return
        }
        sender.setBackgroundImage(UIImage(named: images[sender.tag - 1]), for: .normal)
        
        sender.backgroundColor = UIColor.white
        
        state[sender.tag - 1] = 1 //поставили 1 в начале с первого хода
        
        var count = 0
        
        for item in state {
            if item == 1 {
                count += 1
            }
        }
        
        if count == 2 {
            isActive = true
            moves += 1
            movesLabel.text = String(moves)
            for winArray in winState {
                if state[winArray[0]] == state[winArray[1]] && state[winArray[1]] == 1 {
                    state[winArray[0]] = 2
                    state[winArray[1]] = 2
                    isActive = false
                }
            }
            
            if isActive {
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clear), userInfo: nil, repeats: false)
            }
            
            
        }
        
        if !state.contains(0) {
            timer.invalidate()
            let alert = UIAlertController(title: "You win!", message: "Congratulations!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Start again", style: .default, handler: {UIAlertAction in
                self.clearBoard()
                self.moves = 0
                self.movesLabel.text = String(self.moves)
                self.shuffleImages()
        
                self.time = self.savedTime
                self.updateTimeLabel()
                self.isTimeRunning = false
                self.StartTimer(self.StartTimerButton)
                
            }))
            
            present(alert, animated: true)
                /* isTimeRunning = false
            time = savedTime*/
           }
        
       
       
    }
           
    func shuffleImages() {
        images.shuffle()
        var newWinState: [[Int]] = []
        for image in Set(images) {
            let matchingIndexes = images.enumerated().filter { $0.element == image }.map { $0.offset }
            newWinState.append(matchingIndexes)
            }
        winState = newWinState
                
    }
    
   
    
    @objc func clear() {
        for i in 0...15 {
            if state[i] == 1 {
                state[i] = 0
                let button = view.viewWithTag(i + 1) as! UIButton
                button.setBackgroundImage(nil, for: .normal)
                button.backgroundColor = UIColor.systemMint
            }
        }
        isActive = false
    }
    
    func clearBoard() {
        for i in 0...15 {
            let button = view.viewWithTag(i+1) as! UIButton
            button.setBackgroundImage(nil, for: .normal)
            button.backgroundColor = UIColor.systemMint
            
            state[i] = 0
        }
        
    }
    
           
    
}

func timeString(time: Int) -> String {
    let hour =  time / 3600
    let minute =  time / 60 % 60
    let second =  time % 60
    
    return String(format: "%02i:%02i:%02i", hour, minute, second)
}

 
