local M = {}

M.get_fs = function(fn, search, loc, type, maxdepth)
  if search == "" then
    search = "."
  end

  local cmd = "fd" .. (" " .. search .. " ") .. (" " .. loc .. " ")
  local data = {}
  local cb = fn or function() end

  if type then
    cmd = cmd .. " -t " .. type
  end
  if maxdepth then
    cmd = cmd .. " -d " .. maxdepth
  end

  local task = hs.task.new(
    "/bin/zsh",
    function (exitCode, stdOut, stdErr)
      print("Exit code:" .. tostring(exitCode))
      cb(data)
    end,
    function(lcmd, out, err)
      print("Ran:" .. tostring(lcmd))
      print("Err:" .. err)
      data = hs.fnutils.concat(
        data,
        hs.fnutils.imap(hs.fnutils.ifilter(
          hs.fnutils.split(out, "\n"),
          function(ldata)
            if ldata ~= "" then
              return true
            end
          end),
          function(line)
            return { text = line }
          end
        )
      )
      return true
    end,
    { "-c", cmd}
  )
  task:start()
end

M.get_fs_debounced = function(fn, loc, type, maxdepth)
  local search = "."
  local timer = hs.timer.delayed.new(0.5, function()
    M.get_fs(fn, search, loc, type, maxdepth)
  end)
  return function(arg)
    search = arg
    timer:stop()
    timer:start()
  end
end

return M
