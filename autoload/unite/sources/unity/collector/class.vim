"
" gather candidates
"
function! unite#sources#unity#collector#class#candidates(source)
  let target = a:source.source__unity_root . '/Assets'
  return unite#sources#unity#helper#gather_candidates_file(target,'*.cs')
endfunction
