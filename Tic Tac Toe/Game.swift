//
//  Game.swift
//  Tic Tac Toe
//
//  Created by Andrew Bloodworth on 3/20/20.
//  Copyright © 2020 Andrew Bloodworth. All rights reserved.
//

import Foundation

enum pType {
    case X
    case O
}

struct move {
    var position: Int
    var type: String
}

var board = [Int:String]()
var gameOver: Bool!

protocol gameDelegate {
    func didFindWinner(winner:player,wArr:[Int])
    func didEndGame(_:player)
    func didDraw(_:player)
    func didFindMove(_:player)
    func didMakeMove(_:player)
}

class player {
    var name: String
    var type: pType
    var moves: [move]
    
    init (name: String, type: pType, moves: [move]) {
        self.name = name
        self.type = type
        self.moves = moves
    }
    
    var delegate: gameDelegate?
    
    func checkMoves() {
        var mCheck = [Int]()
        for m in moves {
            mCheck.append(m.position)
        }
        if (mCheck.contains(1) && mCheck.contains(2) && mCheck.contains(3)) {
            self.winner(wArr:[1,2,3])
        }
        else if (mCheck.contains(4) && mCheck.contains(5) && mCheck.contains(6)) {
            self.winner(wArr:[4,5,6])
        }
        else if (mCheck.contains(7) && mCheck.contains(8) && mCheck.contains(9)) {
            self.winner(wArr:[7,8,9])
        }
        else if (mCheck.contains(1) && mCheck.contains(4) && mCheck.contains(7)) {
            self.winner(wArr:[1,4,7])
        }
        else if (mCheck.contains(2) && mCheck.contains(5) && mCheck.contains(8)) {
            self.winner(wArr:[2,5,8])
        }
        else if (mCheck.contains(3) && mCheck.contains(6) && mCheck.contains(9)) {
            self.winner(wArr:[3,6,9])
        }
        else if (mCheck.contains(1) && mCheck.contains(5) && mCheck.contains(9)) {
            self.winner(wArr:[1,5,9])
        }
        else if (mCheck.contains(3) && mCheck.contains(5) && mCheck.contains(7)) {
            self.winner(wArr:[3,5,7])
        }
        else if !board.contains(where: { $0.1 == " " }) {
            gameOver = true
            self.delegate?.didDraw(self)
        }
    }
    
    func makeMove(m:move) {
        if !gameOver {
            if board[m.position] != " " {
                self.delegate?.didFindMove(self)
            }
            else {
                self.moves.append(m)
                board.updateValue(m.type, forKey: m.position)
                self.delegate?.didMakeMove(self)
                checkMoves()
            }
        }
        else {
            self.delegate?.didEndGame(self)
        }
    }
    func xo() -> String {
        switch self.type {
        case .O:
            return "O"
        case .X:
            return "X"
        }
    }
    func winner(wArr: [Int]) {
        gameOver = true
        self.delegate?.didFindWinner(winner:self,wArr: wArr)
    }
}

protocol tictactoe {
    var p1: player { get }
    var p2: player { get }
}

class gameInit: tictactoe {
    var p1: player
    var p2: player
    
    init(p1: player, p2: player) {
        self.p1 = p1
        self.p2 = p2
    }
}

class game: gameInit {
    func start() {
        gameOver = false
        for i in 1...9 {
            board.updateValue(" ", forKey: i)
        }
    }
    func Board() -> [Int:String] {
        return board
    }
}
