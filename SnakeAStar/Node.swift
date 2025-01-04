//
//  Node.swift
//  SnakeAStar
//
//  Created by MuMu on 1/3/25.
//

import Foundation

class Node {
    let position: (Int, Int)
    let destination: (Int, Int)
    
    var parent: Node?
    
    var hCost: Double {
        distance(to: destination)
    }
    
    var gCost: Double {
        if let parent = parent {
            return distance(to: parent.position)
        } else {
            return 0
        }
    }
    
    var fCost: Double {
        hCost + gCost
    }
    
    
    init(
        position: (Int, Int),
        parent: Node? = nil,
        destination: (Int, Int)
    ) {
        self.position = position
        self.parent = parent
        self.destination = destination
    }
    
    func distance(to position: (Int, Int)) -> Double {
        let xDistance = abs(Double(position.0 - self.position.0))
        let yDistance = abs(Double(position.1 - self.position.1))
        return xDistance + yDistance
    }
}
