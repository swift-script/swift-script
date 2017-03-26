struct SupportingLibrary {
    static let defaultNamespace = "$ss"
    
    struct Function {
        let name: String
        let declaration: String
        
        func callExpression(expression: Expression, arguments: [Expression], namepace: String = SupportingLibrary.defaultNamespace) -> FunctionCallExpression {
            return FunctionCallExpression(expression: ExplicitMemberExpression(expression: expression, member: name), arguments: arguments.map { (nil, $0) }, trailingClosure: nil)
        }
    }
    enum Support {
        case forcedCast
        case optionalCast
        case forcedTry
        case optionalTry
        case forcedUnwrapping
        case optionalChaining
        case range
        case closedRange
        case typeChecking
        case nilCoalescing

        var function: Function {
            switch self {
            case .forcedCast:
                return Function(
                    name: "asx",
                    declaration: "function asx(expression, type_test) {\n  if type_test() {\n    throw Error(\"Failed to cast\");\n  }\n  return expression;\n}"
                )
            case .optionalCast:
                return Function(
                    name: "asq",
                    declaration: "function asq(expression, type_test) {\n  return type_test() ? expression : null;\n}"
                )
            case .forcedTry:
                return Function(
                    name: "tryx",
                    declaration: "function tryx(command) {\n  try {\n    return command();\n  }\n  catch(e) {\n    // TODO: some force stopping method\n    throw e;\n  }\n}"
                )
            case .optionalTry:
                return Function(
                    name: "tryq",
                    declaration: "function tryq(command) {\n  try {\n    return command();\n  }\n  catch(e) {\n    return null;\n  }\n}"
                )
            case .forcedUnwrapping:
                return Function(
                    name: "x",
                    declaration: "function x(expression) {\n  const is_null = (expression == null || typeof expression == 'undefined');\n  if (is_null) {\n    throw Error(\"Failed unwrapping\");\n  }\n  return expression;\n}"
                )
            case .optionalChaining:
                return Function(
                    name: "q",
                    declaration: "function q(expression, command) {\n  const is_null = (expression == null || typeof expression == 'undefined');\n  return is_null ? null : command();\n}"
                )
            case .range:
                return Function(
                    name: "range",
                    declaration: "function range(from, to) {\n  return (function* () {\n    var current = from;\n    while (current < to) {\n      yield current++;\n    }\n  })();\n}"
                )
            case .closedRange:
                return Function(
                    name: "closedRange",
                    declaration: "function closedRange(from, to) {\n  return (function* () {\n    var current = from;\n    while (current <= to) {\n      yield current++;\n    }\n  })();\n}"
                )
            case .typeChecking:
                return Function(
                    name: "is",
                    declaration: "function is(expression, type) {\n  if (type == String) {\n    return typeof (expression) == 'string' || expression instanceof String;\n  } else if (type == Number) {\n    return typeof (expression) == 'number' || expression instanceof Number;\n  }\n  return expression instanceof type;\n}"
                )
            case .nilCoalescing:
                return Function(
                    name: "qq",
                    declaration: "function qq(expression, value) {\n  const is_null = (expression == null || typeof expression == 'undefined');\n  return is_null ? value : expression;\n}"
                )
            }
        }
    }

    private static func addIndent(to text: String, indentLevel: Int) -> String {
        let spaces = indent(of: indentLevel)
        return (text.components(separatedBy: "\n").map { spaces + $0 }).joined(separator: "\n")
    }

    static func javaScript(for supports: Set<Support>, namespace: String = defaultNamespace) -> String {
        let localVariableName = "ss"
        let functionDeclarations = supports.map { support -> String in
            let function = support.function
            let declaration = addIndent(to: function.declaration, indentLevel: 1)
            return "\(declaration)\n\(indent(of: 1))\(localVariableName).\(function.name) = \(function.name);"
        }.joined(separator: "\n")

        return [
            "\(namespace) = {};",
            "((\(localVariableName)) => {",
            functionDeclarations,
            "})(\(namespace));"
        ].joined(separator: "\n")
    }
}
