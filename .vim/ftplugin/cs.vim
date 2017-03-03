setlocal shiftwidth=4
setlocal softtabstop=4

" :help cinoptions-values
setlocal cinoptions=
setlocal cinoptions+=(s   " Indent after open paren
setlocal cinoptions+=m1)  " Unindent after close paren
setlocal cinoptions+=js   " Indent inside curly brace (abuses java-cinoptions)
setlocal cinoptions+=,-2s " Revert indentation after lines ending with a comma
