-- rustup comes first so rust-analyzer uses a sysroot that has rust-src installed.
-- pixi bin follows for C++ compiler tools (gcc, clang, etc.) used by clangd --query-driver.
local pixi_bin = "/home/eric/dev/hmnd/hmnd_robot/.pixi/envs/default/bin"
local cargo_bin = vim.env.HOME .. "/.cargo/bin"
vim.env.PATH = cargo_bin .. ":" .. pixi_bin .. ":" .. vim.env.PATH

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "lua_ls", "clangd", "cmake", "rust_analyzer" },
})

vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    -- pixi env compilers so clangd resolves system headers correctly
    "--query-driver=/home/eric/dev/hmnd/hmnd_robot/.pixi/envs/default/bin/*",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { ".clangd", "compile_commands.json", "CMakeLists.txt", ".git" },
}

-- "rust_analyzer" (underscore) matches nvim-lspconfig's lsp/rust_analyzer.lua,
-- which provides cargo-metadata-based root detection and before_init wiring.
vim.lsp.config["rust_analyzer"] = {
  -- cmd intentionally omitted: uses rust-analyzer from PATH (rustup's, which has rust-src)
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = true,
      check = { command = "clippy" },
      procMacro = { enable = true },
    },
  },
}

vim.lsp.config.cmake = {
  cmd = { "cmake-language-server" },
  filetypes = { "cmake" },
  root_markers = { "CMakeLists.txt", ".git" },
}

vim.lsp.config.lua_ls = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}

vim.lsp.enable({ "pyright", "clangd", "cmake", "lua_ls", "rust_analyzer" })

-- Hover window styling
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  width = 80,
  height = 20,
  win_options = { winblend = 10 },
})

-- LSP keymaps: only active when a language server attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }

    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Diagnostic float" }))
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
  end,
})
