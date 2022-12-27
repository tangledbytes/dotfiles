local M = {}

M.osascript_open_directory_in_iterm = function(dir)
	local success, _, _ = hs.osascript.applescript([[
		tell application "iTerm"
			activate
			tell current window
				create tab with default profile
				tell current session
					write text "cd ]] .. dir .. [["
					tell application "System Events"
						tell process "iTerm"
							keystroke "k" using command down
							keystroke "code ." 
						end tell
					end tell
				end tell
			end tell
		end tell
	]])

	if not success then
		hs.notify.show("Failed to open directory in iTerm", "", "")
	end
end

return M