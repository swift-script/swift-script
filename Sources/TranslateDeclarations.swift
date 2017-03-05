//
//  TranslateDeclarations.swift
//  SwiftScript
//
//  Created by masaru-ichikawa on 2017/03/04.
//
//

import Foundation

extension ConstantDeclaration {
    public func javaScript(with indentLevel: Int) -> String {
        let staticVar = isStatic ? "static " : ""
        let assignment: String
        if let expression = expression {
            let statement = expression.javaScript(with: indentLevel + 1) + ";"
            assignment = " = \(statement)"
        } else {
            assignment = ""
        }
        return "\(staticVar)const \(name)\(assignment)"
    }
}

extension VariableDeclaration {
    public func javaScript(with indentLevel: Int) -> String {
        let staticVar = isStatic ? "static " : ""
        let assignment: String
        if let expression = expression {
            let statement = expression.javaScript(with: indentLevel + 1) + ";"
            assignment = " = \(statement)"
        } else {
            assignment = ""
        }
        return "\(staticVar)let \(name)\(assignment)"
    }
}

extension FunctionDeclaration {
    public func javaScript(with indentLevel: Int) -> String {
        // TODO: should implement default value assignment
        let args = arguments.map { $0.1 }.joined(separator: ", ")
        guard let body = body else {
            return "function \(name)(\(args)) {}"
        }
        let bodyLines = transpileStatements(statements: body, indentLevel: indentLevel + 1)
        let spaces = String(repeating: "    ", count: indentLevel)
        let newLine = bodyLines.isEmpty ? "" : "\n"
        return "\(spaces)function \(name)(\(args)) {\n\(bodyLines)\(newLine)\(spaces)}"
    }
}

extension ClassDeclaration­ {
    public func javaScript(with indentLevel: Int) -> String {
        let decls = members.map { $0.javaScript(with: indentLevel + 1) }.joined(separator: "\n")
        let spaces = String(repeating: "    ", count: indentLevel)
        let newLine = decls.isEmpty ? "" : "\n"
        // TODO: should implement extends
        return "\(spaces)class \(name) {\n\(decls)\(newLine)\(spaces)}"
    }
}
