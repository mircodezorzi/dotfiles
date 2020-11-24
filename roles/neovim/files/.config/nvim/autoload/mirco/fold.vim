" Source: Greg Hurrell

let s:middot='·'
let s:raquo='»'
let s:small_l='ℓ'

" Better fold text
function! mirco#fold#text() abort
	let l:lines='[' . (v:foldend - v:foldstart + 1) . s:small_l . ']'
	let l:first=substitute(getline(v:foldstart), '\v *', '', '')
	let l:dashes=substitute(v:folddashes, '-', s:middot, 'g')
	"return s:raquo . s:middot . s:middot . l:lines . l:dashes . ': ' . l:first
	return l:first . '...'
endfunction
