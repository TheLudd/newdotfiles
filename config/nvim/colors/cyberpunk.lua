-- Cyberpunk colorscheme for Neovim
-- Neon colors with a dark background, not too intense

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.g.colors_name = "cyberpunk"

-- Palette
local c = {
  -- Background shades
  bg = "#0d0d1a",
  bg_dark = "#080810",
  bg_light = "#151525",
  bg_float = "#252545",
  bg_visual = "#2a2a4a",
  bg_highlight = "#1e1e35",

  -- Foreground
  fg = "#c5c8d6",
  fg_dark = "#8a8da0",
  fg_gutter = "#4a4a6a",

  -- Neon colors (softened for readability)
  magenta = "#e066ff",
  purple = "#b48ead",
  pink = "#ff79c6",
  neon_blue = "#61e2ff",
  blue = "#7aa2f7",
  cyan = "#56d4dd",
  neon_green = "#5af78e",
  green = "#9ece6a",
  yellow = "#e0af68",
  orange = "#ff9e64",
  red = "#f7768e",

  -- UI colors
  border = "#3d3d5c",
  selection = "#364a82",
  comment = "#6272a4",
  line_nr = "#565f89",
  cursor_line = "#1a1a2e",

  -- Diagnostic colors
  error = "#ff5555",
  warning = "#ffb86c",
  info = "#61e2ff",
  hint = "#b48ead",

  -- Git colors
  git_add = "#5af78e",
  git_change = "#e0af68",
  git_delete = "#ff5555",

  -- Diff
  diff_add = "#1a3320",
  diff_change = "#2a2a1a",
  diff_delete = "#331a1a",
  diff_text = "#3a3a2a",
}

-- Helper function
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor highlights
hl("Normal", { fg = c.fg, bg = c.bg })
hl("NormalFloat", { fg = c.fg, bg = c.bg_float })
hl("FloatBorder", { fg = c.pink, bg = c.bg_float })
hl("FloatTitle", { fg = c.neon_blue, bg = c.bg_float, bold = true })
hl("WinFloat", { fg = c.fg, bg = c.bg_float })
hl("WinFloatBorder", { fg = c.pink, bg = c.bg_float })
hl("Cursor", { fg = c.bg, bg = c.magenta })
hl("CursorLine", { bg = c.cursor_line })
hl("CursorColumn", { bg = c.cursor_line })
hl("ColorColumn", { bg = c.bg_highlight })
hl("LineNr", { fg = c.line_nr })
hl("CursorLineNr", { fg = c.magenta, bold = true })
hl("SignColumn", { fg = c.fg_gutter, bg = c.bg })
hl("VertSplit", { fg = c.border })
hl("WinSeparator", { fg = c.border })
hl("Folded", { fg = c.comment, bg = c.bg_highlight })
hl("FoldColumn", { fg = c.comment })
hl("NonText", { fg = c.fg_gutter })
hl("SpecialKey", { fg = c.fg_gutter })
hl("Whitespace", { fg = c.fg_gutter })
hl("EndOfBuffer", { fg = c.bg })

-- Search & selection
hl("Search", { fg = c.bg, bg = c.yellow })
hl("IncSearch", { fg = c.bg, bg = c.orange })
hl("CurSearch", { fg = c.bg, bg = c.magenta })
hl("Substitute", { fg = c.bg, bg = c.red })
hl("Visual", { bg = c.bg_visual })
hl("VisualNOS", { bg = c.bg_visual })

-- Statusline & tabline
hl("StatusLine", { fg = c.fg, bg = c.bg_light })
hl("StatusLineNC", { fg = c.fg_dark, bg = c.bg_dark })
hl("TabLine", { fg = c.fg_dark, bg = c.bg_dark })
hl("TabLineFill", { bg = c.bg_dark })
hl("TabLineSel", { fg = c.magenta, bg = c.bg, bold = true })
hl("WinBar", { fg = c.fg, bg = c.bg })
hl("WinBarNC", { fg = c.fg_dark, bg = c.bg })

-- Popup menu
hl("Pmenu", { fg = c.fg, bg = c.bg_dark })
hl("PmenuSel", { fg = c.fg, bg = c.selection })
hl("PmenuSbar", { bg = c.bg_light })
hl("PmenuThumb", { bg = c.fg_gutter })

-- Messages
hl("ModeMsg", { fg = c.neon_green, bold = true })
hl("MoreMsg", { fg = c.neon_blue })
hl("Question", { fg = c.neon_blue })
hl("WarningMsg", { fg = c.warning })
hl("ErrorMsg", { fg = c.error })

-- Spelling
hl("SpellBad", { undercurl = true, sp = c.error })
hl("SpellCap", { undercurl = true, sp = c.warning })
hl("SpellLocal", { undercurl = true, sp = c.info })
hl("SpellRare", { undercurl = true, sp = c.hint })

-- Diff
hl("DiffAdd", { bg = c.diff_add })
hl("DiffChange", { bg = c.diff_change })
hl("DiffDelete", { bg = c.diff_delete })
hl("DiffText", { bg = c.diff_text })

-- Directory
hl("Directory", { fg = c.neon_blue })

-- Matching
hl("MatchParen", { fg = c.magenta, bold = true, underline = true })

-- Title
hl("Title", { fg = c.magenta, bold = true })

-- Syntax highlighting
hl("Comment", { fg = c.comment, italic = true })
hl("Constant", { fg = c.orange })
hl("String", { fg = c.neon_green })
hl("Character", { fg = c.neon_green })
hl("Number", { fg = c.orange })
hl("Boolean", { fg = c.orange })
hl("Float", { fg = c.orange })

hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.neon_blue })

hl("Statement", { fg = c.magenta })
hl("Conditional", { fg = c.magenta })
hl("Repeat", { fg = c.magenta })
hl("Label", { fg = c.pink })
hl("Operator", { fg = c.pink })
hl("Keyword", { fg = c.magenta })
hl("Exception", { fg = c.magenta })

hl("PreProc", { fg = c.cyan })
hl("Include", { fg = c.magenta })
hl("Define", { fg = c.magenta })
hl("Macro", { fg = c.cyan })
hl("PreCondit", { fg = c.cyan })

hl("Type", { fg = c.cyan })
hl("StorageClass", { fg = c.magenta })
hl("Structure", { fg = c.cyan })
hl("Typedef", { fg = c.cyan })

hl("Special", { fg = c.pink })
hl("SpecialChar", { fg = c.pink })
hl("Tag", { fg = c.pink })
hl("Delimiter", { fg = c.fg_dark })
hl("SpecialComment", { fg = c.comment, bold = true })
hl("Debug", { fg = c.orange })

hl("Underlined", { underline = true })
hl("Ignore", { fg = c.fg_gutter })
hl("Error", { fg = c.error })
hl("Todo", { fg = c.bg, bg = c.yellow, bold = true })

-- Treesitter highlights
hl("@variable", { fg = c.fg })
hl("@variable.builtin", { fg = c.pink })
hl("@variable.parameter", { fg = c.fg, italic = true })
hl("@variable.member", { fg = c.blue })

hl("@constant", { fg = c.orange })
hl("@constant.builtin", { fg = c.orange })
hl("@constant.macro", { fg = c.cyan })

hl("@module", { fg = c.purple })
hl("@label", { fg = c.pink })

hl("@string", { fg = c.neon_green })
hl("@string.escape", { fg = c.pink })
hl("@string.regexp", { fg = c.pink })
hl("@string.special", { fg = c.pink })
hl("@string.special.url", { fg = c.neon_blue, underline = true })

hl("@character", { fg = c.neon_green })
hl("@character.special", { fg = c.pink })

hl("@boolean", { fg = c.orange })
hl("@number", { fg = c.orange })
hl("@number.float", { fg = c.orange })

hl("@type", { fg = c.cyan })
hl("@type.builtin", { fg = c.cyan, italic = true })
hl("@type.definition", { fg = c.cyan })
hl("@type.qualifier", { fg = c.magenta })

hl("@attribute", { fg = c.purple })
hl("@property", { fg = c.blue })

hl("@function", { fg = c.neon_blue })
hl("@function.builtin", { fg = c.neon_blue })
hl("@function.macro", { fg = c.cyan })
hl("@function.method", { fg = c.neon_blue })

hl("@constructor", { fg = c.cyan })

hl("@operator", { fg = c.pink })

hl("@keyword", { fg = c.magenta })
hl("@keyword.modifier", { fg = c.magenta })
hl("@keyword.type", { fg = c.magenta })
hl("@keyword.coroutine", { fg = c.magenta })
hl("@keyword.function", { fg = c.magenta })
hl("@keyword.operator", { fg = c.pink })
hl("@keyword.import", { fg = c.magenta })
hl("@keyword.repeat", { fg = c.magenta })
hl("@keyword.return", { fg = c.magenta })
hl("@keyword.debug", { fg = c.orange })
hl("@keyword.exception", { fg = c.magenta })
hl("@keyword.conditional", { fg = c.magenta })
hl("@keyword.conditional.ternary", { fg = c.pink })
hl("@keyword.directive", { fg = c.cyan })

hl("@punctuation.delimiter", { fg = c.fg_dark })
hl("@punctuation.bracket", { fg = c.fg_dark })
hl("@punctuation.special", { fg = c.pink })

hl("@comment", { fg = c.comment, italic = true })
hl("@comment.documentation", { fg = c.comment })
hl("@comment.error", { fg = c.error })
hl("@comment.warning", { fg = c.warning })
hl("@comment.todo", { fg = c.bg, bg = c.yellow, bold = true })
hl("@comment.note", { fg = c.bg, bg = c.info, bold = true })

hl("@markup.strong", { bold = true })
hl("@markup.italic", { italic = true })
hl("@markup.strikethrough", { strikethrough = true })
hl("@markup.underline", { underline = true })
hl("@markup.heading", { fg = c.magenta, bold = true })
hl("@markup.quote", { fg = c.comment, italic = true })
hl("@markup.math", { fg = c.cyan })
hl("@markup.environment", { fg = c.purple })
hl("@markup.link", { fg = c.neon_blue, underline = true })
hl("@markup.link.label", { fg = c.pink })
hl("@markup.link.url", { fg = c.neon_blue, underline = true })
hl("@markup.raw", { fg = c.neon_green })
hl("@markup.list", { fg = c.pink })

hl("@tag", { fg = c.pink })
hl("@tag.attribute", { fg = c.neon_blue })
hl("@tag.delimiter", { fg = c.fg_dark })

-- LSP semantic tokens
hl("@lsp.type.class", { link = "@type" })
hl("@lsp.type.decorator", { link = "@attribute" })
hl("@lsp.type.enum", { link = "@type" })
hl("@lsp.type.enumMember", { link = "@constant" })
hl("@lsp.type.function", { link = "@function" })
hl("@lsp.type.interface", { link = "@type" })
hl("@lsp.type.macro", { link = "@function.macro" })
hl("@lsp.type.method", { link = "@function.method" })
hl("@lsp.type.namespace", { link = "@module" })
hl("@lsp.type.parameter", { link = "@variable.parameter" })
hl("@lsp.type.property", { link = "@property" })
hl("@lsp.type.struct", { link = "@type" })
hl("@lsp.type.type", { link = "@type" })
hl("@lsp.type.typeParameter", { link = "@type" })
hl("@lsp.type.variable", { link = "@variable" })

hl("@lsp.mod.deprecated", { strikethrough = true })
hl("@lsp.mod.readonly", { italic = true })
hl("@lsp.mod.defaultLibrary", { link = "@variable.builtin" })

-- LSP diagnostics
hl("DiagnosticError", { fg = c.error })
hl("DiagnosticWarn", { fg = c.warning })
hl("DiagnosticInfo", { fg = c.info })
hl("DiagnosticHint", { fg = c.hint })
hl("DiagnosticOk", { fg = c.neon_green })

hl("DiagnosticVirtualTextError", { fg = c.error, bg = c.bg_highlight })
hl("DiagnosticVirtualTextWarn", { fg = c.warning, bg = c.bg_highlight })
hl("DiagnosticVirtualTextInfo", { fg = c.info, bg = c.bg_highlight })
hl("DiagnosticVirtualTextHint", { fg = c.hint, bg = c.bg_highlight })
hl("DiagnosticVirtualTextOk", { fg = c.neon_green, bg = c.bg_highlight })

hl("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.warning })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.info })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.hint })
hl("DiagnosticUnderlineOk", { undercurl = true, sp = c.neon_green })

hl("DiagnosticFloatingError", { fg = c.error })
hl("DiagnosticFloatingWarn", { fg = c.warning })
hl("DiagnosticFloatingInfo", { fg = c.info })
hl("DiagnosticFloatingHint", { fg = c.hint })
hl("DiagnosticFloatingOk", { fg = c.neon_green })

hl("DiagnosticSignError", { fg = c.error })
hl("DiagnosticSignWarn", { fg = c.warning })
hl("DiagnosticSignInfo", { fg = c.info })
hl("DiagnosticSignHint", { fg = c.hint })
hl("DiagnosticSignOk", { fg = c.neon_green })

-- LSP references
hl("LspReferenceText", { bg = c.bg_highlight })
hl("LspReferenceRead", { bg = c.bg_highlight })
hl("LspReferenceWrite", { bg = c.bg_highlight })

-- LSP inlay hints
hl("LspInlayHint", { fg = c.comment, bg = c.bg_highlight, italic = true })

-- LSP codelens
hl("LspCodeLens", { fg = c.comment })
hl("LspCodeLensSeparator", { fg = c.fg_gutter })

-- LSP signature help
hl("LspSignatureActiveParameter", { fg = c.magenta, bold = true })

-- LSP hover / info windows
hl("LspInfoBorder", { fg = c.pink, bg = c.bg_float })

-- Git signs (gitsigns.nvim)
hl("GitSignsAdd", { fg = c.git_add })
hl("GitSignsChange", { fg = c.git_change })
hl("GitSignsDelete", { fg = c.git_delete })
hl("GitSignsCurrentLineBlame", { fg = c.comment, italic = true })

-- Telescope
hl("TelescopeNormal", { fg = c.fg, bg = c.bg_dark })
hl("TelescopeBorder", { fg = c.border, bg = c.bg_dark })
hl("TelescopeTitle", { fg = c.magenta, bold = true })
hl("TelescopePromptNormal", { fg = c.fg, bg = c.bg_light })
hl("TelescopePromptBorder", { fg = c.border, bg = c.bg_light })
hl("TelescopePromptTitle", { fg = c.neon_green, bg = c.bg_light, bold = true })
hl("TelescopePromptPrefix", { fg = c.magenta })
hl("TelescopeResultsNormal", { fg = c.fg, bg = c.bg_dark })
hl("TelescopeResultsBorder", { fg = c.border, bg = c.bg_dark })
hl("TelescopeResultsTitle", { fg = c.neon_blue, bold = true })
hl("TelescopePreviewNormal", { fg = c.fg, bg = c.bg_dark })
hl("TelescopePreviewBorder", { fg = c.border, bg = c.bg_dark })
hl("TelescopePreviewTitle", { fg = c.cyan, bold = true })
hl("TelescopeSelection", { fg = c.fg, bg = c.selection })
hl("TelescopeSelectionCaret", { fg = c.magenta })
hl("TelescopeMatching", { fg = c.neon_green, bold = true })

-- nvim-cmp
hl("CmpItemAbbr", { fg = c.fg })
hl("CmpItemAbbrDeprecated", { fg = c.fg_dark, strikethrough = true })
hl("CmpItemAbbrMatch", { fg = c.neon_blue, bold = true })
hl("CmpItemAbbrMatchFuzzy", { fg = c.neon_blue })
hl("CmpItemKind", { fg = c.magenta })
hl("CmpItemMenu", { fg = c.comment })

hl("CmpItemKindText", { fg = c.fg })
hl("CmpItemKindMethod", { fg = c.neon_blue })
hl("CmpItemKindFunction", { fg = c.neon_blue })
hl("CmpItemKindConstructor", { fg = c.cyan })
hl("CmpItemKindField", { fg = c.blue })
hl("CmpItemKindVariable", { fg = c.fg })
hl("CmpItemKindClass", { fg = c.cyan })
hl("CmpItemKindInterface", { fg = c.cyan })
hl("CmpItemKindModule", { fg = c.purple })
hl("CmpItemKindProperty", { fg = c.blue })
hl("CmpItemKindUnit", { fg = c.orange })
hl("CmpItemKindValue", { fg = c.orange })
hl("CmpItemKindEnum", { fg = c.cyan })
hl("CmpItemKindKeyword", { fg = c.magenta })
hl("CmpItemKindSnippet", { fg = c.neon_green })
hl("CmpItemKindColor", { fg = c.pink })
hl("CmpItemKindFile", { fg = c.neon_blue })
hl("CmpItemKindReference", { fg = c.pink })
hl("CmpItemKindFolder", { fg = c.neon_blue })
hl("CmpItemKindEnumMember", { fg = c.orange })
hl("CmpItemKindConstant", { fg = c.orange })
hl("CmpItemKindStruct", { fg = c.cyan })
hl("CmpItemKindEvent", { fg = c.pink })
hl("CmpItemKindOperator", { fg = c.pink })
hl("CmpItemKindTypeParameter", { fg = c.cyan })

-- Indent blankline
hl("IblIndent", { fg = c.bg_highlight })
hl("IblScope", { fg = c.magenta })

-- Lazy.nvim
hl("LazyNormal", { fg = c.fg, bg = c.bg_dark })
hl("LazyButton", { fg = c.fg, bg = c.bg_light })
hl("LazyButtonActive", { fg = c.bg, bg = c.magenta })
hl("LazyH1", { fg = c.bg, bg = c.magenta, bold = true })
hl("LazyH2", { fg = c.neon_blue, bold = true })
hl("LazySpecial", { fg = c.neon_green })
hl("LazyProgressDone", { fg = c.neon_green })
hl("LazyProgressTodo", { fg = c.fg_gutter })

-- Mason
hl("MasonNormal", { fg = c.fg, bg = c.bg_dark })
hl("MasonHeader", { fg = c.bg, bg = c.magenta, bold = true })
hl("MasonHeaderSecondary", { fg = c.bg, bg = c.neon_blue, bold = true })
hl("MasonHighlight", { fg = c.neon_blue })
hl("MasonHighlightBlock", { fg = c.bg, bg = c.neon_green })
hl("MasonHighlightBlockBold", { fg = c.bg, bg = c.neon_green, bold = true })
hl("MasonMuted", { fg = c.comment })
hl("MasonMutedBlock", { fg = c.fg, bg = c.bg_light })

-- NvimTree / Neo-tree
hl("NvimTreeNormal", { fg = c.fg, bg = c.bg_dark })
hl("NvimTreeFolderName", { fg = c.neon_blue })
hl("NvimTreeOpenedFolderName", { fg = c.neon_blue, bold = true })
hl("NvimTreeEmptyFolderName", { fg = c.fg_dark })
hl("NvimTreeFolderIcon", { fg = c.neon_blue })
hl("NvimTreeIndentMarker", { fg = c.fg_gutter })
hl("NvimTreeRootFolder", { fg = c.magenta, bold = true })
hl("NvimTreeSymlink", { fg = c.cyan })
hl("NvimTreeGitDirty", { fg = c.git_change })
hl("NvimTreeGitNew", { fg = c.git_add })
hl("NvimTreeGitDeleted", { fg = c.git_delete })
hl("NvimTreeSpecialFile", { fg = c.pink })

hl("NeoTreeNormal", { fg = c.fg, bg = c.bg_dark })
hl("NeoTreeNormalNC", { fg = c.fg, bg = c.bg_dark })
hl("NeoTreeDirectoryName", { fg = c.neon_blue })
hl("NeoTreeDirectoryIcon", { fg = c.neon_blue })
hl("NeoTreeRootName", { fg = c.magenta, bold = true })
hl("NeoTreeFileName", { fg = c.fg })
hl("NeoTreeGitAdded", { fg = c.git_add })
hl("NeoTreeGitModified", { fg = c.git_change })
hl("NeoTreeGitDeleted", { fg = c.git_delete })

-- Which-key
hl("WhichKey", { fg = c.magenta })
hl("WhichKeyGroup", { fg = c.neon_blue })
hl("WhichKeyDesc", { fg = c.fg })
hl("WhichKeySeparator", { fg = c.fg_gutter })
hl("WhichKeyFloat", { bg = c.bg_dark })
hl("WhichKeyBorder", { fg = c.border })
hl("WhichKeyValue", { fg = c.comment })

-- Noice / Notify
hl("NoiceCmdline", { fg = c.fg })
hl("NoiceCmdlineIcon", { fg = c.magenta })
hl("NoiceCmdlinePopup", { fg = c.fg, bg = c.bg_dark })
hl("NoiceCmdlinePopupBorder", { fg = c.border })
hl("NoiceConfirm", { fg = c.fg, bg = c.bg_dark })
hl("NoiceConfirmBorder", { fg = c.magenta })

hl("NotifyERRORBorder", { fg = c.error })
hl("NotifyERRORIcon", { fg = c.error })
hl("NotifyERRORTitle", { fg = c.error })
hl("NotifyWARNBorder", { fg = c.warning })
hl("NotifyWARNIcon", { fg = c.warning })
hl("NotifyWARNTitle", { fg = c.warning })
hl("NotifyINFOBorder", { fg = c.info })
hl("NotifyINFOIcon", { fg = c.info })
hl("NotifyINFOTitle", { fg = c.info })
hl("NotifyDEBUGBorder", { fg = c.comment })
hl("NotifyDEBUGIcon", { fg = c.comment })
hl("NotifyDEBUGTitle", { fg = c.comment })
hl("NotifyTRACEBorder", { fg = c.purple })
hl("NotifyTRACEIcon", { fg = c.purple })
hl("NotifyTRACETitle", { fg = c.purple })

-- Flash.nvim
hl("FlashLabel", { fg = c.bg, bg = c.magenta, bold = true })
hl("FlashMatch", { fg = c.fg, bg = c.bg_visual })
hl("FlashCurrent", { fg = c.fg, bg = c.selection })
hl("FlashBackdrop", { fg = c.comment })

-- Mini plugins
hl("MiniStatuslineFilename", { fg = c.fg, bg = c.bg_light })
hl("MiniStatuslineFileinfo", { fg = c.fg, bg = c.bg_light })
hl("MiniStatuslineDevinfo", { fg = c.fg, bg = c.bg_light })
hl("MiniStatuslineInactive", { fg = c.fg_dark, bg = c.bg_dark })
hl("MiniStatuslineModeNormal", { fg = c.bg, bg = c.neon_blue, bold = true })
hl("MiniStatuslineModeInsert", { fg = c.bg, bg = c.neon_green, bold = true })
hl("MiniStatuslineModeVisual", { fg = c.bg, bg = c.magenta, bold = true })
hl("MiniStatuslineModeReplace", { fg = c.bg, bg = c.red, bold = true })
hl("MiniStatuslineModeCommand", { fg = c.bg, bg = c.yellow, bold = true })
hl("MiniStatuslineModeOther", { fg = c.bg, bg = c.cyan, bold = true })

-- Dashboard / Alpha
hl("DashboardHeader", { fg = c.magenta })
hl("DashboardCenter", { fg = c.neon_blue })
hl("DashboardShortCut", { fg = c.cyan })
hl("DashboardFooter", { fg = c.comment, italic = true })

hl("AlphaHeader", { fg = c.magenta })
hl("AlphaButtons", { fg = c.neon_blue })
hl("AlphaShortcut", { fg = c.cyan })
hl("AlphaFooter", { fg = c.comment, italic = true })

-- Trouble
hl("TroubleNormal", { fg = c.fg, bg = c.bg_dark })
hl("TroubleText", { fg = c.fg })
hl("TroubleCount", { fg = c.magenta, bg = c.bg_highlight })
hl("TroubleFile", { fg = c.neon_blue })
hl("TroubleFoldIcon", { fg = c.magenta })
hl("TroubleLocation", { fg = c.comment })
hl("TroublePreview", { bg = c.bg_highlight })
hl("TroubleSource", { fg = c.comment })
hl("TroubleSignError", { fg = c.error })
hl("TroubleSignWarning", { fg = c.warning })
hl("TroubleSignInformation", { fg = c.info })
hl("TroubleSignHint", { fg = c.hint })

-- Navic / Breadcrumbs
hl("NavicText", { fg = c.fg })
hl("NavicSeparator", { fg = c.fg_gutter })
hl("NavicIconsFile", { fg = c.neon_blue })
hl("NavicIconsModule", { fg = c.purple })
hl("NavicIconsNamespace", { fg = c.purple })
hl("NavicIconsPackage", { fg = c.purple })
hl("NavicIconsClass", { fg = c.cyan })
hl("NavicIconsMethod", { fg = c.neon_blue })
hl("NavicIconsProperty", { fg = c.blue })
hl("NavicIconsField", { fg = c.blue })
hl("NavicIconsConstructor", { fg = c.cyan })
hl("NavicIconsEnum", { fg = c.cyan })
hl("NavicIconsInterface", { fg = c.cyan })
hl("NavicIconsFunction", { fg = c.neon_blue })
hl("NavicIconsVariable", { fg = c.fg })
hl("NavicIconsConstant", { fg = c.orange })
hl("NavicIconsString", { fg = c.neon_green })
hl("NavicIconsNumber", { fg = c.orange })
hl("NavicIconsBoolean", { fg = c.orange })
hl("NavicIconsArray", { fg = c.pink })
hl("NavicIconsObject", { fg = c.cyan })
hl("NavicIconsKey", { fg = c.magenta })
hl("NavicIconsNull", { fg = c.orange })
hl("NavicIconsEnumMember", { fg = c.orange })
hl("NavicIconsStruct", { fg = c.cyan })
hl("NavicIconsEvent", { fg = c.pink })
hl("NavicIconsOperator", { fg = c.pink })
hl("NavicIconsTypeParameter", { fg = c.cyan })

-- Noice (consistent colors for all floating UI)
hl("NoiceCmdline", { fg = c.fg, bg = c.bg_float })
hl("NoiceCmdlineIcon", { fg = c.pink })
hl("NoiceCmdlineIconSearch", { fg = c.pink })
hl("NoiceCmdlinePopup", { fg = c.fg, bg = c.bg_float })
hl("NoiceCmdlinePopupBorder", { fg = c.pink, bg = c.bg_float })
hl("NoiceCmdlinePopupBorderSearch", { fg = c.pink, bg = c.bg_float })
hl("NoiceCmdlinePopupTitle", { fg = c.pink, bg = c.bg_float })
hl("NoiceConfirm", { fg = c.fg, bg = c.bg_float })
hl("NoiceConfirmBorder", { fg = c.pink, bg = c.bg_float })
hl("NoicePopup", { fg = c.fg, bg = c.bg_float })
hl("NoicePopupBorder", { fg = c.pink, bg = c.bg_float })
hl("NoicePopupmenu", { fg = c.fg, bg = c.bg_float })
hl("NoicePopupmenuBorder", { fg = c.pink, bg = c.bg_float })
hl("NoicePopupmenuSelected", { fg = c.fg, bg = c.selection })
hl("NoiceScrollbar", { fg = c.pink, bg = c.bg_float })
hl("NoiceScrollbarThumb", { bg = c.pink })
hl("NoiceVirtualText", { fg = c.comment })
hl("NoiceMini", { fg = c.fg, bg = c.bg_float })
hl("NoiceFormatProgressDone", { fg = c.bg, bg = c.pink })
hl("NoiceFormatProgressTodo", { fg = c.fg, bg = c.bg_highlight })

-- Snacks (consistent with noice)
hl("SnacksInputNormal", { fg = c.fg, bg = c.bg_float })
hl("SnacksInputBorder", { fg = c.pink, bg = c.bg_float })
hl("SnacksInputTitle", { fg = c.pink, bg = c.bg_float })
hl("SnacksPickerNormal", { fg = c.fg, bg = c.bg_float })
hl("SnacksPickerBorder", { fg = c.pink, bg = c.bg_float })
hl("SnacksPickerTitle", { fg = c.pink, bg = c.bg_float })
hl("SnacksPickerMatch", { fg = c.neon_green, bold = true })
hl("SnacksPickerSelected", { fg = c.fg, bg = c.selection })
