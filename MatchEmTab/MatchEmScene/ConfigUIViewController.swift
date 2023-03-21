//
//  ConfigUIViewController.swift
//  MatchEmScene
//
//  Created by Guest User on 3/17/23.
//

import UIKit

class ConfigUIViewController: UIViewController {
    
    var matchGame: GameSceneViewController?
    var first: Int = 0
    var second: Int = 0
    var third: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        matchGame = self.tabBarController!.viewControllers![0] as? GameSceneViewController
        rectSlider.value = 1.2
        rectSliderLabel.text = "Speed of Rectangles: \(rectSlider.value)"
        gameDurationLabel.text = "Game Time: \(gameTime.value)"
        darkModeLabel.text = "Dark Mode: OFF"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        first = matchGame?.topScores[0] ?? 0
        second = matchGame?.topScores[1] ?? 0
        third = matchGame?.topScores[2] ?? 0
        highScores?.text = topScoreLabel
    }
    @IBOutlet weak var highScores: UILabel!
    
    @IBOutlet weak var rectSlider: UISlider!
    
    @IBOutlet weak var rectSliderLabel: UILabel!
    
    @IBOutlet weak var rectColorChanger: UISegmentedControl!
    
    @IBOutlet weak var gameDurationLabel: UILabel!
    
    @IBOutlet weak var gameTime: UISlider!
    
    @IBOutlet weak var darkModeLabel: UILabel!
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    
    @IBAction func darkAndLight(_ sender: UISwitch) {
        if(sender.isOn == true) {
            matchGame?.view.backgroundColor = .darkGray
            view.backgroundColor = .darkGray
            darkModeLabel.text = "Dark Mode: ON"
        } else {
            matchGame?.view.backgroundColor = .white
            view.backgroundColor = .white
            darkModeLabel.text = "Dark Mode: OFF"
        }
    }
    
    @IBAction func gameDSlider(_ sender: Any) {
        gameDurationLabel.text = "Game Time: \(gameTime.value)"
        gameDuration = TimeInterval(gameTime.value)
    }
    
    @IBAction func changeColor(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            for rectangle in rectangles {
                rectangle.backgroundColor = Utility.getRandomColor(randomAlpha: true)
            }
        } else {
            for rectangle in rectangles {
                rectangle.backgroundColor = .black
            }
        }
    }
    
    @IBAction func rectSpeed(_ sender: Any) {
        rectSliderLabel.text = "Speed of Rectangles: \(rectSlider.value)"
        matchGame?.newRectInterval = TimeInterval(1.2 / rectSlider.value)
    }
    
    private var topScoreLabel: String {
        let highScores = "1. \(first) \n2. \(second) \n3. \(third)"
        return highScores
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
