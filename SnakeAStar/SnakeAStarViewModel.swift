//
//  SnakeAStarViewModel.swift
//  SnakeAStar
//
//  Created by MuMu on 1/2/25.
//

import Foundation

@Observable
class SnakeAStarViewModel {
    let mapWidth = 25
    let mapHeight = 25
    
    let allActions = [Action.up, Action.down, Action.left, Action.right]
    
    var action = Action.down
    
    var snakeBody = [(0, 0)]
    
    var foodPosition = (4, 4)
    
    var snakeHead: (Int, Int) {
        snakeBody.first!
    }
    
    var fullMap: [[Int]] {
        var map = [[Int]](
            repeating: [Int](
                repeating: 0,
                count: mapHeight
            ),
            count: mapWidth
        )
        let (foodX, foodY) = foodPosition
        map[foodX][foodY] = 2
        for position in snakeBody {
            let (x, y) = position
            map[x][y] = 1
        }
        return map
    }
    
    func possibleNewHeads(from head: (Int, Int)) -> [(Int, Int)] {
        var heads = [(Int, Int)]()
        for action in allActions {
            let newHead = (head.0 + action.0, head.1 + action.1)
            if !isDead(snakeHead: newHead) {
                heads.append(newHead)
            }
        }
        return heads
    }
    
    func isDead(snakeHead: (Int, Int)) -> Bool {
        let isOutOfBounds = snakeHead.0 < 0 || snakeHead.0 >= mapWidth || snakeHead.1 < 0
        || snakeHead.1 >= mapHeight
        let isCollidedWithBody = snakeBody.contains(where: { $0 == snakeHead })
        return isOutOfBounds || isCollidedWithBody
    }
    
    func update() {
        if let newHead = aStar().first ?? possibleNewHeads(from: snakeHead).first{
            snakeBody.insert(newHead, at: 0)
            if !(newHead == foodPosition) {
                snakeBody.removeLast()
            } else {
                while snakeBody.contains(where: { $0 == foodPosition }) {
                    foodPosition = (
                        Int.random(in: 0..<mapWidth),
                        Int.random(in: 0..<mapHeight)
                    )
                }
            }
        } else {
            reset()
        }
        
        
    }
    
    func reset() {
        snakeBody = [(0, 0)]
        action = Action.down
        foodPosition = (4, 4)
    }
    
    func neighbors(open: [Node], current: Node) -> [Node] {
        possibleNewHeads(from: current.position).map { position in
            if let node = open.first(where: { $0.position == position }) {
                return node
            } else {
                return Node(
                    position: position,
                    parent: current,
                    destination: foodPosition
                )
            }
        }
    }
    
    func reconstruct(targetNode: Node) -> [(Int, Int)] {
        var path = [(Int, Int)]()
        var current: Node? = targetNode
        while let node = current {
            path.append(node.position)
            current = node.parent
        }
        path.popLast()
        return path.reversed()
    }
    
    func aStar() -> [(Int, Int)] {
        var open = [Node]()
        var closed = [Node]()
        
        let startNode = Node(
            position: snakeHead,
            destination: foodPosition
        )
        open.append(startNode)
        
        while !open.isEmpty {
            let current = open.max(by: { $0.fCost > $1.fCost })!
            open.removeAll { $0.position == current.position }
            closed.append(current)
            
            if current.position == foodPosition {
                return reconstruct(targetNode: current)
            }
            
            for neighbor in neighbors(open: open, current: current) {
                if closed.contains(where: { $0.position == neighbor.position }) {
                    continue
                }
                if open.contains(where: { $0.position == neighbor.position }) {
                    // Create a node with parent as current to check path length
                    let testNode = Node(
                        position: neighbor.position,
                        parent: current,
                        destination: foodPosition
                    )
                    
                    if testNode.fCost < neighbor.fCost {
                        neighbor.parent = current
                    }
                } else {
                    open.append(neighbor)
                }
            }
        }
        return []
    }
}
