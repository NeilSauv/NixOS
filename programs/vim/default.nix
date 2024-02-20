{ pkgs, ... }:

{
  home.file.".vim/coc-settings.json".source = ../../programs/vim/coc-settings.json;
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ 
      Vundle-vim
      vim-sensible
      DoxygenToolkit-vim
      fzf-vim
      coc-nvim
      vim-airline
      delimitMate
      ayu-vim
    ];
    settings = { ignorecase = true; };
    extraConfig = ''
      set rtp+=~/.vim/bundle/Vundle.vim
      call vundle#begin()

      Plugin 'VundleVim/Vundle.vim'
      Plugin 'tpope/vim-sensible'
      Plugin 'vim-scripts/DoxygenToolkit.vim'
      Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
      Plugin 'junegunn/fzf.vim'
      Plugin 'neoclide/coc.nvim', {'branch': 'release'}
      Plugin 'vim-airline/vim-airline'
      Plugin 'Raimondi/delimitMate'

      set termguicolors     " enable true colors support
      let ayucolor="dark"
      colorscheme ayu

      call vundle#end()


      filetype indent plugin on
      syntax on

      highlight Folded ctermbg=gray ctermfg=white guibg=#333333 guifg=white
      au BufRead,BufNewFile *.asm,*.s set filetype=asm

      set cc=80
      set number
      set expandtab
      set shiftwidth=4
      set softtabstop=4
      set tabstop=4
      set smarttab
      set smartindent
      set cindent
      set textwidth=0
      set backspace=eol,start,indent
      set clipboard=unnamedplus
      set belloff=all
      set mouse=a
      set foldmethod=marker
      set foldlevel=0
      let loaded_matchparen = 1

      function! CustomFoldText()
      let l:foldstartLine = getline(v:foldstart)
      let l:numLines = v:foldend - v:foldstart + 1
      let l:foldText = '...'
      let l:inBlockComment = 0

      if l:foldstartLine =~ '/// '
        let l:nextLine = getline(v:foldstart + 1)
        if l:nextLine =~ '^///'
            let l:foldText = l:nextLine
        else
            let l:i = v:foldstart + 1
            while l:i <= v:foldend
                if getline(l:i) =~ '*/'
                    let l:foldText = getline(l:i + 1)
                    break
                endif
                let l:i += 1
            endwhile
        endif
      endif

      let l:significantLines = 0
      for l:i in range(v:foldstart, v:foldend)
        let l:line = getline(l:i)

        if l:line =~ '/\*' && l:line !~ '\*/'
            let l:inBlockComment = 1
        endif
        if l:line =~ '\*/'
            let l:inBlockComment = 0
            continue
        endif

        if !l:inBlockComment && l:line !~ '^\s*//' && l:line !~ '^\s*$' && l:line !~ '^\s*{\s*$' && l:line !~ '^\s*}\s*$'
            let l:significantLines += 1
        endif
      endfor
      let l:significantLines -= 1

      let l:foldsize = l:numLines . 'L - ' . l:significantLines . 'L  '
      let l:winwidth = winwidth(0) - len(l:foldText) - len(l:foldsize) - 4
      return l:foldText . repeat(' ', l:winwidth) . l:foldsize . ' '
      endfunction

      set foldtext=CustomFoldText()

      " Make configuration
      autocmd Filetype make setlocal noexpandtab

      set list listchars=tab:»·,trail:·

      " per .git vim configs
      " just `git config vim.settings "expandtab sw=4 sts=4"` in a git repository
      " change syntax settings for this repository
      let git_settings = system("git config --get vim.settings")
      if strlen(git_settings)
            exe "set" git_settings
      endif

      if has("autocmd")
      au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
      au InsertEnter,InsertChange *
      \ if v:insertmode == 'i' |
      \   silent execute '!echo -ne "\e[6 q"' | redraw! |
      \ elseif v:insertmode == 'r' |
      \   silent execute '!echo -ne "\e[4 q"' | redraw! |
      \ endif
      au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
      endif

      " IndentLine {{
      let g:indentLine_char = ''
      let g:indentLine_first_char = ''
      let g:indentLine_showFirstIndentLevel = 1
      let g:indentLine_setColors = 0
      " }}

      let g:DoxygenToolkit_briefTag = "@brief : "
      let g:DoxygenToolkit_paramTag = "@param : "
      let g:DoxygenToolkit_returnTag = "@return : "

      inoremap <silent><expr> <CR> pumvisible() ? coc#pum#confirm() : "\<CR>"
      inoremap <expr> <Tab> search('\%#[]>)],', 'n') ? '<Right>' : '<Tab>'

      vnoremap <C-S-c> :w !xclip -selection clipboard<CR><CR>
      nnoremap <C-S-c> :.w !xclip -selection clipboard<CR><CR>

      nnoremap <C-S-v> :r !xclip -selection clipboard -o<CR>
      inoremap <C-S-v> <Esc>:r !xclip -selection clipboard -o<CR>a

      nmap <C-f> :call ToggleFzf()<CR>

      function! ToggleFzf()
      write
      :Files
      endfunction

      let $FZF_DEFAULT_COMMAND = 'find . -type f \( -name "*.o" -prune -o -print \)'


      " Fonction pour effectuer un split vertical à droite
      function! FzfSplitRight()
      wincmd L
      endfunction

      " Lier la touche Ctrl+v à la fonction FzfSplitRight dans le mode FZF
      augroup FZFGroup
      autocmd!
      autocmd FileType fzf nnoremap <buffer> <C-v> :call FzfSplitRight()<CR>
      augroup END


      let g:airline#extensions#tabline#enabled = 1
      let g:airline#extensions#tabline#left_sep = ' '
      let g:airline#extensions#tabline#left_alt_sep = '|'
      let g:airline#extensions#tabline#formatter = 'unique_tail'

      let g:coc_global_extensions = [
      \ 'coc-pairs',
      \ 'coc-html',
      \ 'coc-git',
      \ 'coc-explorer',
      \ 'coc-tsserver',
      \ 'coc-python',
      \ 'coc-json',
      \ 'coc-css',
      \ 'coc-clangd',
      \ 'coc-rust-analyzer',
      \ 'coc-toml'
      \ ]

      let mapleader = ","
      nmap <leader>f <Plug>(coc-codeaction-selected)w

      inoremap <expr> <c-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
      inoremap <expr> <c-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"

      nnoremap <Leader>t :terminal<Space>
      nnoremap <silent> <C-k> :call CocAction('doHover')<CR>

      nnoremap <silent> <C-d> :CocCommand explorer<CR>

      function! OpenCocExplorerOnStartup()
      " Vérifie si Vim est lancé sans arguments ou avec le répertoire courant comme argument
      if argc() == 0 || (argc() == 1 && isdirectory(argv(0)) && argv(0) == '.')
      autocmd VimEnter * CocCommand explorer
      endif
      endfunction

      call OpenCocExplorerOnStartup()

    '';
  };
}

