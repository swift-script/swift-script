public protocol Node: JavaScriptConvertible {
    
}

extension Node {
    public var javaScript: String {
        return  "<unimplemented: \(type(of: self))>"
    }
}
