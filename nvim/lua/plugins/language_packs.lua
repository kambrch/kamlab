---@type LazySpec
return {
  -- HTML/CSS tooling loads only when editing markup or styling files.
  {
    import = "astrocommunity.pack.html-css",
    ft = { "html", "css", "scss", "sass", "less" },
  },
  -- Go tooling should load when opening Go buffers.
  {
    import = "astrocommunity.pack.go",
    ft = { "go" },
  },
  -- Julia tooling is heavy; limit it to Julia files.
  {
    import = "astrocommunity.pack.julia",
    ft = { "julia" },
  },
  -- Markdown pack is only needed when editing Markdown.
  {
    import = "astrocommunity.pack.markdown",
    ft = { "markdown", "md", "mdx" },
  },
  -- Python tooling should load for Python buffers.
  {
    import = "astrocommunity.pack.python",
    ft = { "python" },
  },
  -- SQL tooling for SQL buffers.
  {
    import = "astrocommunity.pack.sql",
    ft = { "sql" },
  },
  -- CSV helpers load only for CSV editing workflows.
  {
    import = "astrocommunity.programming-language-support.csv-vim",
    ft = { "csv" },
  },
}
