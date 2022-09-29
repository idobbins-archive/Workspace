
return require('packer').startup(function()

	use 'wbthomason/packer.nvim'

	use 'romgrk/barbar.nvim'

	require'bufferline'.setup {
		icons = false
	}

	use 'neovim/nvim-lspconfig'

	use {'ms-jpq/coq_nvim', branch = 'coq'}
	use {'ms-jpq/coq.thirdparty', branch = '3p'}
	use {'ms-jpq/coq.artifacts', branch = 'artifacts'}

	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	
	require('nvim-treesitter.configs').setup {
	  -- A list of parser names, or "all"
	  ensure_installed = { "c", "cpp", "c_sharp", "lua"},

	  -- Install parsers synchronously (only applied to `ensure_installed`)
	  sync_install = false,

	  -- List of parsers to ignore installing (for "all")
	  -- ignore_install = { "javascript" },

	  highlight = {
	    -- `false` will disable the whole extension
	    enable = true,

	    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
	    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
	    -- the name of the parser)
	    -- list of language that will be disabled
	    -- disable = { "c", "rust" },

	    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
	    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
	    -- Using this option may slow down your editor, and you may see some duplicate highlights.
	    -- Instead of true it can also be a list of languages
	    additional_vim_regex_highlighting = false,
	  },
	}

	-- LSP Mappings.
	-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	--
	local opts = { noremap=true, silent=true }

	vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer

	local on_attach = function(client, bufnr)

	  -- Enable completion triggered by <c-x><c-o>
	  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	  -- Mappings.
	  -- See `:help vim.lsp.*` for documentation on any of the below functions
	  local bufopts = { noremap=true, silent=true, buffer=bufnr }
	  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	  vim.keymap.set('n', '<space>wl', function()
	    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	  end, bufopts)
	  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

	end

	local coq = require('coq')

	local lsp_flags = {
	  -- This is the default in Nvim 0.7+
	  debounce_text_changes = 150,
	}

	require('lspconfig')['clangd'].setup(coq.lsp_ensure_capabilities({
	    on_attach = on_attach,
	    flags = lsp_flags,
    	}))

	require('lspconfig')['jedi_language_server'].setup(coq.lsp_ensure_capabilities({
	    on_attach = on_attach,
	    flags = lsp_flags,
    	}))

	require('lspconfig')['omnisharp'].setup(coq.lsp_ensure_capabilities({
	    cmd = { "dotnet", "/Users/idobbins/Downloads/omnisharp-osx-x64-net6.0/OmniSharp.dll" },

	    -- Enables support for reading code style, naming convention and analyzer
	    -- settings from .editorconfig.
	    enable_editorconfig_support = true,

	    -- If true, MSBuild project system will only load projects for files that
	    -- were opened in the editor. This setting is useful for big C# codebases
	    -- and allows for faster initialization of code navigation features only
	    -- for projects that are relevant to code that is being edited. With this
	    -- setting enabled OmniSharp may load fewer projects and may thus display
	    -- incomplete reference lists for symbols.
	    enable_ms_build_load_projects_on_demand = false,

	    -- Enables support for roslyn analyzers, code fixes and rulesets.
	    enable_roslyn_analyzers = false,

	    -- Specifies whether 'using' directives should be grouped and sorted during
	    -- document formatting.
	    organize_imports_on_format = false,

	    -- Enables support for showing unimported types and unimported extension
	    -- methods in completion lists. When committed, the appropriate using
	    -- directive will be added at the top of the current file. This option can
	    -- have a negative impact on initial completion responsiveness,
	    -- particularly for the first few completion sessions after opening a
	    -- solution.
	    enable_import_completion = false,

	    -- Specifies whether to include preview versions of the .NET SDK when
	    -- determining which version to use for project loading.
	    sdk_include_prereleases = true,

	    -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
	    -- true
	    analyze_open_documents_only = false,
	}))

	vim.cmd('COQnow -s')

end)

