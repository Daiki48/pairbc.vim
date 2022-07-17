set backspace=indent,eol,start


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

inoremap <expr> <BS> pairbc#InputBS()

xnoremap <expr> { pairbc#ClipInParentheses("{")
xnoremap <expr> [ pairbc#ClipInParentheses("[")
xnoremap <expr> ( pairbc#ClipInParentheses("(")


