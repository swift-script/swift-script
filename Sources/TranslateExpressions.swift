extension IdentifierExpression {
    public func javaScript(with indentLevel: Int) -> String {
        return identifier
    }
}

extension FunctionCallExpression {
    public func javaScript(with indentLevel: Int) -> String {
        let f = expression.javaScript(with: indentLevel + 1)
        var args = arguments.map { $1.javaScript(with: indentLevel + 1) }
        if let closure = trailingClosure {
            args.append(closure.javaScript(with: indentLevel + 1))
        }
        let argsString = args.joined(separator: ", ")
        return "\(f)(\(argsString))"
    }
}
