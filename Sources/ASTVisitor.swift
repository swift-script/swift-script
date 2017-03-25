public protocol ExpressionVisitor {
    associatedtype ExpressionResult
    // Literal
    func visit(_: ArrayLiteral) -> ExpressionResult
    func visit(_: DictionaryLiteral) -> ExpressionResult
    func visit(_: IntegerLiteral) -> ExpressionResult
    func visit(_: FloatingPointLiteral) -> ExpressionResult
    func visit(_: StringLiteral) -> ExpressionResult
    func visit(_: BooleanLiteral) -> ExpressionResult
    func visit(_: NilLiteral) -> ExpressionResult
    // Expressions
    func visit(_: IdentifierExpression) -> ExpressionResult
    func visit(_: SelfExpression) -> ExpressionResult
    func visit(_: SuperclassExpression) -> ExpressionResult
    func visit(_: ClosureExpression) -> ExpressionResult
    func visit(_: ParenthesizedExpression) -> ExpressionResult
    func visit(_: TupleExpression) -> ExpressionResult
    func visit(_: ImplicitMemberExpression) -> ExpressionResult
    func visit(_: WildcardExpression) -> ExpressionResult
    func visit(_: FunctionCallExpression) -> ExpressionResult
    func visit(_: InitializerExpression) -> ExpressionResult
    func visit(_: ExplicitMemberExpression) -> ExpressionResult
    func visit(_: PostfixSelfExpression) -> ExpressionResult
    func visit(_: DynamicTypeExpression) -> ExpressionResult
    func visit(_: SubscriptExpression) -> ExpressionResult    
    // Operations
    func visit(_: BinaryOperation) -> ExpressionResult
    func visit(_: PrefixUnaryOperation) -> ExpressionResult
    func visit(_: PostfixUnaryOperation) -> ExpressionResult
    func visit(_: TernaryOperation) -> ExpressionResult
}

extension ArrayLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension DictionaryLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension IntegerLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension FloatingPointLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension StringLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension BooleanLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension NilLiteral {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension IdentifierExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension SelfExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension SuperclassExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension ClosureExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension ParenthesizedExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension TupleExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension ImplicitMemberExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension WildcardExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension FunctionCallExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension InitializerExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension ExplicitMemberExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension PostfixSelfExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension DynamicTypeExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension SubscriptExpression {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension BinaryOperation {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension PrefixUnaryOperation {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension PostfixUnaryOperation {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}
extension TernaryOperation {
    public func accept<V : ExpressionVisitor>(_ v: V) -> V.ExpressionResult { return v.visit(self) }
}


public protocol DeclarationVisitor {
    associatedtype DeclarationResult
    func visit(_: ImportDeclaration) -> DeclarationResult
    func visit(_: ConstantDeclaration) -> DeclarationResult
    func visit(_: VariableDeclaration) -> DeclarationResult
    func visit(_: TypeAliasDeclaration) -> DeclarationResult
    func visit(_: FunctionDeclaration) -> DeclarationResult
    func visit(_: EnumDeclaration­) -> DeclarationResult
    func visit(_: StructDeclaration­) -> DeclarationResult
    func visit(_: ClassDeclaration­) -> DeclarationResult
    func visit(_: ProtocolDeclaration­) -> DeclarationResult
    func visit(_: InitializerDeclaration­) -> DeclarationResult
    func visit(_: DeinitializerDeclaration­) -> DeclarationResult
    func visit(_: ExtensionDeclaration­) -> DeclarationResult
    func visit(_: SubscriptDeclaration­) -> DeclarationResult
    func visit(_: OperatorDeclaration­) -> DeclarationResult
    func visit(_: PrecedenceGroupDeclaration­) -> DeclarationResult
}

extension ImportDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension ConstantDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension VariableDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension TypeAliasDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension FunctionDeclaration {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension EnumDeclaration­ {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension StructDeclaration­ {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension ClassDeclaration­ {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension ProtocolDeclaration­ {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension InitializerDeclaration­ {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension DeinitializerDeclaration­ {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension ExtensionDeclaration­ {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension SubscriptDeclaration­ {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension OperatorDeclaration­ {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}
extension PrecedenceGroupDeclaration­ {
    public func accept<V : DeclarationVisitor>(_ v: V) -> V.DeclarationResult { return v.visit(self) }
}


public protocol StatementVisitor {
    associatedtype StatementResult
    func visit(_: ForInStatement) -> StatementResult
    func visit(_: WhileStatement) -> StatementResult
    func visit(_: RepeatWhileStatement) -> StatementResult
    func visit(_: IfStatement) -> StatementResult
    func visit(_: GuardStatement) -> StatementResult
    func visit(_: SwitchStatement) -> StatementResult
    func visit(_: LabeledStatement) -> StatementResult
    func visit(_: BreakStatement) -> StatementResult
    func visit(_: ContinueStatement) -> StatementResult
    func visit(_: FallthroughStatement) -> StatementResult
    func visit(_: ReturnStatement) -> StatementResult
    func visit(_: ThrowStatement) -> StatementResult
    func visit(_: DeferStatement) -> StatementResult
    func visit(_: DoStatement) -> StatementResult
    func visit(_: ExpressionStatement) -> StatementResult
    func visit(_: DeclarationStatement) -> StatementResult
}

extension ForInStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension WhileStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension RepeatWhileStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension IfStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension GuardStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension SwitchStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension LabeledStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension BreakStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension ContinueStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension FallthroughStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension ReturnStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension ThrowStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension DeferStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension DoStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension ExpressionStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}
extension DeclarationStatement {
    public func accept<V : StatementVisitor>(_ v: V) -> V.StatementResult { return v.visit(self) }
}


public protocol TypeVisitor {
    associatedtype TypeResult
    func visit(_: ArrayType) -> TypeResult
    func visit(_: DictionaryType) -> TypeResult
    func visit(_: FunctionType) -> TypeResult
    func visit(_: TypeIdentifier­) -> TypeResult
    func visit(_: TupleType) -> TypeResult
    func visit(_: OptionalType) -> TypeResult
    func visit(_: ImplicitlyUnwrappedOptionalType) -> TypeResult
    func visit(_: ProtocolCompositionType) -> TypeResult
}

extension ArrayType {
    public func accept<V : TypeVisitor>(_ v: V) -> V.TypeResult { return v.visit(self) }
}
extension DictionaryType {
    public func accept<V : TypeVisitor>(_ v: V) -> V.TypeResult { return v.visit(self) }
}
extension FunctionType {
    public func accept<V : TypeVisitor>(_ v: V) -> V.TypeResult { return v.visit(self) }
}
extension TypeIdentifier­ {
    public func accept<V : TypeVisitor>(_ v: V) -> V.TypeResult { return v.visit(self) }
}
extension TupleType {
    public func accept<V : TypeVisitor>(_ v: V) -> V.TypeResult { return v.visit(self) }
}
extension OptionalType {
    public func accept<V : TypeVisitor>(_ v: V) -> V.TypeResult { return v.visit(self) }
}
extension ImplicitlyUnwrappedOptionalType {
    public func accept<V : TypeVisitor>(_ v: V) -> V.TypeResult { return v.visit(self) }
}
extension ProtocolCompositionType {
    public func accept<V : TypeVisitor>(_ v: V) -> V.TypeResult { return v.visit(self) }
}

public protocol ASTVisitor: DeclarationVisitor, ExpressionVisitor, StatementVisitor, TypeVisitor {
}
