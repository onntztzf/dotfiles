-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- Helper function to get Telescope options
local function getTelescopeOpts(state, path)
    return {
        cwd = path,
        search_dirs = {path},
        attach_mappings = function(prompt_bufnr, map)
            local actions = require "telescope.actions"
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local action_state = require "telescope.actions.state"
                local selection = action_state.get_selected_entry()
                local filename = selection.filename
                if (filename == nil) then
                    filename = selection[1]
                end
                -- any way to open the file without triggering auto-close event of neo-tree?
                require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
            end)
            return true
        end
    }
end

-- vim.g.neo_tree_remove_legacy_commands = 1

require("neo-tree").setup {
    sources = {"filesystem", "buffers", "git_status", "document_symbols"},
    source_selector = {
        sources = {{
            source = "filesystem"
        }, {
            source = "buffers"
        }, {
            source = "git_status"
        }, {
            source = "document_symbols"
        }}
    },
    use_default_mappings = false,
    close_if_last_window = true,
    window = {
        position = "float",
        mappings = {
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["<esc>"] = "close_window",
            ["q"] = "close_window",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["<cr>"] = "open",
            ["z"] = "close_all_nodes",
            ["R"] = "refresh"
        }
    },
    filesystem = {
        hijack_netrw_behavior = "open_default",
        filtered_items = {
            -- remains visible even if other settings would normally hide it
            always_show = {".gitignore"}
        },
        window = {
            mappings = {
                ["h"] = function(state)
                    local node = state.tree:get_node()
                    if node.type == "directory" and node:is_expanded() then
                        require("neo-tree.sources.filesystem").toggle_directory(state, node)
                    else
                        require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
                    end
                end,
                ["l"] = function(state)
                    local node = state.tree:get_node()
                    if node.type == "directory" then
                        if not node:is_expanded() then
                            require("neo-tree.sources.filesystem").toggle_directory(state, node)
                        elseif node:has_children() then
                            require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                        end
                    end
                end,
                ["<tab>"] = function(state)
                    local node = state.tree:get_node()
                    if require("neo-tree.utils").is_expandable(node) then
                        state.commands["toggle_node"](state)
                    else
                        state.commands["open"](state)
                        vim.cmd("Neotree reveal")
                    end
                end,
                ["tf"] = "telescope_find",
                ["tg"] = "telescope_grep",
                ["a"] = {
                    "add",
                    config = {
                        show_path = "relative"
                    }
                },
                ["d"] = "delete",
                ["r"] = "rename",
                ["c"] = {
                    "copy",
                    config = {
                        show_path = "relative"
                    }
                },
                ["m"] = {
                    "move",
                    config = {
                        show_path = "relative"
                    }
                },
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["H"] = "toggle_hidden",
                ["/"] = "fuzzy_finder",
                ["<C-/>"] = "fuzzy_finder_directory",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root"
            },
            fuzzy_finder_mappings = {
                ["<down>"] = "move_cursor_down",
                ["<C-n>"] = "move_cursor_down",
                ["<up>"] = "move_cursor_up",
                ["<C-p>"] = "move_cursor_up"
            }
        },
        commands = {
            telescope_find = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                require('telescope.builtin').find_files(getTelescopeOpts(state, path))
            end,
            telescope_grep = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                require('telescope.builtin').live_grep(getTelescopeOpts(state, path))
            end
        }
    },
    buffers = {
        window = {
            mappings = {
                ["d"] = "buffer_delete"
            }
        }
    },
    git_status = {
        window = {
            mappings = {
                ["a"] = "git_add_file",
                ["A"] = "git_add_all",
                ["u"] = "git_unstage_file",
                ["r"] = "git_revert_file",
                ["c"] = "git_commit",
                ["p"] = "git_push",
                ["cp"] = "git_commit_and_push"
            }
        }
    },
    event_handlers = {{
        event = "neo_tree_window_after_open",
        handler = function(args)
            if args.position == "left" or args.position == "right" then
                vim.cmd("wincmd =")
            end
        end
    }, {
        event = "neo_tree_window_after_close",
        handler = function(args)
            if args.position == "left" or args.position == "right" then
                vim.cmd("wincmd =")
            end
        end
    }, {
        event = "file_opened",
        handler = function(file_path)
            require("neo-tree.command").execute({
                action = "close"
            })
        end
    }}
}
