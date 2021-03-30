//
//  ViewControllerGame.swift
//  SpaceInvaders
//
//  Created by Разработчик on 26/03/2021.
//  Copyright © 2021 Разработчик. All rights reserved.
//

import UIKit

class ViewControllerGame: UIViewController {
  
  var player = UIImageView(image: #imageLiteral(resourceName: "playerShip"))
  var ship:  [UIImageView] = []
  let shipTexture = UIImage(named: "enemy1")
  let bulletTexture = UIImage(named: "laserRed02")
  var moveDirection = true
  var gameState = true
  var enemiesSpeed = 50000
  var currentScore = 0
  var currentRecord = 0;
  
  
  
  @IBOutlet weak var recordLabel: UILabel!
  @IBOutlet weak var endButton: UIButton!
  @IBOutlet weak var endLabel: UILabel!
  @IBOutlet weak var score: UILabel!
  @IBOutlet var left : UIButton!
  @IBOutlet var right : UIButton!
  @IBOutlet var shootButton : UIButton!
  
  let topCollision = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 1))
  
  let bottomCollision = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 150, width: UIScreen.main.bounds.width, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
      
        player.frame = CGRect(x:Int(self.view.center.x),y:Int(self.view.frame.height - 150),width:50,height:50)
        self.view.addSubview(player)
      
        self.score.text = "0"
        self.endLabel.isHidden = true
        self.endButton.isHidden = true
        self.endButton.isEnabled = false
        self.recordLabel.isHidden = true
      
        createEnemies()
        enemyMove()
        checkingEnemies()
        gameOver()
    }
  
  private func checkingEnemies() {
    DispatchQueue.global(qos: .userInteractive).async {
      while(self.gameState){
        usleep(5000)
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
          var check = true
          for i in 0..<self.ship.count {
            if(self.ship[i].isHidden != true){
              check = !check
              break
            }
          }
          if(check){
            self.ship.removeAll()
            self.enemiesSpeed /= 2
            self.createEnemies()
          }
        })
      }
    }
  }
  
  private func createEnemies() {
    let n=Int(UIScreen.main.bounds.width/10)
    for i in 0..<25 {
      let imageView = UIImageView(image: shipTexture);
      if(i<5){
        imageView.frame = CGRect(x:n*i+5,y:n,width:n-5,height:n-5)
      }else if(i<10){
        imageView.frame = CGRect(x:n*(i-5)+5,y:n*2,width:n-5,height:n-5)
      }else if(i<15){
        imageView.frame = CGRect(x:n*(i-10)+5,y:n*3,width:n-5,height:n-5)
      }else if(i<20){
        imageView.frame = CGRect(x:n*(i-15)+5,y:n*4,width:n-5,height:n-5)
      }else{
        imageView.frame = CGRect(x:n*(i-20)+5,y:n*5,width:n-5,height:n-5)
      }
      ship.append(imageView)
      
      self.view.addSubview(ship[i])
      ship[i].isHidden = false

      
    }
  }
  
  @IBAction func leftMove(sender : AnyObject) {
    if(player.frame.minX > 0 && left.isHighlighted){
      player.center=CGPoint(x:player.center.x-10, y:player.center.y)
      perform(#selector(leftMove), with: nil, afterDelay: 0.05)
    }
  }
  
  @IBAction func rightMove(sender : AnyObject) {
    if(player.frame.maxX < UIScreen.main.bounds.width && right.isHighlighted){
        player.center=CGPoint(x:player.center.x+10, y:player.center.y)
        perform(#selector(rightMove), with: nil, afterDelay: 0.05)
    }
  }
    
  @IBAction func returnToMainScreen(_ sender: UIButton) {
    performSegue(withIdentifier: "endGame", sender: self.currentRecord)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let ViewContr = segue.destination as? ViewController {
      ViewContr.currentRecord = self.currentRecord
    }
  }
  
  
  private func enemyMove(){
        DispatchQueue.global(qos: .userInitiated).async {
            while(self.gameState) {
              usleep(useconds_t(self.enemiesSpeed))
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    for i in 0..<self.ship.count {
                        switch self.moveDirection{
                        case true:
                             self.ship[i].center = CGPoint(x: self.ship[i].center.x + 0.5, y: self.ship[i].center.y + 0.2)
                             if self.ship[self.ship.endIndex - 1].frame.maxX > (UIScreen.main.bounds.width - 5){
                                self.moveDirection = !self.moveDirection
                            }
                        case false:
                            self.ship[i].center = CGPoint(x: self.ship[i].center.x - 0.5, y: self.ship[i].center.y + 0.2)
                            if self.ship[self.ship.startIndex].frame.minX < 5 {
                                self.moveDirection = !self.moveDirection
                            }
                            
                        }
                    }
                })
            }
        }
    }
    
    private func createBullet() -> UIImageView{
        var bulletImageView = UIImageView()
        bulletImageView = UIImageView(image: bulletTexture)
        bulletImageView.frame = CGRect(x:0,y:0,width:10,height:15)
        bulletImageView.center = CGPoint(x: player.center.x, y: player.center.y - 5)
        bulletImageView.contentMode = .scaleAspectFit
      
      return bulletImageView
    }
    
    
    @IBAction func playerShoot(_ sender: Any) {
        let bullet = createBullet()
        self.view.addSubview(bullet)
        var test = true;
        DispatchQueue.global(qos: .userInteractive).async {
            while(test) {
                usleep(10000)
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    bullet.center = CGPoint(x: bullet.center.x, y: bullet.center.y - 3)
                    let check = self.collisionBullet(target: self.ship, bullet: bullet)
                  
                    let checkOutOfScreen = self.outOfScreenCollision(target: self.topCollision, object: bullet)
                 
                  
                    if check >= 0 {
                        self.currentScore += 1
                        self.score.text = String(self.currentScore)
                        self.ship[check].isHidden = true
                        bullet.removeFromSuperview()
                        test = !test
                    }
                  
                  if checkOutOfScreen >= 0 {
                    print(checkOutOfScreen)
                    bullet.removeFromSuperview()
                  }
                  
                })
            }
        }
    }
  
  private func collisionBullet(target: [UIImageView], bullet: UIImageView) -> Int{
      for i in 0..<target.count {
          if (bullet.frame.intersects(target[i].frame) && target[i].isHidden == false) {
            return i
          }
          
      }
      return -1
    }
  
  private func outOfScreenCollision(target: UIView, object: UIImageView) -> Int{
    if (object.frame.intersects(target.frame) && target.isHidden == false) {
      return 1
  }
    return -1
  }
  
  private func outOfScreenCollisionBottom(target: UIView, object: [UIImageView]) -> Int{
    for i in 0..<object.count {
      if (object[i].frame.intersects(target.frame) && object[i].isHidden == false) {
        return i
      }
      
    }
    return -1
  }
  
  private func gameOver() {
    DispatchQueue.global(qos: .userInteractive).async {
      while(self.gameState){
        usleep(5000)
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
          let checkBottomCollision = self.outOfScreenCollisionBottom(target: self.bottomCollision, object: self.ship)
          
          if checkBottomCollision >= 0 {
            self.gameState = false
            self.shootButton.isEnabled = false
            self.right.isEnabled = false
            self.left.isEnabled = false
            self.endLabel.isHidden = false
            self.endButton.isHidden = false
            self.endButton.isEnabled = true
            
            self.currentRecord = 0;
            
            if UserSettings.gameRecord == nil {
              UserSettings.gameRecord = String(self.currentScore)
            }
            
            if let temp = UserSettings.gameRecord {
              self.currentRecord = Int(temp)!
            }
            
            if self.currentScore > self.currentRecord {
              UserSettings.gameRecord = String(self.currentScore);
              self.recordLabel.isHidden = false
            }
            
          }
      })
      }
  }
  
}

}



