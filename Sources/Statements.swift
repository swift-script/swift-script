public protocol Statement: Node {
    
}

public struct ForInStatement: Statement {
    public var item: String
    public var collection: Expression
    public var statements: [Statement]
    
    public init(item: String, collection: Expression, statements: [Statement]) {
        self.item = item
        self.collection = collection
        self.statements = statements
    }
}

public struct WhileStatement: Statement {
    public var condition: Expression
    public var statements: [Statement]
    
    public init(condition: Expression, statements: [Statement]) {
        self.condition = condition
        self.statements = statements
    }
}

public struct RepeatWhileStatement: Statement {
    public var statements: [Statement]
    public var condition: Expression
    
    public init(statements: [Statement], condition: Expression) {
        self.statements = statements
        self.condition = condition
    }
}

public struct IfStatement: Statement {
    public var condition: Condition
    public var statements: [Statement]
    public var elseClause: ElseClause?
    
    public init(condition: Condition, statements: [Statement], elseClause: ElseClause?) {
        self.condition = condition
        self.statements = statements
        self.elseClause = elseClause
    }
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
    
    public init(condition: Condition, statements: [Statement]) {
        self.condition = condition
        self.statements = statements
    }
}

public struct SwitchStatement: Statement {
    // TODO
    public init() {}
}

public struct LabeledStatement: Statement {
    public var labelName: String
    public var statement: Statement
    
    public init(labelName: String, statement: Statement) {
        self.labelName = labelName
        self.statement = statement
    }
}

public struct BreakStatement: Statement {
    public var labelName: String?
    
    public init(labelName: String? = nil) {
        self.labelName = labelName
    }
}


public struct ContinueStatement: Statement {
    public var labelName: String?
    
    public init(labelName: String? = nil) {
        self.labelName = labelName
    }
}


public struct FallthroughStatement: Statement {
    public init() {}
}


public struct ReturnStatement: Statement {
    public var expression: Expression?
    
    public init(expression: Expression?) {
        self.expression = expression
    }
}


public struct ThrowStatement: Statement {
    public var expression: Expression
    
    public init(expression: Expression) {
        self.expression = expression
    }
}


public struct DeferStatement: Statement {
    public var statements: [Statement]
    
    public init(statements: [Statement]) {
        self.statements = statements
    }
}


public struct DoStatement: Statement {
    public var statements: [Statement]
    public var catchClauses: [CatchClause]
    
    public init(statements: [Statement], catchClauses: [CatchClause]) {
        self.statements = statements
        self.catchClauses = catchClauses
    }
}

public struct CatchClause: Node {
    // TODO
    public init() {}
}
