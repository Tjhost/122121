-- Function to create buttons
local function createButton(tab, name, url)
    return tab:CreateButton({
        Name = name,  -- Button name (you can include emojis here)
        Callback = function()  -- What happens when the button is clicked
            loadstring(game:HttpGet(url))()  -- Loads and runs the Lua script from the URL
        end,
    })
end