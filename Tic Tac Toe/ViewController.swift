//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Andrew Bloodworth on 3/20/20.
//  Copyright © 2020 Andrew Bloodworth. All rights reserved.
//

import Cocoa
extension NSImage {
    class func swatchWithColor(color: NSColor, size: NSSize) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        color.drawSwatch(in: NSMakeRect(0, 0, size.width, size.height))
        image.unlockFocus()
        return image
    }
}
enum title {
    case Main
    case Turn
    case Winner
    case Draw
    case GameOver
    case StartError
    case NameError
    case MoveError
}

class ViewController: NSViewController, gameDelegate {

    @IBOutlet weak var boardImg: NSImageView!
    @IBOutlet weak var buttonOne: NSButton!
    @IBOutlet weak var buttonTwo: NSButton!
    @IBOutlet weak var buttonThree: NSButton!
    @IBOutlet weak var buttonFour: NSButton!
    @IBOutlet weak var buttonFive: NSButton!
    @IBOutlet weak var buttonSix: NSButton!
    @IBOutlet weak var buttonSeven: NSButton!
    @IBOutlet weak var buttonEight: NSButton!
    @IBOutlet weak var buttonNine: NSButton!
    @IBOutlet weak var gameTitle: NSTextField!
    @IBOutlet weak var scoreBoard: NSTextField!
    @IBOutlet weak var p1Name: NSTextField!
    @IBOutlet weak var p2Name: NSTextField!
    
    var Game: game?
    var pCurrent: player?
    var bArr = [NSButton]()
    var scoreText = String()
    var gameCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bArr = [buttonOne,buttonTwo,buttonThree,buttonFour,buttonFive,buttonSix,buttonSeven,buttonEight,buttonNine]
        updateTitle(t: .Main, name: nil)
        updateScoreBoard(text: nil, reset: true)
    }
    func updateTitle(t:title,name: String?) {
        var text = String()
        switch t {
        case .Main:
            text = "Tic Tac Toe"
        case .Turn:
            text = name!+"'s turn"
        case .Winner:
            text = "Winner is: "+name!
        case .Draw:
            text = "It's a Draw!"
        case .GameOver:
            text = "This Game is Over"
        case .StartError:
            text = "Please Start the Game"
        case .NameError:
            text = "Please Enter Player Names"
        case .MoveError:
            text = name!+": This spot is already filled. Try again!"
        }
        gameTitle.stringValue = text
    }
    func updateScoreBoard(text:String?,reset:Bool) {
        if reset {
            gameCount = 0
            scoreText = "Score Board\n"
        }
        else {
            gameCount += 1
            scoreText += "\(gameCount): "+text!+"\n"
        }
        scoreBoard.stringValue = scoreText
    }
    func updateBoard() {
        var i = 1
        for b in bArr {
            b.title = Game!.Board()[i]!
            i+=1
        }
    }
    func switchPlayer() {
        pCurrent = (pCurrent!.name == Game?.p1.name) ? Game?.p2 : Game?.p1
        pCurrent?.delegate = self
        updateTitle(t: .Turn, name: pCurrent?.name)
    }
    func moveMaker(p:Int) {
        guard let _ = pCurrent else {
            if board.contains(where: { $0.1 == "X" }) ||
               board.contains(where: { $0.1 == "O" }) {
                updateTitle(t: .GameOver, name: nil)
            }
            else {
                updateTitle(t: .StartError, name: nil)
            }
            return
        }
        pCurrent?.makeMove(m: move(position: p, type: (pCurrent?.xo())!))
    }
    func didFindWinner(winner:player,wArr:[Int]) {
        for w in wArr {
            bArr[w-1].image = NSImage.swatchWithColor( color: NSColor.green, size: NSMakeSize(280, 130) )
        }
        updateTitle(t: .Winner, name: winner.name)
        updateScoreBoard(text: winner.name, reset: false)
    }
    func didMakeMove(_:player) {
        updateBoard()
        switchPlayer()
    }
    func didFindMove(_:player) {
        updateTitle(t: .MoveError, name: pCurrent?.name)
    }
    func didDraw(_:player) {
        updateTitle(t: .Draw, name: nil)
        updateScoreBoard(text: "Draw", reset: false)
    }
    func didEndGame(_:player) {
        updateTitle(t: .GameOver, name: nil)
    }
    @IBAction func createGame(_ sender: Any) {
        if p1Name.stringValue == "" || p2Name.stringValue == "" {
            updateTitle(t: .NameError, name: nil)
            pCurrent = nil
            return
        }
        for b in bArr {
            b.image = NSImage.swatchWithColor( color: NSColor.white, size: NSMakeSize(280, 130) )
        }
        Game = game(p1: player(name: p1Name.stringValue, type: .X, moves: [move]()),
                    p2: player(name: p2Name.stringValue, type: .O, moves: [move]()))
        Game?.start()
        
        let diceRoll = Int(arc4random_uniform(2) + 1)
        pCurrent = (diceRoll == 1) ? Game?.p1 : Game?.p2
        pCurrent?.delegate = self

        updateTitle(t: .Turn, name: pCurrent?.name)
        updateBoard()
    }
    @IBAction func resetScoreBoard(_ sender: Any) {
        updateScoreBoard(text: nil, reset: true)
    }
    @IBAction func buttonOneClick(_ sender: Any) {
        moveMaker(p: 1)
    }
    @IBAction func buttonTwoClick(_ sender: Any) {
        moveMaker(p: 2)
    }
    @IBAction func buttonThreeClick(_ sender: Any) {
        moveMaker(p: 3)
    }
    @IBAction func buttonFourClick(_ sender: Any) {
        moveMaker(p: 4)
    }
    @IBAction func buttonFiveClick(_ sender: Any) {
        moveMaker(p: 5)
    }
    @IBAction func buttonSixClick(_ sender: Any) {
        moveMaker(p: 6)
    }
    @IBAction func buttonSevenClick(_ sender: Any) {
        moveMaker(p: 7)
    }
    @IBAction func buttonEightClick(_ sender: Any) {
        moveMaker(p: 8)
    }
    @IBAction func buttonNineClick(_ sender: Any) {
        moveMaker(p: 9)
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

