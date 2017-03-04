public protocol Statement: Node {
    
}

public struct ForInStatement: Statement {
    var item: String
    var collection: Expression
    var statements: [Statement]
}

public struct WhileStatement: Statement {
    var condition: Expression
    var statements: [Statement]
}

public struct RepeatWhileStatement: Statement {
    var statements: [Statement]
    var condition: Expression
}

public struct IfStatement: Statement {
    var condition: Expression
    var elseClause: ElseClause?
}

public enum ElseClause: Node {
    case else_([Statement])
    indirect case elseIf(IfStatement)
}

public struct GuardStatement: Statement {
    var condition: Expression
    var statements: [Statement]
}

public struct SwitchStatement: Statement {
    // TODO
}

public struct LabeledStatement: Statement {
    var labelName: String
    var statement: Statement
}

public struct BreakStatement: Statement {
    var labelName: String?
}


public struct ContinueStatement: Statement {
    var labelName: String?
}


public struct FallthroughStatement: Statement {
    
}


public struct ReturnStatement: Statement {
    var expression: Expression?
}


public struct ThrowStatement: Statement {
    var expression: Expression
}


public struct DeferStatement: Statement {
    var statements: [Statement]
}


public struct DoStatement: Statement {
    var statements: [Statement]
    var catchClauses: [CatchClause]
}

public struct CatchClause: Node {
    // TODO
}
