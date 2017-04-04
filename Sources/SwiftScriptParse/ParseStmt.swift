import SwiftScriptAST
import Runes
import TryParsec

fileprivate func asStmt(stmt: Statement) -> Statement {
    return stmt
}
let stmtSep = OHWS *> (VS <|> (semi <&> { _ in () })) <* OWS

let stmtBraceItems = _stmtBraceItems()
func _stmtBraceItems() -> SwiftParser<[Statement]> {
    return sepEndBy(stmtBraceItem, stmtSep)
}

let stmtBraceItem = _stmtBraceItem()
func _stmtBraceItem() -> SwiftParser<Statement> {
    return (decl <&> { decl in DeclarationStatement(decl) })
        <|> (stmt <&> asStmt)
        <|> (expr <&> { expr in ExpressionStatement(expr) })
}


let stmtBrace = _stmtBrace()
func _stmtBrace() -> SwiftParser<[Statement]> {
    return  l_brace *> OWS *> stmtBraceItems <* OWS <* r_brace
}

let stmt = _stmt()
func _stmt() -> SwiftParser<Statement> {
    return (stmtReturn <&> asStmt)
        <|> (stmtThrow <&> asStmt)
        <|> (stmtDefer <&> asStmt)
        <|> (stmtIf <&> asStmt)
        <|> (stmtGuard <&> asStmt)
        <|> (stmtForIn <&> asStmt)
        <|> (stmtWhile <&> asStmt)
        <|> (stmtRepeatWhile <&> asStmt)
        <|> (stmtSwitch <&> asStmt)
        <|> (stmtDo <&> asStmt)
        <|> (stmtBreak <&> asStmt)
        <|> (stmtContinue <&> asStmt)
        <|> (stmtFallthrough <&> asStmt)
        <|> (stmtLabeled <&> asStmt)
}


let stmtForIn = _stmtForIn()
func _stmtForIn() -> SwiftParser<ForInStatement> {
    return { name in { col in { body in
        ForInStatement(item: name, collection: col, statements: body) }}}
        <^> (kw_for *> WS *> identifier)
        <*> (WS *> kw_in *> OWS *> exprBasic)
        <*> (OWS *> stmtBrace)
}

let stmtWhile = _stmtWhile()
func _stmtWhile() -> SwiftParser<WhileStatement> {
    return { cond in { body in
        WhileStatement(condition: cond, statements: body) }}
        <^> (kw_while *> OWS *> exprBasic)
        <*> (OWS *> stmtBrace)
}

let stmtRepeatWhile = _stmtRepeatWhile()
func _stmtRepeatWhile() -> SwiftParser<RepeatWhileStatement> {
    return { body in { cond in
        RepeatWhileStatement(statements: body, condition: cond) }}
        <^> (kw_repeat *> OWS *> stmtBrace)
        <*> (OWS *> kw_while *> OWS *> exprBasic)
}

let stmtIf = _stmtIf()
func _stmtIf() -> SwiftParser<IfStatement> {
    return { cond in { body in { els in
        IfStatement(condition: cond, statements: body, elseClause: els) }}}
        <^> (kw_if *> OWS *> stmtCondition)
        <*> (OWS *> stmtBrace)
        <*> stmtElseClause
}

let stmtElseClause = _stmtElseClause()
func _stmtElseClause() -> SwiftParser<ElseClause?> {
    return (OWS *> kw_else *> WS *> stmtIf <&> { .elseIf($0) })
        <|> (OWS *> kw_else *> OWS *> stmtBrace <&> { .else_($0)} )
        <|> pure(nil)
}

let stmtCondition = _stmtCondition()
func _stmtCondition() -> SwiftParser<Condition> {
    return ({ name in { expr in .optionalBinding(false, name, expr) } }
            <^> kw_let *> OWS *> identifier <*> oper_infix("=") *> exprBasic)
        <|> ({ name in { expr in .optionalBinding(true, name, expr) } }
            <^> kw_var *> OWS *> identifier <*> oper_infix("=") *> exprBasic)
        <|> (exprBasic <&> { .boolean($0) })
}

let stmtGuard = _stmtGuard()
func _stmtGuard() -> SwiftParser<GuardStatement> {
    return { cond in { body in
        GuardStatement(condition: cond, statements: body) }}
        <^> (kw_guard *> OWS *> stmtCondition)
        <*> (OWS *> kw_else *> OWS *> stmtBrace)
}

let stmtSwitch = _stmtSwitch()
func _stmtSwitch() -> SwiftParser<SwitchStatement> {
    return kw_switch *> fail("not implemented")
}

let stmtLabeled = _stmtLabeled()
func _stmtLabeled() -> SwiftParser<LabeledStatement> {
    return { label in { stmt in
        LabeledStatement(labelName: label, statement: stmt) }}
        <^> (identifier <* OWS <* colon <* OWS)
        <*> ((stmtIf <&> asStmt)
            <|> (stmtForIn <&> asStmt)
            <|> (stmtWhile <&> asStmt)
            <|> (stmtRepeatWhile <&> asStmt)
            <|> (stmtSwitch <&> asStmt)
            <|> (stmtDo <&> asStmt))
}

let stmtBreak = _stmtBreak()
func _stmtBreak() -> SwiftParser<BreakStatement> {
    return BreakStatement.init <^> kw_break *> zeroOrOne(WS *> identifier)
}

let stmtContinue = _stmtContinue()
func _stmtContinue() -> SwiftParser<ContinueStatement> {
    return ContinueStatement.init <^> kw_continue *> zeroOrOne(WS *> identifier)
}

let stmtFallthrough = _stmtFallthrough()
func _stmtFallthrough() -> SwiftParser<FallthroughStatement> {
    return { _ in FallthroughStatement() } <^> kw_fallthrough
}

let stmtReturn = _stmtReturn()
func _stmtReturn() -> SwiftParser<ReturnStatement> {
    return { value in
        ReturnStatement(expression: value) }
        <^> kw_return
        *> zeroOrOne(OWS *> expr)
}

let stmtThrow = _stmtThrow()
func _stmtThrow() -> SwiftParser<ThrowStatement> {
    return { value in
        ThrowStatement(expression: value) }
        <^> (kw_throw *> OWS *> expr)
}

let stmtDefer = _stmtDefer()
func _stmtDefer() -> SwiftParser<DeferStatement> {
    return { stmts in
        DeferStatement(statements: stmts) }
        <^> (kw_defer *> OWS *> stmtBrace)
}

let stmtDo = _stmtDo()
func _stmtDo() -> SwiftParser<DoStatement> {
    return { body in { catchClauses in
        DoStatement(statements: body, catchClauses: catchClauses)}}
        <^> (kw_do *> OWS *> stmtBrace)
        <*> many(OWS *> stmtCatchClause)
}

let stmtCatchClause = _stmtCatchClause()
func _stmtCatchClause() -> SwiftParser<CatchClause> {
    return { pattern in { body in
        /* TODO */ CatchClause() }}
        <^> (kw_catch *> OWS *> exprBasic)
        <*> (OWS *> stmtBrace)
}
