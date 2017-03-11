struct SupportingLibrary {
    let forceCast = "function asx(expression, type_test) {\n  if type_test() {\n    throw Error(\"Failed to cast\");\n  }\n  return expression;\n}\n"
    let forceTry = "function tryx(command) {\n  try {\n    return command();\n  }\n  catch(e) {\n    // TODO: some force stopping method\n    throw e;\n  }\n}\n"
    let forceUnwrap = "function x(expression) {\n  const is_null = (expression == null || typeof expression == 'undefined');\n  if (is_null) {\n    throw Error(\"Failed unwrapping\");\n  }\n  return expression;\n}\n"
    let `is` = "function is(expression, type) {\n  if (type == String) {\n    return typeof (expression) == 'string' || expression instanceof String;\n  } else if (type == Number) {\n    return typeof (expression) == 'number' || expression instanceof Number;\n  }\n  return expression instanceof type;\n}\n"
    let nilCoalescing = "function qq(expression, value) {\n  const is_null = (expression == null || typeof expression == 'undefined');\n  return is_null ? value : expression;\n}\n"
    let optionalCast = "function asq(expression, type_test) {\n  return type_test() ? expression : null;\n}\n"
    let optionalChain = "function q(expression, command) {\n  const is_null = (expression == null || typeof expression == 'undefined');\n  return is_null ? null : command();\n}\nmodule.exports = {'q': q};\n"
    let optionalTry = "function tryq(command) {\n  try {\n    return command();\n  }\n  catch(e) {\n    return null;\n  }\n}\n"
    let range = "function range(from, to) {\n  return (function* () {\n    var current = from;\n    while (current < to) {\n      yield current++;\n    }\n  })();\n}\n"
    let closedRange = "function closedRange(from, to) {\n  return (function* () {\n    var current = from;\n    while (current <= to) {\n      yield current++;\n    }\n  })();\n}\n"
}
