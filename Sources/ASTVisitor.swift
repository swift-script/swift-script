public protocol ExpressionVisitor {
    associatedtype ExpressionResult
    // Literal
    func visit(_: ArrayLiteral) throws -> ExpressionResult
    func visit(_: DictionaryLiteral) throws -> ExpressionResult
    func visit(_: IntegerLiteral) throws -> ExpressionResult
    func visit(_: FloatingPointLiteral) throws -> ExpressionResult
    func visit(_: StringLiteral) throws -> ExpressionResult
    func visit(_: BooleanLiteral) throws -> ExpressionResult
    func visit(_: NilLiteral) throws -> ExpressionResult
    // Expressions
    func visit(_: IdentifierExpression) throws -> ExpressionResult
    func visit(_: SelfExpression) throws -> ExpressionResult
    func visit(_: SuperclassExpression) throws -> ExpressionResult
    func visit(_: ClosureExpression) throws -> ExpressionResult
    func visit(_: ParenthesizedExpression) throws -> ExpressionResult
    func visit(_: TupleExpression) throws -> ExpressionResult
    func visit(_: ImplicitMemberExpression) throws -> ExpressionResult
    func visit(_: WildcardExpression) throws -> ExpressionResult
    func visit(_: FunctionCallExpression) throws -> ExpressionResult
    func visit(_: InitializerExpression) throws -> ExpressionResult
    func visit(_: ExplicitMemberExpression) throws -> ExpressionResult
    func visit(_: PostfixSelfExpression) throws -> ExpressionResult
    func visit(_: DynamicTypeExpression) throws -> ExpressionResult
    func visit(_: SubscriptExpression) throws -> ExpressionResult
    // Operations
    func visit(_: BinaryOperation) throws -> ExpressionResult
    func visit(_: PrefixUnaryOperation) throws -> ExpressionResult
    func visit(_: PostfixUnaryOperation) throws -> ExpressionResult
    func visit(_: TernaryOperation) throws -> ExpressionResult
}

extension ArrayLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension DictionaryLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension IntegerLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension FloatingPointLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension StringLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension BooleanLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension NilLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension IdentifierExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension SelfExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension SuperclassExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension ClosureExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension ParenthesizedExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension TupleExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension ImplicitMemberExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension WildcardExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension FunctionCallExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension InitializerExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension ExplicitMemberExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension PostfixSelfExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension DynamicTypeExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension SubscriptExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension BinaryOperation {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension PrefixUnaryOperation {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension PostfixUnaryOperation {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}
extension TernaryOperation {
    public func accept<V : ExpressionVisitor>(_ v: V) throws -> V.ExpressionResult { return try v.visit(self) }
}


public protocol DeclarationVisitor {
    associatedtype DeclarationResult
    func visit(_: ImportDeclaration) throws -> DeclarationResult
    func visit(_: ConstantDeclaration) throws -> DeclarationResult
    func visit(_: VariableDeclaration) throws -> DeclarationResult
    func visit(_: TypeAliasDeclaration) throws -> DeclarationResult
    func visit(_: FunctionDeclaration) throws -> DeclarationResult
    func visit(_: EnumDeclaration) throws -> DeclarationResult
    func visit(_: StructDeclaration) throws -> DeclarationResult
    func visit(_: ClassDeclaration) throws -> DeclarationResult
    func visit(_: ProtocolDeclaration) throws -> DeclarationResult
    func visit(_: InitializerDeclaration) throws -> DeclarationResult
    func visit(_: DeinitializerDeclaration) throws -> DeclarationResult
    func visit(_: ExtensionDeclaration) throws -> DeclarationResult
    func visit(_: SubscriptDeclaration) throws -> DeclarationResult
    func visit(_: OperatorDeclaration) throws -> DeclarationResult
    func visit(_: PrecedenceGroupDeclaration) throws -> DeclarationResult
}

extension ImportDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension ConstantDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension VariableDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension TypeAliasDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension FunctionDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension EnumDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension StructDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension ClassDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension ProtocolDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension InitializerDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension DeinitializerDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension ExtensionDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension SubscriptDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension OperatorDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}
extension PrecedenceGroupDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) throws -> V.DeclarationResult { return try v.visit(self) }
}


public protocol StatementVisitor {
    associatedtype StatementResult
    func visit(_: ForInStatement) throws -> StatementResult
    func visit(_: WhileStatement) throws -> StatementResult
    func visit(_: RepeatWhileStatement) throws -> StatementResult
    func visit(_: IfStatement) throws -> StatementResult
    func visit(_: GuardStatement) throws -> StatementResult
    func visit(_: SwitchStatement) throws -> StatementResult
    func visit(_: LabeledStatement) throws -> StatementResult
    func visit(_: BreakStatement) throws -> StatementResult
    func visit(_: ContinueStatement) throws -> StatementResult
    func visit(_: FallthroughStatement) throws -> StatementResult
    func visit(_: ReturnStatement) throws -> StatementResult
    func visit(_: ThrowStatement) throws -> StatementResult
    func visit(_: DeferStatement) throws -> StatementResult
    func visit(_: DoStatement) throws -> StatementResult
    func visit(_: ExpressionStatement) throws -> StatementResult
    func visit(_: DeclarationStatement) throws -> StatementResult
}

extension ForInStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension WhileStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension RepeatWhileStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension IfStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension GuardStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension SwitchStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension LabeledStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension BreakStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension ContinueStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension FallthroughStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension ReturnStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension ThrowStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension DeferStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension DoStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension ExpressionStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}
extension DeclarationStatement {
    public func accept<V : StatementVisitor>(_ v: V) throws -> V.StatementResult { return try v.visit(self) }
}


public protocol TypeVisitor {
    associatedtype TypeResult
    func visit(_: ArrayType) throws -> TypeResult
    func visit(_: DictionaryType) throws -> TypeResult
    func visit(_: FunctionType) throws -> TypeResult
    func visit(_: TypeIdentifier) throws -> TypeResult
    func visit(_: TupleType) throws -> TypeResult
    func visit(_: OptionalType) throws -> TypeResult
    func visit(_: ImplicitlyUnwrappedOptionalType) throws -> TypeResult
    func visit(_: ProtocolCompositionType) throws -> TypeResult
}

extension ArrayType {
    public func accept<V : TypeVisitor>(_ v: V) throws -> V.TypeResult { return try v.visit(self) }
}
extension DictionaryType {
    public func accept<V : TypeVisitor>(_ v: V) throws -> V.TypeResult { return try v.visit(self) }
}
extension FunctionType {
    public func accept<V : TypeVisitor>(_ v: V) throws -> V.TypeResult { return try v.visit(self) }
}
extension TypeIdentifier {
    public func accept<V : TypeVisitor>(_ v: V) throws -> V.TypeResult { return try v.visit(self) }
}
extension TupleType {
    public func accept<V : TypeVisitor>(_ v: V) throws -> V.TypeResult { return try v.visit(self) }
}
extension OptionalType {
    public func accept<V : TypeVisitor>(_ v: V) throws -> V.TypeResult { return try v.visit(self) }
}
extension ImplicitlyUnwrappedOptionalType {
    public func accept<V : TypeVisitor>(_ v: V) throws -> V.TypeResult { return try v.visit(self) }
}
extension ProtocolCompositionType {
    public func accept<V : TypeVisitor>(_ v: V) throws -> V.TypeResult { return try v.visit(self) }
}

public protocol ASTVisitor: DeclarationVisitor, ExpressionVisitor, StatementVisitor, TypeVisitor {
}
