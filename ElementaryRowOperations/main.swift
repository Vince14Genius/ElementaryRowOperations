//
//  main.swift
//  ElementaryRowOperations
//
//  Created by Vincent C. on 2/20/20.
//  Copyright © 2020 Vincent C. All rights reserved.
//

import Foundation

// This piece of shit only supports Int elements
// TODO: add support for fractions

var matrix: Matrix<Int>

enum Commands: String {
    case help = "help"
    case quit = "quit"
    case rewrite = "rewrite"
    case set = "set"
    case replace = "+="
    case scale = "*="
    case scaleDivide = "/="
    case interchange = "swap"
}

func getIntValueFromCommandLine() -> Int {
    while true {
        let input = readLine(strippingNewline: true)
        if let returnValue = Int(input ?? "") {
            return returnValue
        }
        printNoLn("Please enter an integer: ")
    }
}

func getPositiveIntValueFromCommandLine() -> Int {
    while true {
        let input = readLine(strippingNewline: true)
        if let returnValue = Int(input ?? "") {
            if returnValue > 0 {
                return returnValue
            }
        }
        printNoLn("Please enter a positive integer: ")
    }
}

func printNoLn(_ value: Any) {
    print(value, terminator: "")
}
    
print("Matrix Setup: Matrix A(m×n)")
printNoLn("m: ")
let m = getPositiveIntValueFromCommandLine()
printNoLn("n: ")
let n = getPositiveIntValueFromCommandLine()

matrix = Matrix(rows: m, columns: n)
print("""
    
    Created \(matrix.rows) by \(matrix.columns) Matrix A
    
    \(matrix)
    """)

func printCommandList() {
    print("""
        
    COMMAND LIST (all lowercase):
    "\(Commands.help.rawValue)" - show list of commands
    "\(Commands.rewrite.rawValue)" - edit all values of the matrix
    "\(Commands.set.rawValue)" - set the value of one element in the matrix
    "\(Commands.replace.rawValue)" - replace
    "\(Commands.scale.rawValue)" - scale (multiply by integer)
    "\(Commands.scaleDivide.rawValue)" - scale (divide by integer)
    "\(Commands.interchange.rawValue)" - interchange
    "\(Commands.quit.rawValue)" - QUIT
    
    """)
}

printCommandList()

func printCommandPrompt() {
    printNoLn("Please enter a command: ")
}

printCommandPrompt()

while let input = readLine() {
    if input == Commands.quit.rawValue {
        break
    }
    
    var didModifyMatrix = false
    
    switch input {
    case Commands.help.rawValue:
        printCommandList()
    case Commands.rewrite.rawValue:
        for row in 0..<matrix.rows {
            for column in 0..<matrix.columns {
                printNoLn("New value for (row: \(row + 1), column: \(column + 1)): ")
                let value = getIntValueFromCommandLine()
                do {
                    try matrix.set(value, rowIndex: row, columnIndex: column)
                    didModifyMatrix = true
                } catch {
                    print(error)
                }
            }
        }
    case Commands.set.rawValue:
        printNoLn("row: ")
        let row = getPositiveIntValueFromCommandLine() - 1
        printNoLn("column: ")
        let column = getPositiveIntValueFromCommandLine() - 1
        printNoLn("value: ")
        let value = getIntValueFromCommandLine()
        do {
            try matrix.set(value, rowIndex: row, columnIndex: column)
            didModifyMatrix = true
        } catch {
            print(error)
        }
    case Commands.replace.rawValue:
        printNoLn("targetRow: ")
        let targetRow = getPositiveIntValueFromCommandLine() - 1
        printNoLn("coefficient: ")
        let coefficient = getIntValueFromCommandLine()
        printNoLn("sourceRow: ")
        let sourceRow = getPositiveIntValueFromCommandLine() - 1
        do {
            try matrix.rowReplace(targetRow: targetRow, coefficient: coefficient, sourceRow: sourceRow)
            didModifyMatrix = true
        } catch {
            print(error)
        }
    case Commands.scale.rawValue:
        printNoLn("targetRow: ")
        let targetRow = getPositiveIntValueFromCommandLine() - 1
        printNoLn("coefficient: ")
        let coefficient = getIntValueFromCommandLine()
        do {
            try matrix.rowScale(targetRow: targetRow, coefficient: coefficient)
            didModifyMatrix = true
        } catch {
            print(error)
        }
    case Commands.scaleDivide.rawValue:
        printNoLn("targetRow: ")
        let targetRow = getPositiveIntValueFromCommandLine() - 1
        printNoLn("denominator: ")
        let denominator = getIntValueFromCommandLine()
        
        enum DivisionError: Error { case error }
        
        do {
            var row = try matrix.getRow(targetRow)
            for i in 0..<row.count {
                guard row[i] % denominator == 0 else {
                    print("Sorry, this denominator cannot be used for integer division.")
                    throw DivisionError.error
                }
                row[i] /= denominator
            }
            try matrix.setRow(row: targetRow, values: row)
            didModifyMatrix = true
        } catch {
            print(error)
        }
    case Commands.interchange.rawValue:
        printNoLn("rowA: ")
        let rowA = getPositiveIntValueFromCommandLine() - 1
        printNoLn("rowB: ")
        let rowB = getPositiveIntValueFromCommandLine() - 1
        do {
            try matrix.rowInterchange(rowA: rowA, rowB: rowB)
            didModifyMatrix = true
        } catch {
            print(error)
        }
    default:
        break
    }
    
    if didModifyMatrix {
        print("\n\(matrix)\n")
    }
    
    printCommandPrompt()
}

