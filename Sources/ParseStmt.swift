//
//  ParseStmt.swift
//  SwiftScript
//
//  Created by Rintaro Ishizaki on 2017/03/04.
//
//

import Runes
import TryParsec

fileprivate func asStmt(stmt: Statement) -> Statement {
    return stmt
}
let stmtSep = OHWS *> (VS <|> (OWS *> semi <&> { _ in () })) <* OWS

let stmtBraceItems = _stmtBraceItems()
func _stmtBraceItems() -> SwiftParser<[Statement]> {
    return sepEndBy(stmtBraceItem, stmtSep)
}

let stmtBraceItem = _stmtBraceItem()
func _stmtBraceItem() -> SwiftParser<Statement> {
    return (decl <&> asStmt)
        <|> (stmt <&> asStmt)
        <|> (expr <&> asStmt)
}


let stmtBrace = _stmtBrace()
func _stmtBrace() -> SwiftParser<[Statement]> {
    return  l_brace *> OWS *> stmtBraceItems <* OWS <* r_brace
}

let stmt = _stmt()
func _stmt() -> SwiftParser<Statement> {
    return (stmtReturn <&> asStmt)
//        <|> (stmtThrow <&> asStmt)
//        <|> (stmtDefer <&> asStmt)
        <|> (stmtIf <&> asStmt)
        <|> (stmtForIn <&> asStmt)
//        <|> (stmtDo <&> asStmt)
        <|> (stmtBreak <&> asStmt)
        <|> (stmtContinue <&> asStmt)
//        <|> (stmtFallthrough <&> asStmt)
}


let stmtForIn = _stmtForIn()
func _stmtForIn() -> SwiftParser<ForInStatement> {
    return { name in { col in { body in
        ForInStatement(item: name, collection: col, statements: body) }}}
        <^> (kw_for *> WS *> identifier)
        <*> (WS *> kw_in *> expr)
        <*> (OWS *> stmtBrace)
}

func _stmtWhile() -> SwiftParser<WhileStatement> {
    return fail("not implemented")
}

func _stmtRepeatWhile() -> SwiftParser<RepeatWhileStatement> {
    return fail("not implemented")
}

let stmtIf = _stmtIf()
func _stmtIf() -> SwiftParser<IfStatement> {
    return { cond in { body in { els in
        IfStatement(condition: cond, statements: body, elseClause: els) }}}
        <^> (kw_if *> WS *> expr)
        <*> (OWS *> stmtBrace)
        <*> stmtElseClause
}

let stmtElseClause = _stmtElseClause()
func _stmtElseClause() -> SwiftParser<ElseClause?> {
    return (OWS *> kw_else *> stmtIf <&> { .elseIf($0) })
        <|> (OWS *> kw_else *> stmtBrace <&> { .else_($0)} )
        <|> pure(nil)
}

func _stmtSwitch() -> SwiftParser<SwitchStatement> {
    return fail("not implemented")
}

func _stmtLabeled() -> SwiftParser<LabeledStatement> {
    return fail("not implemented")
}

let stmtBreak = _stmtBreak()
func _stmtBreak() -> SwiftParser<BreakStatement> {
    return BreakStatement.init <^> kw_break *> zeroOrOne(WS *> identifier)
}

let stmtContinue = _stmtContinue()
func _stmtContinue() -> SwiftParser<ContinueStatement> {
    return ContinueStatement.init <^> kw_continue *> zeroOrOne(WS *> identifier)
}

func _stmtFallthrough() -> SwiftParser<FallthroughStatement> {
    return { _ in FallthroughStatement() } <^> kw_fallthrough
}

let stmtReturn = _stmtReturn()
func _stmtReturn() -> SwiftParser<ReturnStatement> {
    return { value in
        ReturnStatement(expression: value) }
        <^> (kw_return *> OWS *> expr)
}

func _stmtThrow() -> SwiftParser<ThrowStatement> {
    return { value in
        ThrowStatement(expression: value) }
        <^> (kw_throw *> OWS *> expr)
}

func _stmtDefer() -> SwiftParser<DeferStatement> {
    return { stmts in
        DeferStatement(statements: stmts) }
        <^> (kw_throw *> OWS *> stmtBrace)
}


func _stmtDo() -> SwiftParser<DoStatement> {
    return fail("not implemented")
}

func _stmtCatchClause() -> SwiftParser<CatchClause> {
    return fail("not implemented")
}
