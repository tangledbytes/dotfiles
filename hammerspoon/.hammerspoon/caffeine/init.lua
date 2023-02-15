local mode_store = require("wmode.core")

hs.hotkey.bind(Hyper, "c", function()
    hs.caffeinate.toggle("displayIdle")

    if (hs.caffeinate.get("displayIdle")) then
        print("Caffeine enabled")
        mode_store.set_mode("Caffeine", true)
    else
        print("Caffeine disabled")
        mode_store.set_mode("Caffeine", nil)
    end
end)
