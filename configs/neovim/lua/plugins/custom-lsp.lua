return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              validate = true,
              completion = true,
              hover = true,
              editor = { tabSize = 2 },
              format = { enable = true, singleQuote = true },
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = {
                kubernetes = "**/*.yaml",
              },
            },
          },
        },
      },
    },
  },
}
