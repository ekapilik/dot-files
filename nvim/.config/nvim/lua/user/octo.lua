-- PR Review Workflow
-- ==================
-- 1. <leader>pl  — open Telescope PR list, pick a PR → opens octo buffer (description + threads)
-- 2. <leader>pc  — checkout the PR branch locally
-- 3. <leader>dv  — open Diffview to survey all changed files side-by-side
--                  (or: DiffviewOpen main...HEAD  to scope to just the PR diff)
--    <leader>dc  — close Diffview when done
-- 4. <leader>pr  — start a review session; opens the file panel with changed files
--                  Inside the review diff buffer:
--                    <localleader>ca  — add inline comment at cursor
--                    <localleader>ce  — edit a comment
--                    <localleader>cd  — delete a comment
-- 5. <leader>pR  — submit the review (approve / request changes / comment)
-- 6. <leader>pm  — merge the PR when it's ready
--
-- Other useful octo commands (run via :Octo <cmd>):
--   :Octo pr search assignee=@me   — PRs assigned to you
--   :Octo review resume            — reopen an in-progress review
--   :Octo comment add              — add a top-level PR comment

require("octo").setup({
  use_local_fs = false,
  picker = "telescope",
  file_panel = {
    size = 10,
  },
  mappings = {
    review_diff = {
      -- open the diff for the current file in diffview
      toggle_viewed = { lhs = "<leader>v", desc = "toggle viewed" },
    },
  },
})

-- PR / issue navigation
vim.keymap.set("n", "<leader>pl", "<cmd>Octo pr list<cr>", { desc = "PR list" })
vim.keymap.set("n", "<leader>ps", "<cmd>Octo pr search<cr>", { desc = "PR search" })
vim.keymap.set("n", "<leader>po", "<cmd>Octo pr browser<cr>", { desc = "PR open in browser" })
vim.keymap.set("n", "<leader>pc", "<cmd>Octo pr checkout<cr>", { desc = "PR checkout" })
vim.keymap.set("n", "<leader>pr", "<cmd>Octo review start<cr>", { desc = "PR start review" })
vim.keymap.set("n", "<leader>pR", "<cmd>Octo review submit<cr>", { desc = "PR submit review" })
vim.keymap.set("n", "<leader>pm", "<cmd>Octo pr merge<cr>", { desc = "PR merge" })

-- Diffview shortcuts (usable outside octo too)
-- <leader>dv  — PR diff: all changes on this branch vs origin/main (use after `Octo pr checkout`)
-- <leader>dV  — working tree diff: uncommitted changes only
vim.keymap.set("n", "<leader>dv", "<cmd>DiffviewOpen origin/main...HEAD<cr>", { desc = "Diffview PR diff vs main" })
vim.keymap.set("n", "<leader>dV", "<cmd>DiffviewOpen<cr>", { desc = "Diffview working tree" })
vim.keymap.set("n", "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview file history" })
vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
