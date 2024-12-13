local status_ok, cmp = pcall(require, 'cmp')

if not status_ok then
  vim.notify("cmp not found. Run :PackerSync", vim.log.levels.WARN)
end

if status_ok then
  cmp.setup({
    window = {
      completion = {
        border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}, -- rounded arc corners
        winhighlight = "Normal:CmpPmenu,CursorLine:CmpPmenuSel,Search:None",
      },
      documentation = {
        border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}, -- rounded arc corners
      },
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)  -- For LuaSnip
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'luasnip' },
    },
  })
end
