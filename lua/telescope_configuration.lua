--- Pick a directory to cd into
local cdPicker = function(name, cmd)
  require("telescope.pickers").new({}, {
    prompt_title = name,
    finder = require("telescope.finders").new_table({
      results = require("telescope.utils").get_os_command_output(cmd),
    }),
    previewer = require("telescope.previewers").vim_buffer_cat.new({}),
    sorter = require("telescope.sorters").get_fuzzy_file(),
    attach_mappings = function(prompt_bufnr)
      require("telescope.actions.set").select:replace(function(_)
        local entry = require("telescope.actions.state").get_selected_entry()
	require("telescope.actions").close(prompt_bufnr)
	local dir = require("telescope.from_entry").path(entry)
        vim.api.nvim_set_current_dir((dir:gsub("\\ "," ")))
      end)
      return true
    end,
  }):find()
end

Cd = function(path)
  path = path or "."
  cdPicker("Cd", { vim.o.shell,	"-c", "fdfind . " .. path .. " -t d" })
end

Project = function(path)
  path = path or "."
  cdPicker("Project", { vim.o.shell, "-c", "fdfind '.*\\.git$|.*\\.proj$' " .. path .. " -H -t d | sed 's@/\\.git/$\\|/\\.proj/$@@'" })
end

require("telescope").extensions["cd"] = {
  cd=function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.env.HOME
  Cd(opts.cwd)
end,}

require("telescope").extensions["project"] = {
  project=function(opts)
    opts = opts or {}
    opts.cwd = opts.cwd or vim.env.HOME
    Project(opts.cwd)
  end
}
