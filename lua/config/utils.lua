local M = {}
local opts = {}
function M.tidy_contents()
  --  Before we start the main tidying, sort some names out:
  vim.cmd([[silent! execute '%s/Tom Holt \[as by K. J. Parker\]/K. J. Parker']])
  vim.cmd([[silent! execute '%s/Allen Steele \[as by Allen M. Steele\]/Allen Steele']])
  vim.cmd([[silent! execute '%s/Robin Hobb \[as by Megan Lindholm\]/Robin Hobb']])
  vim.cmd([[silent! execute '%s/Kiernan?/Kiernan']])
  -- Main Tidying
  vim.cmd([[silent! execute "g/^$/d"]]) -- Delete empty Lines
  vim.cmd([[silent! execute '%s/^\s*/']]) -- Delete blank space at start of line
  vim.cmd([[silent! execute '%s/^\d* • /']]) -- Removes extraneous numbers before the story title
  vim.cmd([[silent! execute '%s/\s\+$/']]) -- Removes blank spaces at end of line
  vim.cmd([[silent! execute '%s/ • non-genre\| • juvenile//']])
  vim.cmd([[silent! execute '%s/novella by /na • ']])
  vim.cmd([[silent! execute '%s/novelette by /nv • ']])
  vim.cmd([[silent! execute '%s/short story by /ss • ']])
  vim.cmd([[silent! execute '%s/short fiction by /ss • ']])
  -- vim.cmd [[silent! execute '%s/(\d\{4}) • /']]
  -- vim.cmd([[silent! execute 'g/• poem \|• essay \|• juvenile /d']])
  vim.cmd([[silent! execute 'g/• poem \|• essay \|• interior artwork by /d']])
  vim.cmd([[silent! execute '%s/\( • \[.*\]\)\(.*\)/\2\1']]) -- Moves series to end

  -- Check if we need a header ( for django importing )
  local header = "Title • Year • Length • Author(s) • Series"

  -- Set the cursor to beginning of buffer
  vim.api.nvim_win_set_cursor(0, { 1, 0 })

  local line = vim.api.nvim_get_current_line()
  if line ~= header then
    M.add_line(0, 0, header)
  end

  -- highlight remaining problems
  vim.cmd([[silent! execute '/• \d\|trans\.\|as by']])
end

-- utility function to add a line of text
function M.add_line(start_line, end_line, replacement)
  vim.api.nvim_buf_set_lines(0, start_line, end_line, true, { replacement })
end

-- Can probably delete this, functionality was moved to importer.py
-- function M.add_year(year)
--   local header = "Title • Year • Length • Author(s) • Series"
--
--   -- Set the cursor to beginning of buffer
--   vim.api.nvim_win_set_cursor(0, { 1, 0 })
--
--   -- If the first line is the header, delete it
--   local line = vim.api.nvim_get_current_line()
--   if line == header then
--     vim.api.nvim_del_current_line()
--   end
--
--   -- Add the year
--   local phrase = "silent! execute " .. "'%s/ • (\\@!/ • (" .. year .. ") • '"
--   vim.cmd(phrase)
--
--   -- Add the header back
--   M.add_line(0, 0, header)
--
--   -- Remove the stupid highlighting
--   vim.cmd("silent! execute 'noh'")
-- end

-- *************************** --
-- Latex Bold / Italic
-- function M.add_bold()
--   -- -- Leaving these lines as example of getting mode
--   vim.cmd([[execute 's/\(' . expand('<cword>') . '\)/\\textbf{\1}/']])
-- end
--
-- function M.add_bold_visual()
--   -- yank into the z register
--   vim.cmd('noau normal! "zy"')
--   vim.cmd([[execute 's/\(' . getreg("z") . '\)/\\textbf{\1}/']])
-- end

-- function M.add_italic()
--   vim.cmd([[execute 's/\(' . expand('<cword>') . '\)/\\textit{\1}/']])
-- end

function M.add_italic()
  local final_table = {}
  -- First check if we're in normal mode: if so, we want the current word
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then
    vim.cmd("noau normal! viw")
  end
  -- Then grab the visual range
  local positions = M.get_visual_selection()
  local start, finish = positions.start, positions.finish
  -- get the text to change
  local text = vim.api.nvim_buf_get_text(0, start.row, start.col, finish.row, finish.col, opts)
  -- add the replacement text
  local final_text = "\\textit{" .. text[1] .. "}"
  table.insert(final_table, final_text)
  vim.api.nvim_buf_set_text(0, start.row, start.col, finish.row, finish.col, final_table)
  -- and quit out of visual mode
  vim.api.nvim_feedkeys("Esc", "x", true)
end

function M.add_bold()
  local final_table = {}
  -- First check if we're in normal mode: if so, we want the current word
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then
    vim.cmd("noau normal! viw")
  end
  -- Then grab the visual range
  local positions = M.get_visual_selection()
  local start, finish = positions.start, positions.finish
  -- get the text to change
  local text = vim.api.nvim_buf_get_text(0, start.row, start.col, finish.row, finish.col, opts)
  -- add the replacement text
  local final_text = "\\textbf{" .. text[1] .. "}"
  table.insert(final_table, final_text)
  vim.api.nvim_buf_set_text(0, start.row, start.col, finish.row, finish.col, final_table)
  -- and quit out of visual mode
  vim.api.nvim_feedkeys("Esc", "x", true)
end

function M.add_markdown_wikilink()
  local final_table = {}
  -- First check if we're in normal mode: if so, we want the current word
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then
    vim.cmd("noau normal! viw")
  end
  -- Then grab the visual range
  local positions = M.get_visual_selection()
  local start, finish = positions.start, positions.finish
  -- get the text to change
  local text = vim.api.nvim_buf_get_text(0, start.row, start.col, finish.row, finish.col, opts)
  -- add the replacement text
  local final_text = "[[" .. text[1] .. "]]"
  table.insert(final_table, final_text)
  vim.api.nvim_buf_set_text(0, start.row, start.col, finish.row, finish.col, final_table)
  -- and quit out of visual mode
  vim.api.nvim_feedkeys("Esc", "x", true)
end

function M.toggle_markdown_bp()
  local line = vim.api.nvim_get_current_line()
  local has_dash = string.find(line, "^%s*%-%s")
  local new_line = ""
  if has_dash then
    new_line = string.gsub(line, "^%s*%-%s", "")
  else
    new_line = " - " .. line
  end
  vim.api.nvim_set_current_line(new_line)
end

function M.book_to_get()
  -- Grab the visual range
  local positions = M.get_visual_selection()
  local start, finish = positions.start, positions.finish
  -- get the text to change
  local text = vim.api.nvim_buf_get_text(0, start.row, start.col, finish.row, finish.col, opts)
  local new_text = "- " .. text[1]
  -- Set the new text into the z register
  vim.fn.setreg("z", new_text)
  -- Append the z register to file
  vim.cmd(
    [[execute "call writefile([getreg('z')], '/mnt/c/Users/Gordon/Documents/Obsidian/Main/Books/Shelves/To Get/_to_get.md', 'a')"]]
  )
  -- and quit out of visual mode
  vim.api.nvim_feedkeys("Esc", "x", true)
end

function M.remove_latex_surrounding()
  vim.cmd([[silent! execute "call search('\','b')"]])
  -- vim.cmd("noau normal! vf{%")
  vim.cmd("noau normal! vf{xf}x")
end

-- Utility function to grab the current visual selection
--
function M.get_visual_selection()
  local vpos = vim.fn.getpos("v")
  local start = { row = vpos[2] - 1, col = vpos[3] - 1 }
  local dotpos = vim.fn.getpos(".")
  local finish = { row = dotpos[2] - 1, col = dotpos[3] }
  if (start.row < finish.row) or ((start.row == finish.row) and (start.col <= finish.col)) then
    return { start = start, finish = finish }
  else
    start.col = start.col + 1
    finish.col = finish.col - 1
    return { start = finish, finish = start }
  end
end

function M.dump(o)
  -- Prints a table
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

return M
