//
//  Utility.swift
//  MatchEmScene
//
//  Created by Devionne Littleton on 2/21/23.
//
import UIKit


class Utility: NSObject {
  let ri = Int.random(in: 0 ... 99)
  let rd = Double.random(in: 0.0 ... 1.0)
  // MARK: - ==== Random Value Funcs ====
  //================================================
  static func randomFloatZeroThroughOne() -> CGFloat {
    // Get a random value
    let randomFloat = CGFloat.random(in: 0 ... 1.0)
    return randomFloat
  }
 
  //================================================
  static func getRandomSize(fromMin min: CGFloat,
  throughMax max: CGFloat) -> CGSize {
    // Create a random CGSize
    let randWidth = randomFloatZeroThroughOne() * (max - min) + min
    let randHeight = randomFloatZeroThroughOne() * (max - min) + min
    let randSize = CGSize(width: randWidth, height: randHeight)
    return randSize
  }
 
  //================================================
  static func getRandomLocation(size rectSize: CGSize,
  screenSize: CGSize) -> CGPoint {
    // Get the screen dimensions
    let screenWidth = screenSize.width
    let screenHeight = screenSize.height - 10
    // Create a random location/point
    let rectX = randomFloatZeroThroughOne() * (screenWidth - rectSize.width)
    let rectY = randomFloatZeroThroughOne() * (screenHeight - rectSize.height)
    let location = CGPoint(x: rectX, y: rectY)
    return location
  }
 
  //================================================
  static func getRandomColor(randomAlpha: Bool) -> UIColor {
    // Get random values for the RGB components
    let randRed = randomFloatZeroThroughOne()
    let randGreen = randomFloatZeroThroughOne()
    let randBlue = randomFloatZeroThroughOne()
    // Transparency can be none or random.
    var alpha:CGFloat = 1.0
    if randomAlpha {
    alpha = randomFloatZeroThroughOne()
    }
    return UIColor(red: randRed, green: randGreen, blue: randBlue, alpha: alpha)
  }




}

