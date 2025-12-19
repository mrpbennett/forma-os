return {
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = { "rafamadriz/friendly-snippets" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = "super-tab",
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        default = { "lsp", "buffer", "snippets", "path" },

        per_filetype = {
          sql = { "dadbod" },
        },

        providers = {
          snippets = {
            score_offset = 4,
          },
          lsp = {
            score_offset = 3,
          },
          path = {
            score_offset = 2,
          },
          buffer = {
            score_offset = 1,
          },
          dadbod = { module = "vim_dadbod_completion.blink" },
        },
      },

      signature = {
        enabled = true,
      },

      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
