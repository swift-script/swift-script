public protocol Node: JavaScriptConvertible {
    
}

extension Node {
    public func javaScript(with indentLevel: Int) -> String {
        return  "<unimplemented: \(type(of: self))>"
    }
}
