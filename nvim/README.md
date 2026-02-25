# AstroNvim Configuration

**NOTE:** This is for AstroNvim v5+

A highly personalized Neovim configuration built on top of [AstroNvim](https://github.com/AstroNvim/AstroNvim) with additional plugins and configurations for an enhanced editing experience.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Configuration Structure](#configuration-structure)
- [Key Bindings](#key-bindings)
- [Plugin List](#plugin-list)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)

## Features

### Plugin Management
- Uses `lazy.nvim` for efficient plugin management
- Imports the main AstroNvim package with version tracking
- Includes the AstroCommunity plugin collection for extended functionality

### Key Features
- **Modern UI**: Clean and aesthetic interface with the everforest colorscheme
- **Enhanced Editing**: Advanced editing support with auto-save, improved commenting, and motion enhancements
- **Language Server Protocol (LSP)**: Full LSP support with signature help and lens information
- **Completion Engine**: Powerful completion with tabby.nvim
- **Performance**: Optimized for speed and responsiveness with efficient plugin loading

### Community Plugins
The configuration includes various community plugins organized by categories:

#### Bars and Lines
- feline.nvim (statusline)
- smartcolumn.nvim
- vim-illuminate

#### Color
- nvim-highlight-colors
- tint-nvim
- twilight-nvim

#### Colorscheme
- everforest

#### Completion
- tabby.nvim

#### Diagnostics
- error-lens.nvim
- tiny-inline-diagnostic-nvim

#### Editing Support
- auto-save-nvim
- comment-box-nvim
- dial-nvim
- hypersonic-nvim
- yanky-nvim

#### Indent
- indent-blankline.nvim

#### LSP
- garbage-day-nvim
- lsp-lens-nvim
- lsp-signature-nvim

#### Markdown and LaTeX
- markview-nvim
- vimtex

#### Motion
- flash.nvim

#### Pack
- fish shell support

#### Scrolling
- neoscroll.nvim

#### Snippets
- nvim-snippets

#### Split and Windows
- windows-nvim

### Core Configuration
- Leader key set to space (`<Space>`)
- Local leader key set to comma (`,`)
- System clipboard integration enabled (`unnamedplus`)
- Large file handling with configurable limits
- Autopairs, completion, and diagnostics enabled by default

## Installation

To use this AstroNvim configuration:

1. Install Neovim (v0.9.0 or higher recommended)
2. Backup your current Neovim configuration (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```
3. Clone this configuration to `~/.config/nvim/`:
   ```bash
   git clone https://github.com/kambrch/kam-lab ~/.config/nvim
   ```
4. Launch Neovim - the configuration will automatically bootstrap `lazy.nvim` and install plugins:
   ```bash
   nvim
   ```
5. Run `:Lazy` to manage plugins after the initial setup

The configuration will automatically handle:
- Installing lazy.nvim if not present
- Installing all configured plugins
- Applying all customizations

## Configuration Structure

The configuration follows the AstroNvim v5+ modular structure using `lazy.nvim` for plugin management:

- `init.lua`: Bootstraps the installation of Lazy.nvim and calls other files for execution
- `lua/`: Contains all configuration modules
  - `lazy_setup.lua`: Main plugin setup importing AstroNvim and community plugins
  - `community.lua`: Lists imported community plugins for various features
  - `polish.lua`: Final configuration settings applied after all plugins are loaded
  - `plugins/`: Modular plugin configurations
    - `astrocore.lua`: Core editor functionality and keybindings
    - `astrolsp.lua`: Language Server Protocol (LSP) configuration
    - `astroui.lua`: UI customization and theming
    - `comment.lua`: Comment plugin configuration

## Key Bindings

Some important key mappings defined in this configuration:

- **Leader key**: `<Space>`
- **Local leader**: `,`
- **Buffer navigation**: `]b` (next), `[b` (previous)
- **Commenting**: `<Space>c` (toggle), `<Space>C` (line), `<Space>cm` (motion)
- **Tabby AI completion**:
  - `<Space>a` - AI menu
  - `<Space>as` - Start Tabby agent
  - `<Space>at` - Toggle completions
  - `<Space>ar` - Restart Tabby agent
  - `<Tab>` - Accept completion
  - `<C-k>` - Dismiss completion
- **System clipboard**: Enabled by default

For a complete list of key bindings, refer to the `lua/plugins/astrocore.lua` file.

## Customization

To customize this configuration:

1. Modify existing plugin configurations in the `lua/plugins/` directory
2. Add new plugins to the `lua/plugins/` directory following the same pattern
3. Adjust core settings in `lua/plugins/astrocore.lua`
4. Modify LSP settings in `lua/plugins/astrolsp.lua`
5. Change UI elements in `lua/plugins/astroui.lua`

## Troubleshooting

If you encounter issues:

1. Check that you have the latest version of Neovim installed (v0.9.0 or higher)
2. Run `:Lazy sync` to update all plugins
3. Check the logs with `:checkhealth`
4. If problems persist, remove the configuration and reinstall:
   ```bash
   rm -rf ~/.config/nvim
   # Then repeat installation steps
   ```

For more help, consult the [AstroNvim documentation](https://github.com/AstroNvim/AstroNvim) or open an issue in this repository.

