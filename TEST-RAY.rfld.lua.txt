--[ Created by TenshiDev (no AI Maker) ]--

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "redZinx Hub | Blox Fruits",
    LoadingTitle = "Loading Please Wait...",
    LoadingSubtitle = "by TenshiDev",
    Icon = 0,
    KeySystem = true,
    KeySettings = {
        Title = "redZinx Hub Keysystem",
        Subtitle = "Script redZinx Premium",
        Note = "Take a Key on Owner Discord",
        FileName = "redZinxKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"FREE_U1Z4X9C91C01M6C0V9M", "FREE_u19m0vb704v9x6m5mzzx", "tenshidevpremium-u7m90nm7912", "PREMIUM_g7kl4d3p91li97kas9x91c90c", "IDN_premiumkeyyy143", "TNSHI_IDNKEY9324", "ChildIDN_SumbangPalestinaPremiumKey", "PalestinaKey_Sumbang890"}
    }
})

local MainTab = Window:CreateTab("⛓️ Main")
local MiscTab = Window:CreateTab("⚙️ Misc")

local Section = MainTab:CreateSection("Scripts Main")

local Button = MainTab:CreateButton({
    Name = "redZinx Hub (V1)",
    Callback = function()
        loadstring(game:HttpGet("https://scripts-raw.gamer.gd/cdn/redzinxv1.lua"))()
    end,
})

local Button = MainTab:CreateButton({
    Name = "redZinx Hub (V2)",
    Callback = function()
        loadstring(game:HttpGet("https://scripts-raw.gamer.gd/cdn/redzinxv2.lua"))()
    end,
})

local Paragraph = MiscTab:CreateParagraph({
    Title = "Misc",
    Content = "This Is a Misc Tab."
})

local Button = MiscTab:CreateButton({
    Name = "Close Window",
    Callback = function()
        Rayfield:Destroy()
    end,
})

Rayfield:Notify({
    Title = "Loaded Script!",
    Content = "Completed Loaded Script...",
    Duration = 5,
})
