"
" gather file candidates
"
function! unite#sources#unity#helper#gather_candidates_file(path,filename)

  if isdirectory(a:path)
    let files = []
    for f in split(globpath(a:path, '**/'.a:filename) , '\n')
      if isdirectory(f) | continue | endif
      call add(files , 
            \ {'name' : substitute(f , a:path. "/" , "" , "") , 'path' : f })
    endfor
  else
    let files = [{
          \ "name" : fnamemodify(a:path, ":t") ,
          \ "path" : a:path
          \ }]
  endif

  return map(files , '{
          \ "word" : v:val.name ,
          \ "kind" : "file" ,
          \ "action__path"      : v:val.path ,
          \ "action__directory" : fnamemodify(v:val.path , ":p:h") ,
          \ }')
endfunction
"
" gather cmd candidates
"
function! unite#sources#unity#helper#gather_candidates_cmd(command, arguments)
  return map(a:arguments , '{
        \ "word" : v:val.word ,
        \ "abbr" : get(v:val , "abbr" , v:val.word) ,
        \ "kind" : "command" ,
        \ "action__command" : s:execute_cmd() . a:command . " " . v:val.word ,
        \ }')
endfunction
"
" gather cmd input candidates
"
function! unite#sources#unity#helper#gather_candidates_cmd_input(command, arguments) 
  return map(a:arguments , '{
        \ "word" : v:val.word ,
        \ "abbr" : get(v:val, "abbr", v:val.word) ,
        \ "kind" : "command" ,
        \ "action__command" : s:create_cmd_input(a:command, v:val.word, get(v:val, "abbr", v:val.word)) ,
        \ }')
endfunction
"
"
function! s:create_cmd_input(cmd, word, abbr)
  return "call unite#sources#unity#helper#execute_cmd_input('". a:.cmd . "','" . a:word . "','" . a:abbr . "')"
endfunction
"
"
function! unite#sources#unity#helper#execute_cmd_input(cmd, word, abbr)
  echohl PmenuSel | echo a:abbr | echohl None
  let msg = input(": ")
  if msg == ''
    echo 'abort' | return
  endif
  execute s:execute_cmd() . ' ' . a:cmd . ' ' . a:word . ' ' . msg
endfunction
"
"
function! s:execute_cmd()
  if g:unite_unity_execute_cmd == '!'
    return '!'
  else
    return g:unite_unity_execute_cmd . ' '
  endif
endfunction


"
" get unity root directory
"
function! unite#sources#unity#helper#unity_root()
  let dir = finddir("Assets" , ".;")
  if dir == "" | return "" | endif
  return  dir . "/../" 
endfunction
