//
//  Matrix.swift
//  ElementaryRowOperations
//
//  Created by Vincent C. on 2/20/20.
//  Copyright © 2020 Vincent C. All rights reserved.
//

import Foundation

enum MatrixError: Error {
    case indexOutOfRange, invalidNumberOfElements
}

public class Matrix<T: Numeric> : CustomStringConvertible {
    
    private var matrix: [[T]]
    private var _rows: Int
    private var _columns: Int
    
    public var rows: Int { get { return _rows } }
    public var columns: Int { get { return _columns } }
    
    public var description: String {
        get {
            var lines: [String] = [String]()
            for i in 0..<rows {
                lines.append("r\(i + 1) : ")
            }
            
            for column in matrix {
                for i in 0..<rows {
                    lines[i] += "\(column[i]) "
                }
            }
            return lines.joined(separator: "\n")
        }
    }
    
    public init(rows: Int, columns: Int) {
        self._rows = rows
        self._columns = columns
        matrix = [[T]](repeating:
            [T](
                repeating: 0, count: rows
            ), count: columns)
    }
    
    /// Tests if `value` is within the range of `0..<rangeCount`
    private func testOutOfRange(value: Int, rangeCount: Int) throws {
        if value < 0 || value >= rangeCount {
            throw MatrixError.indexOutOfRange
        }
    }
    
    /// Tests if `rowIndex` and `columnIndex` are within their respective ranges
    private func testOutOfRange(rowIndex: Int? = nil, columnIndex: Int? = nil) throws {
        if let rI = rowIndex {
            try testOutOfRange(value: rI, rangeCount: rows)
        }
        if let cI = columnIndex {
            try testOutOfRange(value: cI, rangeCount: columns)
        }
    }
    
    /// Sets a new value at a position in the matrix
    public func set(_ value: T, rowIndex: Int, columnIndex: Int) throws {
        try testOutOfRange(rowIndex: rowIndex, columnIndex: columnIndex)
        matrix[columnIndex][rowIndex] = value
    }
    
    /// Get the row
    public func getRow(_ row: Int) throws -> [T] {
        try testOutOfRange(rowIndex: row)
        
        var output = [T]()
        for i in 0..<columns {
            output.append(matrix[i][row])
        }
        return output
    }
    
    /// Set the row
    public func setRow(row: Int, values: [T]) throws {
        try testOutOfRange(rowIndex: row)
        guard values.count == columns else {
            throw MatrixError.invalidNumberOfElements
        }
        
        for i in 0..<columns {
            matrix[i][row] = values[i]
        }
    }
    
    /// Perform elementary row operation "replacement" on a row
    public func rowReplace(targetRow: Int, coefficient: T, sourceRow: Int) throws {
        try testOutOfRange(rowIndex: targetRow)
        try testOutOfRange(rowIndex: sourceRow)
        
        for i in 0..<columns {
            matrix[i][targetRow] += coefficient * matrix[i][sourceRow]
        }
    }
    
    /// Perform elementary row operation "scaling" on a row
    public func rowScale(targetRow: Int, coefficient: T) throws {
        try testOutOfRange(rowIndex: targetRow)
        
        for i in 0..<columns {
            matrix[i][targetRow] *= coefficient
        }
    }
    
    /// Perform elementary row operation "interchange" on a row
    public func rowInterchange(rowA: Int, rowB: Int) throws {
        try testOutOfRange(rowIndex: rowA)
        try testOutOfRange(rowIndex: rowB)
        
        for i in 0..<columns {
            let temp = matrix[i][rowA]
            matrix[i][rowA] = matrix[i][rowB]
            matrix[i][rowB] = temp
        }
    }
    
}
