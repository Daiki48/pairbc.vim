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







