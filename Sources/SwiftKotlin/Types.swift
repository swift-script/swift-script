import SwiftAST

extension KotlinTranslator {
    func visit(_ n: ArrayType) throws -> String {
        let type = try n.type.accept(self)
        return "Array<\(type)>"
    }

    func visit(_ n: DictionaryType) throws -> String{
        let keyType = try n.keyType.accept(self)
        let valueType = try n.valueType.accept(self)
        return "Map<\(keyType), \(valueType)>"
    }

    func visit(_ n: FunctionType) throws -> String {
        var arguments = try n.arguments
            .map { try $0.accept(self) }
            .joined(separator: ", ")
        arguments = "(" + arguments  + ")"
        let returnType = try n.returnType.accept(self)
        return "\(arguments) -> \(returnType)"
    }

    /// - Warning: Only uses first type name.
    func visit(_ n: TypeIdentifier) throws -> String {
        guard let firstType = n.names.first else { return "Any" }

        switch firstType {
        case "Bool": return "Boolean"
        default: return firstType
        }
    }

    func visit(_ n: TupleType) throws -> String {
        throw UnimplementedError()
    }

    func visit(_ n: OptionalType) throws -> String {
        return "\(try n.type.accept(self))?"
    }

    func visit(_ n: ImplicitlyUnwrappedOptionalType) throws -> String {
        return "\(try n.type.accept(self))?"
    }

    func visit(_ n: ProtocolCompositionType) throws -> String {
        guard let firstType = n.types.first else {
            throw UnimplementedError()
        }
        return "\(try firstType.accept(self))"
    }
}
