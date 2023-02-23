//
//  ViewController.swift
//  MatchEmScene
//
//  Created by Devionne Littleton on 2/21/23.
//

import UIKit
import UIKit

// MARK: - ==== Config Properties ====
//================================================
// Min & max width and height for the rectangles
private let rectSizeMin: CGFloat = 50.0
private let rectSizeMax: CGFloat = 150.0
// How long for the rectangle to fade away
private var fadeDuration: TimeInterval = 0.8


class GameSceneViewController: UIViewController {
    // Init the time remaining
    
    // Counters, property observers used
    private var rectanglesCreated: Int = 0 {
        didSet { gameInfoLabel?.text = gameInfo } }
    private var rectanglesTouched: Int = 0 {
        didSet { gameInfoLabel?.text = gameInfo } }
   
    // Rectangle creation interval
    private var newRectInterval: TimeInterval = 1.2
    // Rectangle creation, so the timer can be stopped
    private var newRectTimer: Timer?
    
    //Game duration
    private var gameDuration: TimeInterval = 10.0
    
    //Game Timer
    private var gameTimer: Timer?

    // Random transparency on or off
    private var randomAlpha = false

    @IBOutlet weak var gameInfoLabel: UILabel!
    private var gameInfo: String {
        let labelText = "Total: \(rectanglesCreated) - Touched \(rectanglesTouched)"
        return labelText
    }
    
    // MARK: - ==== View Controller Methods ====
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    private var gameInProgress = false
    //================================================
    @objc private func handleTouch(sender: UIButton) {
        if gameInProgress == false {
            return
        }
        //print("\(#function) - \(sender)")
        // Add emoji text to the rectangle
        //sender.setTitle("🚢", for: .normal)
        // Removing the rectangle
        removeRectangle(rectangle: sender)
        // Remove the final button owner
        sender.removeFromSuperview()
        rectanglesTouched += 1
        
    }
   
    //================================================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        // Creates rectangles
        createRectangle()
        createRectangle()
        createRectangle()
    }
}
// MARK: - ==== Internal Properties ====
// Keeping track of all rectangles created
private var rectangles = [UIButton]()

// MARK: - ==== Rectangle Methods ====
extension GameSceneViewController {
//================================================
    
    private func createRectangle() {
        rectanglesCreated += 1
        // Get random values for the size and location
        let randSize = Utility.getRandomSize(fromMin: rectSizeMin, throughMax: rectSizeMax)
        let randLocation = Utility.getRandomLocation(size: randSize, screenSize: view.bounds.size)
        let randomFrame = CGRect(origin: randLocation, size: randSize)
       
        // Creates a rectangle
        //let rectangleFrame = CGRect(x: 50, y: 150, width: 80, height: 40)
        let rectangle = UIButton(frame: randomFrame)
       
        //rectangle/button setup
        rectangle.backgroundColor = Utility.getRandomColor(randomAlpha: randomAlpha)
        rectangle.setTitle("", for: .normal)
        rectangle.setTitleColor(.black, for: .normal)
        rectangle.titleLabel?.font = .systemFont(ofSize: 50)
        rectangle.showsTouchWhenHighlighted = true
       
        // Make the rectangle visible
        self.view.addSubview(rectangle)
       
        // Target/action to set up connect of button to the VC
        rectangle.addTarget(self,
                action: #selector(self.handleTouch(sender:)),
                for: .touchUpInside)
        // Save the rectangle till the game is over
        rectangles.append(rectangle)
        
        // Move label to the front
        view.bringSubviewToFront(gameInfoLabel!)

    }
   
    //================================================
    func removeRectangle(rectangle: UIButton) {
        // Rectangle fade animation
        let pa = UIViewPropertyAnimator(duration: fadeDuration,
        curve: .linear,
        animations: nil)
        pa.addAnimations {
            rectangle.alpha = 0.0
        }
        pa.startAnimation()
    }
    //================================================
    func removeSavedRectangles() {
        // Remove all rectangles from superview
        for rectangle in rectangles {
            rectangle.removeFromSuperview()
        }
        
        // Clear the rectangles array
        rectangles.removeAll()
    }
}


extension GameSceneViewController {
    private func startGameRunning() {
        gameInProgress = true
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true) { _ in self.createRectangle()}
        // Timer to end the game
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameDuration,
                                                  repeats: false)
                                   { _ in self.stopGameRunning() }
    }
    //================================================
    private func stopGameRunning() {
        gameInProgress = false
        // Stop the timer
        if let timer = newRectTimer { timer.invalidate() }
        // Remove the reference to the timer object
        self.newRectTimer = nil
    }
}
