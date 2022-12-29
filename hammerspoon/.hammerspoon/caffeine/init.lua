-- Caffiene for mac
_caffeine = hs.menubar.new()

local function setCaffeineDisplay(state)
    if state then
        _caffeine:setTitle("AWAKE")
    else
        _caffeine:setTitle("SLEEPY")
    end
end

local function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if _caffeine then
    _caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end