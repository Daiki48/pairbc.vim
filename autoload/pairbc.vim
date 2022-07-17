" init settings

function! pairbc#GetNextString(length) abort
  let l:str = ""
  for i in range(0, a:length-1)
    let l:str = l:str.getline(".")[col(".")-1+i]
  endfor
  return l:str
endfunction

function! pairbc#GetPrevString(length) abort
  let l:str = ""
  for i in range(0, a:length-1)
    let l:str = l:str.getline(".")[col(".")-2-i].l:str
  endfor
  return l:str
endfunction

function! pairbc#IsAlphabet(char) abort
  let l:charIsAlphabet = (a:char =~ "\a")
  return (l:charIsAlphabet)
endfunction

function! pairbc#IsFullWidth(char) abort
  let l:charIsFullWidth = (a:char =~ "[^\x01-\x7E]")
  return (l:charIsFullWidth)
endfunction

function! pairbc#IsNum(char) abort
  let l:charIsNum = (a:char >= "0" && a:char <= "9")
  return (l:charIsNum)
endfunction

" brackets

function pairbc#IsInsideParentheses(prevChar, nextChar) abort
  let l:cursorIsInsideParentheses1 = (a:prevChar == "{" && a:nextChar == "}")
  let l:cursorIsInsideParentheses2 = (a:prevChar == "[" && a:nextChar == "]")
  let l:cursorIsInsideParentheses3 = (a:prevChar == "(" && a:nextChar == ")")
  return (l:cursorIsInsideParentheses1 || l:cursorIsInsideParentheses2 || l:cursorIsInsideParentheses3)
endfunction

function! pairbc#InputParentheses(parenthesis) abort
  let l:nextChar = pairbc#GetNextString(1)
  let l:prevChar = pairbc#GetPrevString(1)
  let l:parentheses = { "{": "}", "[": "]", "(": ")" }

  let l:nextCharIsEmpty = (l:nextChar == "")
  let l:nextCharIsCloseParenthesis = (l:nextChar == "}" || l:nextChar == "]" || l:nextChar == ")")
  let l:nextCharIsSpace = (l:nextChar == " ")

  if l:nextCharIsEmpty || l:nextCharIsCloseParenthesis || l:nextCharIsSpace 
    return a:parenthesis.l:parentheses[a:parenthesis]."\<LEFT>"
  else
    return a:parenthesis
  endif
endfunction

function! pairbc#InputCloseParenthesis(parenthesis) abort
  let l:nextChar = pairbc#GetNextString(1)
  if l:nextChar == a:parenthesis
    return "\<RIGHT>"
  else
    return a:parenthesis
  endif
endfunction

" Quotation

function! pairbc#InputQuotation(quot) abort
  let l:nextChar = pairbc#GetNextString(1)
  let l:prevChar = pairbc#GetPrevString(1)

  let l:cursorIsInsideQuotations = (l:prevChar == a:quot && l:nextChar == a:quot)
  let l:nextCharIsEmpty = (l:nextChar == "")
  let l:nextCharIsClosingParenthesis = (l:nextChar == "}" || l:nextChar == "]" || l:nextChar == ")")
  let l:nextCharIsSpace = (l:nextChar == " ")
  let l:prevCharIsAlphabet = pairbc#IsAlphabet(l:prevChar)
  let l:prevCharIsFullWidth = pairbc#IsFullWidth(l:prevChar)
  let l:prevCharIsNum = pairbc#IsNum(l:prevChar)
  let l:prevCharIsQuotation = (l:prevChar == "\'" || l:prevChar == "\"" || l:prevChar == "\`")
  
  if l:cursorIsInsideQuotations
    return "\<RIGHT>"
  elseif l:prevCharIsAlphabet || l:prevCharIsNum || l:prevCharIsFullWidth || l:prevCharIsQuotation
    return a:quot
  elseif l:nextCharIsEmpty || l:nextCharIsClosingParenthesis || nextCharIsSpace
    return a:quot.a:quot."\<LEFT>"
  else
    return a:quot
  endif
endfunction

" newline

function! pairbc#InputCR() abort
  let l:nextChar = pairbc#GetNextString(1)
  let l:prevChar = pairbc#GetPrevString(1)
  let l:cursorIsInsideParentheses = pairbc#IsInsideParentheses(l:prevChar, l:nextChar)

  if l:cursorIsInsideParentheses
    return "\<CR>\<ESC>\<S-o>"
  else
    return "\<CR>"
  endif
endfunction

" space

function! pairbc#InputSpace() abort
  let l:nextChar = pairbc#GetNextString(1)
  let l:prevChar = pairbc#GetPrevString(1)
  let l:cursorIsInsideParentheses = pairbc#IsInsideParentheses(l:prevChar, l:nextChar)

  if l:cursorIsInsideParentheses
    return "\<Space>\<Space>\<LEFT>"
  else
    return "\<Space>"
  endif
endfunction

function! pairbc#InputBS() abort
  let l:nextChar = pairbc#GetNextString(1)
  let l:prevChar = pairbc#GetPrevString(1)
  let l:nextTwoChar = pairbc#GetNextString(2)
  let l:prevTwoChar = pairbc#GetPrevString(2)
  let l:cursorIsInsideParentheses = pairbc#IsInsideParentheses(l:prevChar,l:nextChar)
  let l:cursorIsInsideSpace1 = (l:prevTwoChar == "{ " && l:nextTwoChar == " }" )
  let l:cursorIsInsideSpace2 = (l:prevTwoChar == "[ " && l:nextTwoChar == " ]" )
  let l:cursorIsInsideSpace3 = (l:prevTwoChar == "( " && l:nextTwoChar == " )" )
  let l:cursorIsInsideSpace = (l:cursorIsInsideSpace1 || l:cursorIsInsideSpace2 || l:cursorIsInsideSpace3)
  let l:existQuotation = (l:prevChar == "'" && l:nextChar == "'")
  let l:existsDoubleQuotation = (l:prevChar == "\"" && l:nextChar == "\"")

  if l:cursorIsInsideParentheses || l:cursorIsInsideSpace || l:existQuotation || l:existsDoubleQuotation
    return "\<BS>\<RIGHT>\<BS>"
  else
    return "\<BS>"
  endif
endfunction

function! pairbc#ClipInParentheses(parenthesis) abort
  let l:mode = mode()
  let l:parentheses = { "{": "}", "[": "]", "(": ")" }
  if l:mode ==# "v"
    return "\"ac".a:parenthesis."\<ESC>\"agpi".l:parentheses[a:parenthesis]
  elseif l:mode ==# "V"
    return "\"ac".l:parentheses[a:parenthesis]."\<ESC>\"aPi".a:parenthesis."\<CR>\<ESC>\<UP>=%"
  endif
endfunction



