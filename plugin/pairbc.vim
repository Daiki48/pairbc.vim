
inoremap <expr> { pairbc#InputParentheses("{")
inoremap <expr> [ pairbc#InputParentheses("[")
inoremap <expr> ( pairbc#InputParentheses("(")

inoremap <expr> } pairbc#InputCloseParenthesis("}")
inoremap <expr> ] pairbc#InputCloseParenthesis("]")
inoremap <expr> ) pairbc#InputCloseParenthesis(")")

inoremap <expr> ' pairbc#InputQuotation("\'")
inoremap <expr> " pairbc#InputQuotation("\"")
inoremap <expr> ` pairbc#InputQuotation("\`")

inoremap <expr> <CR> pairbc#InputCR()

inoremap <expr> <Space> pairbc#InputSpace()


