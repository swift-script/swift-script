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
    return (expr <&> asStmt)
//        <|> (stmt <&> asStmt)
//        <|> (decl <&> asStmt)
}

let stmtBrace = _stmtBrace()
func _stmtBrace() -> SwiftParser<[Statement]> {
    return  l_brace *> OWS *> stmtBraceItems <* OWS <* r_brace
}


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

func _stmtIf() -> SwiftParser<IfStatement> {
    return fail("not implemented")
}

func _stmtElseClause() -> SwiftParser<ElseClause> {
    return fail("not implemented")
}

func _stmtSwitch() -> SwiftParser<SwitchStatement> {
    return fail("not implemented")
}

func _stmtLabeled() -> SwiftParser<LabeledStatement> {
    return fail("not implemented")
}

func _stmtBreak() -> SwiftParser<BreakStatement> {
    return fail("not implemented")
}

func _stmtContinue() -> SwiftParser<ContinueStatement> {
    return fail("not implemented")
}

func _stmtFallthrough() -> SwiftParser<FallthroughStatement> {
    return fail("not implemented")
}

func _stmtReturn() -> SwiftParser<ReturnStatement> {
    return fail("not implemented")
}

func _stmtThrow() -> SwiftParser<ThrowStatement> {
    return fail("not implemented")
}

func _stmtDefer() -> SwiftParser<DeferStatement> {
    return fail("not implemented")
}


func _stmtDo() -> SwiftParser<DoStatement> {
    return fail("not implemented")
}

func _stmtCatchClause() -> SwiftParser<CatchClause> {
    return fail("not implemented")
}
