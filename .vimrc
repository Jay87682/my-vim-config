set nocompatible              " be iMproved, required
filetype off                  " required

let TabSize = 2

"show the line number
set nu
" set the tab is 2 spaces
"set tabstop = 2
execute "set tabstop=".TabSize
"set 2 spaces for line shift
"set shiftwidth = 2
execute "set shiftwidth=".TabSize
" set indent
set smartindent
" hight the search result
set hlsearch


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
"Plugin 'scrooloose/syntastic'
Plugin 'vim-scripts/taglist.vim'
Plugin 'vim-scripts/winmanager'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
"Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"

"" Taglist plugin setting
"If the last window is the tlist, exit the vim
let Tlist_Exit_OnlyWindow=1
"Show current taglist and auto-close others
let Tlist_File_Fold_Auto_Close=1


"" WindowsManager plugin setting
" g:$name_title, $name_Start(), $name_IsValid() are necessary for WinManager
" plugin
let g:NERDTree_title="[NERDTree]" 
function! NERDTree_Start()
  exec 'NERDTree'
endfunction
function! NERDTree_IsValid()
  return 1
endfunction

" WinManager will extract the NERDTree as the $name
let g:winManagerWindowLayout = "NERDTree|TagList"
" Open the window manager
" The conflict between WinManager and NERDTree: A redundant empty window.
" ':q' is to close the empty window
function! OpenWM()
	let wm_cmd = ':WMToggle'
	let ct_cmd = ':TlistToggle'
	let nt_cmd = ':NERDTree'
	if (exists(wm_cmd) && exists(ct_cmd) && exists(nt_cmd))
		if !IsWinManagerVisible()
			WMToggle
			:q
		endif
	else
		echo 'Please install winmanager/nerdtree/taglist vim script.'
	endif
endfunction
"nmap owm :if IsWinManagerVisible() <BAR> WMToggle<CR> <BAR> else <BAR> WMToggle<CR>:q<CR> endif <CR><CR>
nmap owm :call OpenWM()<CR><CR>



function! CheckExternalCmd(...)
	let cmd = a:1 . ' ' . a:2
	let resp = system(cmd)
	if !empty(resp)
		return 1
	else
		return 0
	endif
endfunction

""Test program for CheckExternalCmd function
"let test_cmd = 'ctags'
"let test_cmd_opt = '--version'
"if CheckExternalCmd(test_cmd, test_cmd_opt)
"	echo test_cmd . ' exits'
"else
"	echo 'Please install ' . test_cmd
"endif


function! AddCtags()
	let ctags_cmd = 'ctags'
	if CheckExternalCmd(ctags_cmd, '--version')
		let cwd = getcwd()
		let cre_ctags = ctags_cmd . ' -R *'
		let resp = system(cre_ctags)
	else
		echo '"gct" command need ' . ctags_cmd . '. Please try to "sudo apt-get install exuberant-ctags"!'
	endif
endfunction

let CtagFileName = "tags"
" Generate the ctags
nmap gct :call AddCtags()<CR><CR>

function! AddCscope()
	let cscope_out_file = 'cscope.out'
	let cscope_cmd = 'cscope'

	if CheckExternalCmd(cscope_cmd, '--version') 
		let cwd = getcwd()
		"let cmd = '!find ' . cwd . ' -iname "*.[chxs]" | tee ' . cwd . '/cscope.out && cscope -bqk'
		"execute cmd
		let cre_cscope = 'find ' . cwd . ' -iname "*.[chxs]" | tee ' . cwd . '/' . cscope_out_file . ' && ' . cscope_cmd . ' -bqk'
		let resp =  system(cre_cscope)
  	cs add cscope.out
	else
		echo '\"gcs\" command need ' . cscope_cmd . '. Please try to \"sudo apt-get install cscope\"!'
	endif
endfunction

nmap gcs :call AddCscope()<CR><CR>

"If there is the cscope.out file, add it
"let cscope_out_file = 'cscope.out'
"if filereadable(cscope_out_file)
"	cs add cscope.out
"endif

"Define the hat key to trigger the cs command
" find the symbol
nmap <C-@>s : cs find s <C-R>=expand("<cword>")<CR><CR>
" find the function, macro, emu (like the etags)
nmap <C-@>g : cs find g <C-R>=expand("<cword>")<CR><CR>
" find the calling functions
nmap <C-@>d : cs find d <C-R>=expand("<cword>")<CR><CR>
" find the caller function (only one not all)
nmap <C-@>c : cs find c <C-R>=expand("<cword>")<CR><CR>
" find the specific char??
nmap <C-@>t : cs find t <C-R>=expand("<cword>")<CR><CR>
" like the 'egre'p, but more faster 
nmap <C-@>e : cs find e <C-R>=expand("<cword>")<CR><CR>
" find the file and open it
nmap <C-@>f : cs find f <C-R>=expand("<cfile>")<CR><CR>
" find the files what include self
nmap <C-@>i : cs find i <C-R>=expand("<cfile>")<CR><CR>

function! CheckPlugin()
	let test_cmd = ':WMToggle'
	if has(test_cmd)
		echo  test_cmd . ' exist'
	else
		echo 'No ' . test_cmd . ' plugin'
	endif
endfunction
nmap splg :call CheckPlugin()<CR><CR> 

function! OpenWinM()
	WMToggle
	:q
endfunction
nmap oom :call OpenWinM()<CR><CR>
