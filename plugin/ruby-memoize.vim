if (exists('g:ruby_memoize_loaded') && g:ruby_memoize_loaded) || &compatible
  finish
endif
let g:ruby_memoize_loaded = 1

let s:cpo_save = &cpo
set cpo&vim

function! s:ToggleMemoize()
  " Save anonymous register and clipboard settings
  let reg = getreg('"', 1)
  let regtype = getregtype('"')
  let cb_save = &clipboard
  set clipboard-=unnamed
  let paste_mode = &paste

  try
    exe "normal! ?def\<cr>"
    normal! wywj0w

    if getline('.') =~ "@.* ||="
      normal! 0w3dw
    else
      exe "normal! I@\<esc>"
      normal! p
      exe "normal! a ||= \<esc>"
    endif

    normal! k$

  " Restore anonymous register and clipboard settings
  finally
    call setreg('"', reg, regtype)
    let &clipboard = cb_save
    let &paste = paste_mode

    silent! call repeat#set("\<Plug>ToggleMemoize", -1)
  endtry
endfunction

nnoremap <silent> <Plug>ToggleMemoize :<C-U>call <SID>ToggleMemoize()<CR>

if !exists('g:ruby_memoize_mapping')
  let g:ruby_memoize_mapping = '<Leader>m'
endif

augroup ruby_memoize
  autocmd!
  exec 'autocmd FileType ruby map <buffer> ' . g:ruby_memoize_mapping . ' <Plug>ToggleMemoize'
augroup END

let &cpo = s:cpo_save

