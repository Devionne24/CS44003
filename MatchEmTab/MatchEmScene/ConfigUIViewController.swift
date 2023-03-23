//
//  ConfigUIViewController.swift
//  MatchEmScene
//
//  Created by Guest User on 3/17/23.
//

import UIKit

class ConfigUIViewController: UIViewController {
    
    //Allows code to reach variables within the GameSceneViewController
    var matchGame: GameSceneViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        matchGame = self.tabBarController!.viewControllers![0] as? GameSceneViewController
        rectSlider.value = 1.2
        rectSliderLabel.text = "Speed of Rectangles: \(rectSlider.value)"
        gameDurationLabel.text = "Game Time: \(gameTime.value)"
        darkModeLabel.text = "Dark Mode: OFF"
        tableHighScores.delegate = self
        tableHighScores.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableHighScores.reloadData()
        //highScores?.text = topScoreLabel
    }
 
    //Outlets created in order to help modify their values in functions
    @IBOutlet weak var tableHighScores: UITableView!
    
    @IBOutlet weak var rectSlider: UISlider!
    
    @IBOutlet weak var rectSliderLabel: UILabel!
    
    @IBOutlet weak var rectColorChanger: UISegmentedControl!
    
    @IBOutlet weak var gameDurationLabel: UILabel!
    
    @IBOutlet weak var gameTime: UISlider!
    
    @IBOutlet weak var darkModeLabel: UILabel!
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    //Switch between light and dark mode
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
    
    //Extending game time
    @IBAction func gameDSlider(_ sender: Any) {
        gameDurationLabel.text = "Game Time: \(gameTime.value)"
        gameDuration = TimeInterval(gameTime.value)
    }
    
    @IBAction func changeColor(_ sender: UISegmentedControl) {
        //goes through the index changing the color depending on what you select
        if(sender.selectedSegmentIndex == 0) {
            for rectangle in rectangles {
                rectangle.backgroundColor = Utility.getRandomColor(randomAlpha: true)
            }
        } else if (sender.selectedSegmentIndex == 1){
            for rectangle in rectangles {
                rectangle.backgroundColor = .black
            }
        } else {
            for rectangle in rectangles {
                rectangle.backgroundColor = .green
            }
        }
    }
    
    @IBAction func rectSpeed(_ sender: Any) {
        rectSliderLabel.text = "Speed of Rectangles: \(rectSlider.value)"
        matchGame?.newRectInterval = TimeInterval(1.2 / rectSlider.value)
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

extension ConfigUIViewController: UITableViewDelegate {
    
}

extension ConfigUIViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewCell = UITableViewCell()
        viewCell.textLabel?.text = "\(indexPath.row + 1): \(matchGame?.topScores[indexPath.row] ??  0)"
        return viewCell
    }
}
