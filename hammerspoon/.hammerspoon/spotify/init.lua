local mode_store = require("wmode.core")

SpotifyM = hs.hotkey.modal.new(Hyper, "s")
function SpotifyM:entered()
	mode_store.set_mode("Spotify", true)
	hs.alert.show("Spotify mode")
end
function SpotifyM:exited()
	mode_store.set_mode("Spotify", nil)
	hs.alert.show("Exit Spotify mode")
end
SpotifyM:bind(Hyper, "s", function() SpotifyM:exit() end)

SpotifyM:bind("", "k", function() hs.spotify.playpause() end)
SpotifyM:bind("", "h", function() hs.spotify.previous() end)
SpotifyM:bind("", "l", function() hs.spotify.next() end)
SpotifyM:bind("", "j", function() hs.spotify.displayCurrentTrack() end)