import SwiftAST


// Helper functions

func sameTypeAndEqual<LType : Equatable, RType>(to lhs: LType) -> (RType) -> Bool {
    return { rhs in
        guard let rhs = rhs as? LType else { return false }
        return lhs == rhs
    }
}

func isNonNullEqual<T>(_ lhs: T?, _ rhs: T?, test: (T, T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?): return test(l, r)
    case (nil, nil): return true
    default: return false
    }
}

func isElementsEqual<T>(_ lhs: [T], _ rhs: [T], where elementEqual: (T, T) -> Bool) -> Bool {
    if lhs.count != rhs.count { return false }
    for (lhs, rhs) in zip(lhs, rhs) {
        if !elementEqual(lhs, rhs) { return false }
    }
    return true
}

// Node equals

func == (lhs: Declaration, rhs: Declaration) -> Bool {
    return try! lhs.accept(DeclarationEqual())(rhs)
}
func == (lhs: Declaration?, rhs: Declaration?) -> Bool {
    return isNonNullEqual(lhs, rhs) { $0 == $1 }
}
func == (lhs: [Declaration], rhs: [Declaration]) -> Bool {
    return isElementsEqual(lhs, rhs) { $0 == $1 }
}
func == (lhs: [Declaration]?, rhs: [Declaration]?) -> Bool {
    return isNonNullEqual(lhs, rhs) { $0 == $1 }
}

func == (lhs: Statement, rhs: Statement) -> Bool {
    return try! lhs.accept(StatementEqual())(rhs)
}
func == (lhs: Statement?, rhs: Statement?) -> Bool {
    return isNonNullEqual(lhs, rhs) { $0 == $1 }
}
func == (lhs: [Statement], rhs: [Statement]) -> Bool {
    return isElementsEqual(lhs, rhs) { $0 == $1 }
}
func == (lhs: [Statement]?, rhs: [Statement]?) -> Bool {
    return isNonNullEqual(lhs, rhs) { $0 == $1 }
}

func == (lhs: Expression, rhs: Expression) -> Bool {
    return try! lhs.accept(ExpressionEqual())(rhs)
}
func == (lhs: Expression?, rhs: Expression?) -> Bool {
    return isNonNullEqual(lhs, rhs) { $0 == $1 }
}
func == (lhs: [Expression], rhs: [Expression]) -> Bool {
    return isElementsEqual(lhs, rhs) { $0 == $1 }
}
func == (lhs: [Expression]?, rhs: [Expression]?) -> Bool {
    return isNonNullEqual(lhs, rhs) { $0 == $1 }
}

func == (lhs: Type_, rhs: Type_) -> Bool {
    return try! lhs.accept(TypeEqual())(rhs)
}
func == (lhs: Type_?, rhs: Type_?) -> Bool {
    return isNonNullEqual(lhs, rhs) { $0 == $1 }
}
func == (lhs: [Type_], rhs: [Type_]) -> Bool {
    return isElementsEqual(lhs, rhs) { $0 == $1 }
}
func == (lhs: [Type_]?, rhs: [Type_]?) -> Bool {
    return isNonNullEqual(lhs, rhs) { $0 == $1 }
}

struct DeclarationEqual: DeclarationVisitor {
    func visit(_ lhs: ImportDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ConstantDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: VariableDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: VariableDeclaration.GetSet) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: TypeAliasDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: FunctionDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: EnumDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: StructDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ClassDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ProtocolDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: InitializerDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: DeinitializerDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ExtensionDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: SubscriptDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: OperatorDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: PrecedenceGroupDeclaration) -> (Declaration) -> Bool { return sameTypeAndEqual(to: lhs) }
}

struct StatementEqual : StatementVisitor {
    func visit(_ lhs: ForInStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: WhileStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: RepeatWhileStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: IfStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: GuardStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: SwitchStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: LabeledStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: BreakStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ContinueStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: FallthroughStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ReturnStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ThrowStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: DeferStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: DoStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ExpressionStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: DeclarationStatement) -> (Statement) -> Bool { return sameTypeAndEqual(to: lhs) }
}

struct ExpressionEqual : ExpressionVisitor {
    // Literal
    func visit(_ lhs: ArrayLiteral) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: SwiftAST.DictionaryLiteral) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: IntegerLiteral) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: FloatingPointLiteral) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: StringLiteral) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: BooleanLiteral) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: NilLiteral) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    // Expressions
    func visit(_ lhs: IdentifierExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: SelfExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: SuperclassExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ClosureExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ParenthesizedExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: TupleExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ImplicitMemberExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: WildcardExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: InterpolatedStringLiteral) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: FunctionCallExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: InitializerExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ExplicitMemberExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: PostfixSelfExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: DynamicTypeExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: SubscriptExpression) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    // Operations
    func visit(_ lhs: BinaryOperation) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: PrefixUnaryOperation) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: PostfixUnaryOperation) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: TernaryOperation) -> (Expression) -> Bool { return sameTypeAndEqual(to: lhs) }
}

struct TypeEqual : TypeVisitor {
    func visit(_ lhs: ArrayType) -> (Type_) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: DictionaryType) -> (Type_) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: FunctionType) -> (Type_) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: TypeIdentifier) -> (Type_) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: TupleType) -> (Type_) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: OptionalType) -> (Type_) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ImplicitlyUnwrappedOptionalType) -> (Type_) -> Bool { return sameTypeAndEqual(to: lhs) }
    func visit(_ lhs: ProtocolCompositionType) -> (Type_) -> Bool { return sameTypeAndEqual(to: lhs) }
}

// Equtable implementations for Declarations

extension Condition : Equatable {
    public static func == (lhs: Condition, rhs: Condition) -> Bool {
        switch (lhs, rhs) {
        case let (.boolean(l), .boolean(r)):
            return l == r
        case let (.optionalBinding(l_isVar, l_name, l_init),
                  .optionalBinding(r_isVar, r_name, r_init)):
            return l_isVar == r_isVar && l_name == r_name && l_init == r_init
        default:
            return false
        }
    }
}
extension ElseClause : Equatable {
    public static func == (lhs: ElseClause, rhs: ElseClause) -> Bool {
        switch (lhs, rhs) {
        case let (.else_(l), .else_(r)):
            return l == r
        case let (.elseIf(l), .elseIf(r)):
            return l == r
        default:
            return false
        }
    }
}
extension Parameter : Equatable {
    public static func == (lhs: Parameter, rhs: Parameter) -> Bool {
        return lhs.externalParameterName == rhs.externalParameterName
            && lhs.localParameterName == rhs.localParameterName
            && lhs.type == rhs.type
            && lhs.defaultArgument == rhs.defaultArgument
    }
}
extension ImportDeclaration : Equatable {
    public static func == (lhs: ImportDeclaration, rhs: ImportDeclaration) -> Bool {
        fatalError("unsupported")
    }
}
extension ConstantDeclaration : Equatable {
    public static func == (lhs: ConstantDeclaration, rhs: ConstantDeclaration) -> Bool {
        return lhs.isStatic == rhs.isStatic
            && lhs.name == rhs.name
            && lhs.type == rhs.type
            && lhs.expression == rhs.expression
    }
}
extension VariableDeclaration : Equatable {
    public static func == (lhs: VariableDeclaration, rhs: VariableDeclaration) -> Bool {
        return lhs.isStatic == rhs.isStatic
            && lhs.name == rhs.name
            && lhs.type == rhs.type
            && lhs.expression == rhs.expression
    }
}
extension TypeAliasDeclaration : Equatable {
    public static func == (lhs: TypeAliasDeclaration, rhs: TypeAliasDeclaration) -> Bool {
        return lhs.name == rhs.name
            && lhs.type == rhs.type
    }
}
extension FunctionDeclaration : Equatable {
    public static func == (lhs: FunctionDeclaration, rhs: FunctionDeclaration) -> Bool {
        return lhs.isStatic == rhs.isStatic
            && lhs.name == rhs.name
            && lhs.hasThrows == rhs.hasThrows
            && lhs.arguments == rhs.arguments
    }
}
extension EnumDeclaration : Equatable {
    public static func == (lhs: EnumDeclaration, rhs: EnumDeclaration) -> Bool {
        fatalError("unsupported")
    }
}
extension StructDeclaration : Equatable {
    public static func == (lhs: StructDeclaration, rhs: StructDeclaration) -> Bool {
        return lhs.name == rhs.name
            && lhs.superTypes == rhs.superTypes
            && lhs.members == rhs.members
    }
}
extension ClassDeclaration : Equatable {
    public static func == (lhs: ClassDeclaration, rhs: ClassDeclaration) -> Bool {
        return lhs.name == rhs.name
            && lhs.superTypes == rhs.superTypes
            && lhs.members == rhs.members
    }
}
extension ProtocolDeclaration : Equatable {
    public static func == (lhs: ProtocolDeclaration, rhs: ProtocolDeclaration) -> Bool {
        return lhs.name == rhs.name
    }
}
extension InitializerDeclaration : Equatable {
    public static func == (lhs: InitializerDeclaration, rhs: InitializerDeclaration) -> Bool {
        return lhs.arguments == rhs.arguments
            && lhs.isFailable == rhs.isFailable
            && lhs.hasThrows == rhs.hasThrows
            && lhs.body == rhs.body
    }
}
extension DeinitializerDeclaration : Equatable {
    public static func == (lhs: DeinitializerDeclaration, rhs: DeinitializerDeclaration) -> Bool {
        fatalError("unsupported")
    }
}
extension ExtensionDeclaration : Equatable {
    public static func == (lhs: ExtensionDeclaration, rhs: ExtensionDeclaration) -> Bool {
        fatalError("unsupported")
    }
}
extension SubscriptDeclaration : Equatable {
    public static func == (lhs: SubscriptDeclaration, rhs: SubscriptDeclaration) -> Bool {
        fatalError("unsupported")
    }
}
extension OperatorDeclaration : Equatable {
    public static func == (lhs: OperatorDeclaration, rhs: OperatorDeclaration) -> Bool {
        fatalError("unsupported")
    }
}
extension PrecedenceGroupDeclaration : Equatable {
    public static func == (lhs: PrecedenceGroupDeclaration, rhs: PrecedenceGroupDeclaration) -> Bool {
        fatalError("unsupported")
    }
}

// Equatable implementations for Statements

extension ForInStatement : Equatable {
    public static func == (lhs: ForInStatement, rhs: ForInStatement) -> Bool {
        return lhs.collection == rhs.collection
            && lhs.item == rhs.item
            && lhs.statements == rhs.statements
    }
}
extension WhileStatement : Equatable {
    public static func == (lhs: WhileStatement, rhs: WhileStatement) -> Bool {
        return lhs.condition == rhs.condition
            && lhs.statements == rhs.statements
    }
}
extension RepeatWhileStatement : Equatable {
    public static func == (lhs: RepeatWhileStatement, rhs: RepeatWhileStatement) -> Bool {
        return lhs.condition == rhs.condition
            && lhs.statements == rhs.statements
    }
}
extension IfStatement : Equatable {
    public static func == (lhs: IfStatement, rhs: IfStatement) -> Bool {
        return lhs.condition == rhs.condition
            && lhs.statements == rhs.statements
            && lhs.elseClause == rhs.elseClause
    }
}
extension GuardStatement : Equatable {
    public static func == (lhs: GuardStatement, rhs: GuardStatement) -> Bool {
        return lhs.condition == rhs.condition
            && lhs.statements == rhs.statements
    }
}
extension SwitchStatement : Equatable {
    public static func == (lhs: SwitchStatement, rhs: SwitchStatement) -> Bool {
        fatalError("unsupported")
    }
}
extension LabeledStatement : Equatable {
    public static func == (lhs: LabeledStatement, rhs: LabeledStatement) -> Bool {
        return lhs.labelName == rhs.labelName
            && lhs.statement == rhs.statement
    }
}
extension BreakStatement : Equatable {
    public static func == (lhs: BreakStatement, rhs: BreakStatement) -> Bool {
        return lhs.labelName == rhs.labelName
    }
}
extension ContinueStatement : Equatable {
    public static func == (lhs: ContinueStatement, rhs: ContinueStatement) -> Bool {
        return lhs.labelName == rhs.labelName
    }
}
extension FallthroughStatement : Equatable {
    public static func == (lhs: FallthroughStatement, rhs: FallthroughStatement) -> Bool {
        return true
    }
}
extension ReturnStatement : Equatable {
    public static func == (lhs: ReturnStatement, rhs: ReturnStatement) -> Bool {
        return lhs.expression == rhs.expression
    }
}
extension ThrowStatement : Equatable {
    public static func == (lhs: ThrowStatement, rhs: ThrowStatement) -> Bool {
        return lhs.expression == rhs.expression
    }
}
extension DeferStatement : Equatable {
    public static func == (lhs: DeferStatement, rhs: DeferStatement) -> Bool {
        fatalError("unsupported")
    }
}
extension DoStatement : Equatable {
    public static func == (lhs: DoStatement, rhs: DoStatement) -> Bool {
        return lhs.statements == rhs.statements
            // TODO: && lhs.catchClauses == rhs.catchClauses
    }
}
extension ExpressionStatement : Equatable {
    public static func == (lhs: ExpressionStatement, rhs: ExpressionStatement) -> Bool {
        return lhs.expression == rhs.expression
    }
}
extension DeclarationStatement : Equatable {
    public static func == (lhs: DeclarationStatement, rhs: DeclarationStatement) -> Bool {
        return lhs.declaration == rhs.declaration
    }
}

// Equatable implementations for Expressions

extension ArrayLiteral : Equatable {
    public static func == (lhs: ArrayLiteral, rhs: ArrayLiteral) -> Bool {
        return lhs.value == rhs.value
    }
}
extension SwiftAST.DictionaryLiteral : Equatable {
    public static func == (lhs: SwiftAST.DictionaryLiteral, rhs: SwiftAST.DictionaryLiteral) -> Bool {
        return isElementsEqual(lhs.value, rhs.value) { l, r in
            l.0 == r.0 && l.1 == r.1
        }
    }
}
extension IntegerLiteral : Equatable {
    public static func == (lhs: IntegerLiteral, rhs: IntegerLiteral) -> Bool {
        return lhs.value == rhs.value
    }
}
extension FloatingPointLiteral : Equatable {
    public static func == (lhs: FloatingPointLiteral, rhs: FloatingPointLiteral) -> Bool {
        return lhs.value == rhs.value
    }
}
extension StringLiteral : Equatable {
    public static func == (lhs: StringLiteral, rhs: StringLiteral) -> Bool {
        return lhs.value == rhs.value
    }
}
extension BooleanLiteral : Equatable {
    public static func == (lhs: BooleanLiteral, rhs: BooleanLiteral) -> Bool {
        return lhs.value == rhs.value
    }
}
extension NilLiteral : Equatable {
    public static func == (lhs: NilLiteral, rhs: NilLiteral) -> Bool {
        return true
    }
}

extension IdentifierExpression : Equatable {
    public static func == (lhs: IdentifierExpression, rhs: IdentifierExpression) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
extension SelfExpression : Equatable {
    public static func == (lhs: SelfExpression, rhs: SelfExpression) -> Bool {
        return true
    }
}
extension SuperclassExpression : Equatable {
    public static func == (lhs: SuperclassExpression, rhs: SuperclassExpression) -> Bool {
        return true
    }
}
extension ClosureExpression : Equatable {
    public static func == (lhs: ClosureExpression, rhs: ClosureExpression) -> Bool {
        return isElementsEqual(lhs.arguments, rhs.arguments, where: { l, r in l.0 == r.0 && l.1 == r.1 })
            && lhs.hasThrows == rhs.hasThrows
            && lhs.result == rhs.result
            && lhs.statements == rhs.statements
    }
}
extension ParenthesizedExpression : Equatable {
    public static func == (lhs: ParenthesizedExpression, rhs: ParenthesizedExpression) -> Bool {
        return lhs.expression == rhs.expression
    }
}
extension TupleExpression : Equatable {
    public static func == (lhs: TupleExpression, rhs: TupleExpression) -> Bool {
        return isElementsEqual(lhs.elements, rhs.elements, where: { l, r in l.0 == r.0 && l.1 == r.1 })
    }
}
extension ImplicitMemberExpression : Equatable {
    public static func == (lhs: ImplicitMemberExpression, rhs: ImplicitMemberExpression) -> Bool {
        fatalError("unsupported")
    }
}
extension WildcardExpression : Equatable {
    public static func == (lhs: WildcardExpression, rhs: WildcardExpression) -> Bool {
        return true
    }
}
extension InterpolatedStringLiteral : Equatable {
    public static func == (lhs: InterpolatedStringLiteral, rhs: InterpolatedStringLiteral) -> Bool {
        return lhs.segments == rhs.segments
    }
}
extension FunctionCallExpression : Equatable {
    public static func == (lhs: FunctionCallExpression, rhs: FunctionCallExpression) -> Bool {
        return lhs.expression == rhs.expression
            && isElementsEqual(lhs.arguments, rhs.arguments, where: { l, r in l.0 == r.0 && l.1 == r.1 })
            && lhs.trailingClosure == rhs.trailingClosure
    }
}
extension InitializerExpression : Equatable {
    public static func == (lhs: InitializerExpression, rhs: InitializerExpression) -> Bool {
        fatalError("unsupported")
    }
}
extension ExplicitMemberExpression : Equatable {
    public static func == (lhs: ExplicitMemberExpression, rhs: ExplicitMemberExpression) -> Bool {
        return lhs.expression == rhs.expression
            && lhs.member == rhs.member
    }
}
extension PostfixSelfExpression : Equatable {
    public static func == (lhs: PostfixSelfExpression, rhs: PostfixSelfExpression) -> Bool {
        fatalError("unsupported")
    }
}
extension DynamicTypeExpression : Equatable {
    public static func == (lhs: DynamicTypeExpression, rhs: DynamicTypeExpression) -> Bool {
        return lhs.expression == rhs.expression
    }
}
extension SubscriptExpression : Equatable {
    public static func == (lhs: SubscriptExpression, rhs: SubscriptExpression) -> Bool {
        return lhs.expression == rhs.expression
            && lhs.arguments == rhs.arguments
    }
}
extension BinaryOperation : Equatable {
    public static func == (lhs: BinaryOperation, rhs: BinaryOperation) -> Bool {
        return lhs.operatorSymbol == rhs.operatorSymbol
            && lhs.leftOperand == rhs.leftOperand
            && lhs.rightOperand == rhs.rightOperand
    }
}
extension PrefixUnaryOperation : Equatable {
    public static func == (lhs: PrefixUnaryOperation, rhs: PrefixUnaryOperation) -> Bool {
        return lhs.operatorSymbol == rhs.operatorSymbol
            && lhs.operand == rhs.operand
    }
}
extension PostfixUnaryOperation : Equatable {
    public static func == (lhs: PostfixUnaryOperation, rhs: PostfixUnaryOperation) -> Bool {
        return lhs.operatorSymbol == rhs.operatorSymbol
            && lhs.operand == rhs.operand
    }
}
extension TernaryOperation : Equatable {
    public static func == (lhs: TernaryOperation, rhs: TernaryOperation) -> Bool {
        return lhs.firstOperand == rhs.firstOperand
            && lhs.secondOperand == rhs.secondOperand
            && lhs.thirdOperand == rhs.thirdOperand
    }
}

// Equatable implementations for Types

extension ArrayType : Equatable {
    public static func == (lhs: ArrayType, rhs: ArrayType) -> Bool {
        return lhs.type == rhs.type
    }
}
extension DictionaryType : Equatable {
    public static func == (lhs: DictionaryType, rhs: DictionaryType) -> Bool {
        return lhs.keyType == rhs.keyType
            && lhs.valueType == rhs.valueType
    }
}
extension FunctionType : Equatable {
    public static func == (lhs: FunctionType, rhs: FunctionType) -> Bool {
        return lhs.arguments == rhs.arguments
            && lhs.returnType == rhs.returnType
    }
}
extension TypeIdentifier : Equatable {
    public static func == (lhs: TypeIdentifier, rhs: TypeIdentifier) -> Bool {
        return lhs.names == rhs.names
    }
}
extension TupleType : Equatable {
    public static func == (lhs: TupleType, rhs: TupleType) -> Bool {
        return isElementsEqual(lhs.elements, rhs.elements, where: { l, r in l.0 == r.0 && l.1 == r.1 })
    }
}
extension OptionalType : Equatable {
    public static func == (lhs: OptionalType, rhs: OptionalType) -> Bool {
        return lhs.type == rhs.type
    }
}
extension ImplicitlyUnwrappedOptionalType : Equatable {
    public static func == (lhs: ImplicitlyUnwrappedOptionalType, rhs: ImplicitlyUnwrappedOptionalType) -> Bool {
        return lhs.type == rhs.type
    }
}
extension ProtocolCompositionType : Equatable {
    public static func == (lhs: ProtocolCompositionType, rhs: ProtocolCompositionType) -> Bool {
        return lhs.types == rhs.types
    }
}
