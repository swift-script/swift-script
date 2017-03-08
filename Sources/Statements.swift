public protocol Statement: Node {
    
}

public struct ForInStatement: Statement {
    public var item: String
    public var collection: Expression
    public var statements: [Statement]
}

public struct WhileStatement: Statement {
    public var condition: Expression
    public var statements: [Statement]
}

public struct RepeatWhileStatement: Statement {
    public var statements: [Statement]
    public var condition: Expression
}

public struct IfStatement: Statement {
    public var condition: Condition
    public var statements: [Statement]
    public var elseClause: ElseClause?
}

public enum Condition: Node {
    case boolean(Expression)
    case optionalBinding(/*isVar:*/ Bool, String, Expression)
}

public enum ElseClause: Node {
    case else_([Statement])
    indirect case elseIf(IfStatement)
}

public struct GuardStatement: Statement {
    public var condition: Condition
    public var statements: [Statement]
}

public struct SwitchStatement: Statement {
    // TODO
}

public struct LabeledStatement: Statement {
    public var labelName: String
    public var statement: Statement
}

public struct BreakStatement: Statement {
    public var labelName: String?
}


public struct ContinueStatement: Statement {
    public var labelName: String?
}


public struct FallthroughStatement: Statement {
    
}


public struct ReturnStatement: Statement {
    public var expression: Expression?
}


public struct ThrowStatement: Statement {
    public var expression: Expression
}


public struct DeferStatement: Statement {
    public var statements: [Statement]
}


public struct DoStatement: Statement {
    public var statements: [Statement]
    public var catchClauses: [CatchClause]
}

public struct CatchClause: Node {
    // TODO
}
