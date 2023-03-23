//
//  ViewController.swift
//  MatchEmScene
//
//  Created by Devionne Littleton on 2/21/23.
//
import UIKit

// MARK: - ==== Config Properties ====
//================================================
// Min & max width and height for the rectangles
private let rectSizeMin: CGFloat = 50.0
private let rectSizeMax: CGFloat = 150.0
// How long for the rectangle to fade away
private var fadeDuration: TimeInterval = 0.8

//Array that will contain the top scores


class GameSceneViewController: UIViewController {
    var topScores = [0, 0, 0]
    //used in order to reach ConfigUIViewController
    var config: ConfigUIViewController?
    //Paused and Resumed used to help two finger touch know what it needs to do
    var isPaused: Bool = true
    var isResumed: Bool = false
    var preferStatusBarHidden: Bool {
        return true
    }
    //Function made to interact with two finger touch, allows code to differentiate instances
    @IBAction func pauseAndResume(_ sender: UITapGestureRecognizer) {
        if(sender.numberOfTouches == 2) {
            if(!gameInProgress && isPaused == true) {
                startButton.isHidden = true
                restartButton.isHidden = true
                startGameRunning()
            } else if (gameInProgress && isPaused == false) {
                pause()
            } else if (gameInProgress && isResumed == false){
                resume()
            }
        }
    }
    // Rectangle creation interval
    public var newRectInterval: TimeInterval = 1.2
    // Rectangle creation, so the timer can be stopped
    private var newRectTimer: Timer?

    // Random transparency on or off
    private var randomAlpha = false

    @IBOutlet weak var gameInfoLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    
    @IBOutlet weak var restartButton: UIButton!
    
    
    @IBAction func restartButtonPressed(_ sender: Any) {
        startGameRunning()
        restartButton.isHidden = true
        print(topScores)
        
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        startGameRunning()
        startButton.isHidden = true
        print(topScores)
    }
    private var gameInfo: String {
        let labelText = "Total Pairs: \(rPairsMade) - Pairs Matched \(rPairsTouched) - Time \(gameTimeRemaining)"
        return labelText
    }
    public var gameTimeRemaining = gameDuration {
        didSet { gameInfoLabel?.text = gameInfo }
    }

    //Gametime Rectangle pair variables
    private var rPairsMade: Int = 0 {
        didSet {gameInfoLabel?.text = gameInfo}
    }
    private var rPairsTouched: Int = 0 {
        didSet {gameInfoLabel?.text = gameInfo}
    }
    
    // MARK: - ==== View Controller Methods ====
    override func viewDidLoad() {
        super.viewDidLoad()
        config = self.tabBarController!.viewControllers![1] as? ConfigUIViewController
        // Do any additional setup after loading the view.
    }

    public var gameInProgress = false

    //================================================
    //Checks for first button clicked for the pair
    private var firstTouchCheckButton = true
    private var isfirstTCButtonClicked: UIButton?
    
    @objc private func handleTouch(sender: UIButton) {
        if(isPaused) {
            return
        }
        if (gameInProgress == false) {
            return
        }
        
        if (firstTouchCheckButton) {
            sender.setTitle("🚢", for: .normal)
            isfirstTCButtonClicked = sender
            firstTouchCheckButton = false
        } else if (isfirstTCButtonClicked!.frame.size.height == sender.frame.size.height && isfirstTCButtonClicked?.frame.size.width == sender.frame.size.width && isfirstTCButtonClicked!.backgroundColor == sender.backgroundColor && sender != isfirstTCButtonClicked) {
            firstTouchCheckButton = true
             sender.setTitle("🚢", for: .normal)
             rPairsTouched += 1
            removeRectangle(rectangle: (isfirstTCButtonClicked)!)
             removeRectangle (rectangle: sender)
        } else {
            isfirstTCButtonClicked?.setTitle("", for: .normal)
            firstTouchCheckButton = true
        }
    }
   
    //================================================
    override func viewWillAppear(_ animated: Bool) {
        restartButton.isHidden = true
        super.viewWillAppear(animated)
        
        if(gameInProgress) {
            resume()
        }
        if(!gameInProgress && startButton.isHidden == true) {
            restartButton.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(gameInProgress) {
            pause()
        }
    }
}

// MARK: - ==== Internal Properties ====

// Duration of Game
public var gameDuration: TimeInterval = 13.0

public var rectangles = [UIButton]()
//Timer
private var gameTimer: Timer?

// MARK: - ==== Rectangle Methods ====
extension GameSceneViewController {
//================================================
    
    private func createRectangle() -> UIButton {
        
        // Get random values for the size and location
        let randSize = Utility.getRandomSize(fromMin: rectSizeMin, throughMax: rectSizeMax)
        let randLocation = Utility.getRandomLocation(size: randSize, screenSize: view.bounds.size)
        let randomFrame = CGRect(origin: randLocation, size: randSize)
       
        // Creates a rectangle
        //let rectangleFrame = CGRect(x: 50, y: 150, width: 80, height: 40)
        let rectangle = UIButton(frame: randomFrame)
       
        //rectangle/button setup
        //Checks to see if the config scene has been loaded, if not just use multicolor, if so the user can change colors
        if(config?.rectColorChanger != nil) {
            if(config?.rectColorChanger.selectedSegmentIndex == 1){
                rectangle.backgroundColor = .black
            } else if (config?.rectColorChanger.selectedSegmentIndex == 0){
                rectangle.backgroundColor = Utility.getRandomColor(randomAlpha: randomAlpha)
            } else if (config?.rectColorChanger.selectedSegmentIndex == 2) {
                rectangle.backgroundColor = .green
            }
        } else {
            rectangle.backgroundColor = Utility.getRandomColor(randomAlpha: randomAlpha)
        }
        
        rectangle.setTitle("", for: .normal)
        rectangle.setTitleColor(.black, for: .normal)
        rectangle.titleLabel?.font = .systemFont(ofSize: 50)
        //rectangle.showsTouchWhenHighlighted = true
       
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

        return rectangle

    }
    private func createRectanglePair() {

        gameTimeRemaining -= newRectInterval

        if(gameTimeRemaining < newRectInterval) {
            gameTimeRemaining = 0.0
        }

        let rectX = createRectangle()
        let rectY = createRectangle()
        rectX.frame.size.height = rectY.frame.size.height
        rectX.frame.size.width = rectY.frame.size.width
        rectX.backgroundColor = rectY.backgroundColor
        rPairsMade += 1
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
        isPaused = false
        isResumed = true
        removeSavedRectangles()

        gameInProgress = true
        gameInfoLabel.backgroundColor = .clear
        gameInfoLabel.textColor = .green

        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true) { _ in self.createRectanglePair()}
        // Timer to end the game
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameDuration,
                                                  repeats: false)
                                   { _ in self.stopGameRunning() }
        //================================================
        func removeSavedRectangles() {
            // Remove all rectangles from superview
            for rectangle in rectangles {
            rectangle.removeFromSuperview()
        }
            rPairsTouched = 0
            rPairsMade = 0
            gameTimeRemaining = gameDuration
        }
    }
    //================================================
    private func topScoreCheckList() {
            for i in topScores.indices {
                if(topScores [2-i] < rPairsTouched) {
                    topScores[2-i] = rPairsTouched
                    return
                }
            }
        }
    //================================================
    private func stopGameRunning() {
        removeSavedRectangles()
        isPaused = true
        isResumed = false
        //Make label stand out
        gameInfoLabel.textColor = .red
        gameInfoLabel.backgroundColor = .orange
        gameInfoLabel.text = "You got: \(rPairsTouched) out of \(rPairsMade) Pairs"
        gameInProgress = false
        // Stop the timer
        if let timer = newRectTimer { timer.invalidate() }
        // Remove the reference to the timer object
        self.newRectTimer = nil
        topScoreCheckList()
        topScores.sort(by: >)
        restartButton.isHidden = false
    }
    //=================================================
    private func resume() {
        isPaused = false
        isResumed = true
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameTimeRemaining, repeats: false) {_ in self.stopGameRunning()}
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true) {_ in self.createRectanglePair()}
        if(gameTimeRemaining == 0.0) {
            restartButton.isHidden = false
        }
    }

    private func pause() {
        isPaused = true
        isResumed = false
        gameTimer?.invalidate()
        newRectTimer?.invalidate()
    }
}
