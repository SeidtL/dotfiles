return {
  -- Disable LazyVim's default nvim-cmp completion
  { "nvim-cmp", enabled = false },

  -- Use blink.cmp with super-tab
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "super-tab" },
    },
  },
}
