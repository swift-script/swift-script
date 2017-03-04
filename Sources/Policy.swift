
import TryParsec

// Parser input type
typealias SwiftSource = String.UnicodeScalarView
// Just for onvenience
typealias SwiftParser<Out> = TryParsec.Parser<SwiftSource, Out>

