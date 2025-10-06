local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield by Rzq",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Rzq",
   ShowText = "GUI", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local md5, hmac, base64 = {}, {}, {}

local T = {
	0xd76aa478,0xe8c7b756,0x242070db,0xc1bdceee,0xf57c0faf,0x4787c62a,0xa8304613,0xfd469501,
	0x698098d8,0x8b44f7af,0xffff5bb1,0x895cd7be,0x6b901122,0xfd987193,0xa679438e,0x49b40821,
	0xf61e2562,0xc040b340,0x265e5a51,0xe9b6c7aa,0xd62f105d,0x02441453,0xd8a1e681,0xe7d3fbc8,
	0x21e1cde6,0xc33707d6,0xf4d50d87,0x455a14ed,0xa9e3e905,0xfcefa3f8,0x676f02d9,0x8d2a4c8a,
	0xfffa3942,0x8771f681,0x6d9d6122,0xfde5380c,0xa4beea44,0x4bdecfa9,0xf6bb4b60,0xbebfbc70,
	0x289b7ec6,0xeaa127fa,0xd4ef3085,0x04881d05,0xd9d4d039,0xe6db99e5,0x1fa27cf8,0xc4ac5665,
	0xf4292244,0x432aff97,0xab9423a7,0xfc93a039,0x655b59c3,0x8f0ccc92,0xffeff47d,0x85845dd1,
	0x6fa87e4f,0xfe2ce6e0,0xa3014314,0x4e0811a1,0xf7537e82,0xbd3af235,0x2ad7d2bb,0xeb86d391,
}

local function add32(a, b)
	local lsw = bit32.band(a, 0xFFFF) + bit32.band(b, 0xFFFF)
	local msw = bit32.rshift(a, 16) + bit32.rshift(b, 16) + bit32.rshift(lsw, 16)
	return bit32.bor(bit32.lshift(msw, 16), bit32.band(lsw, 0xFFFF))
end

local function rol(x, n)
	return bit32.bor(bit32.lshift(x, n), bit32.rshift(x, 32 - n))
end

local function F(x, y, z) return bit32.bor(bit32.band(x, y), bit32.band(bit32.bnot(x), z)) end
local function G(x, y, z) return bit32.bor(bit32.band(x, z), bit32.band(y, bit32.bnot(z))) end
local function H(x, y, z) return bit32.bxor(x, bit32.bxor(y, z)) end
local function I(x, y, z) return bit32.bxor(y, bit32.bor(x, bit32.bnot(z))) end

function md5.sum(message)
	local a, b, c, d = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
	local message_len = #message
	local padded = message .. string.char(0x80)
	while #padded % 64 ~= 56 do padded = padded .. string.char(0) end
	local len_bits = message_len * 8
	for i = 0, 7 do padded = padded .. string.char(bit32.band(bit32.rshift(len_bits, i * 8), 0xFF)) end
	local s = {7,12,17,22, 5,9,14,20, 4,11,16,23, 6,10,15,21}
	for i = 1, #padded, 64 do
		local chunk = padded:sub(i, i + 63)
		local X = {}
		for j = 0, 15 do
			local b1, b2, b3, b4 = chunk:byte(j * 4 + 1, j * 4 + 4)
			X[j] = bit32.bor(b1, bit32.lshift(b2, 8), bit32.lshift(b3, 16), bit32.lshift(b4, 24))
		end
		local aa, bb, cc, dd = a, b, c, d
		for j = 0, 63 do
			local f, k, shift_index
			if j < 16 then f, k, shift_index = F(b, c, d), j, j % 4
			elseif j < 32 then f, k, shift_index = G(b, c, d), (1 + 5 * j) % 16, 4 + (j % 4)
			elseif j < 48 then f, k, shift_index = H(b, c, d), (5 + 3 * j) % 16, 8 + (j % 4)
			else f, k, shift_index = I(b, c, d), (7 * j) % 16, 12 + (j % 4) end
			local temp = add32(a, f)
			temp = add32(temp, X[k])
			temp = add32(temp, T[j + 1])
			temp = rol(temp, s[shift_index + 1])
			local new_b = add32(b, temp)
			a, b, c, d = d, new_b, b, c
		end
		a, b, c, d = add32(a, aa), add32(b, bb), add32(c, cc), add32(d, dd)
	end
	local function to_le_bytes(n)
		local out = {}
		for i = 0, 3 do out[#out + 1] = string.char(bit32.band(bit32.rshift(n, i * 8), 0xFF)) end
		return table.concat(out)
	end
	return to_le_bytes(a) .. to_le_bytes(b) .. to_le_bytes(c) .. to_le_bytes(d)
end

function hmac.new(key, msg, hash_func)
	if #key > 64 then key = hash_func(key) end
	local o, i = {}, {}
	for x = 1, 64 do
		local b = (x <= #key) and key:byte(x) or 0
		o[x] = string.char(bit32.bxor(b, 0x5C))
		i[x] = string.char(bit32.bxor(b, 0x36))
	end
	o, i = table.concat(o), table.concat(i)
	return hash_func(o .. hash_func(i .. msg))
end

do
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	function base64.encode(data)
		local bits = (data:gsub(".", function(x)
			local byte, s = x:byte(), ""
			for i = 8, 1, -1 do s = s .. ((byte % 2 ^ i - byte % 2 ^ (i - 1) > 0) and "1" or "0") end
			return s
		end) .. "0000")
		local res = bits:gsub("%d%d%d?%d?%d?%d?", function(x)
			if #x < 6 then return "" end
			local c = 0
			for i = 1, 6 do if x:sub(i, i) == "1" then c = c + 2 ^ (6 - i) end end
			return chars:sub(c + 1, c + 1)
		end)
		local pad = ({ "", "==", "=" })[#data % 3 + 1]
		return res .. pad
	end
end

local function GenerateReservedServerCode(placeId)
	local uuid = {}
	for i = 1, 16 do uuid[i] = math.random(0, 255) end
	uuid[7] = bit32.bor(bit32.band(uuid[7], 0x0F), 0x40)
	uuid[9] = bit32.bor(bit32.band(uuid[9], 0x3F), 0x80)
	local first = {}
	for i = 1, 16 do first[i] = string.char(uuid[i]) end
	first = table.concat(first)
	local gameCode = string.format(
		"%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
		table.unpack(uuid)
	)
	local pid = {}
	local temp = placeId
	for _ = 1, 8 do pid[#pid + 1] = string.char(temp % 256); temp = math.floor(temp / 256) end
	pid = table.concat(pid)
	local content = first .. pid
	local LEGACY_KEY = "e4Yn8ckbCJtw2sv7qmbg"
	local sig = hmac.new(LEGACY_KEY, content, md5.sum)
	local bytes = sig .. content
	local accessCode = base64.encode(bytes):gsub("+", "-"):gsub("/", "_")
	local pad = 0
	accessCode = accessCode:gsub("=", function() pad = pad + 1 return "" end)
	accessCode = accessCode .. tostring(pad)
	return accessCode, gameCode
end

local PlaceID = ""
local ServerCode = ""

local Tab = Window:CreateTab("Server", "server") -- Title, Image

local Section = Tab:CreateSection("Private Server")
local Button = Tab:CreateButton({
   Name = "Use Current Place ID",
   Callback = function()
        PlaceID = game.PlaceId
        Rayfield:Notify({Title="Place ID", Content=""..PlaceID, Duration=3})
   end,
})

local Button = Tab:CreateButton({
   Name = "Generate Server Code",
   Callback = function()
        if not PlaceID or PlaceID == 0 then
            Rayfield:Notify({Title="Error", Content="Masukkan Place ID terlebih dahulu!", Duration=3})
            return
        end
        local accessCode, gameCode = GenerateReservedServerCode(PlaceID)
        GeneratedCode = accessCode
        Rayfield:Notify({Title="Server Code Generated", Content=accessCode, Duration=6})
   end,
})

local Button = Tab:CreateButton({
   Name = "Create Private Server",
   Callback = function()
        if not GeneratedCode then
            Rayfield:Notify({Title="Error", Content="Generate dulu server code-nya!", Duration=3})
            return
        end
        game.RobloxReplicatedStorage.ContactListIrisInviteTeleport:FireServer(PlaceID, "", GeneratedCode)
   end,
})

local Button = Tab:CreateButton({
   Name = "Copy Server Code",
   Callback = function()
        if not GeneratedCode then
            Rayfield:Notify({Title="Error", Content="Belum ada server code untuk dicopy!", Duration=3})
            return
        end
        setclipboard(GeneratedCode)
        Rayfield:Notify({Title="Copied", Content="Server Code berhasil disalin!", Duration=3})
   end,
})

local Section = Tab:CreateSection("Manual")
local Input = Tab:CreateInput({
   Name = "Place ID",
   PlaceholderText = "Masukkan Place ID",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
        PlaceID = tonumber(Text) or 0
   end,
})

local Input = Tab:CreateInput({
   Name = "Server Code",
   PlaceholderText = "Masukkan Server Code",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
        ServerCode = Text
   end,
})

local Button = Tab:CreateButton({
   Name = "Join Server (Manual)",
   Callback = function()
        if not PlaceID or PlaceID == 0 or not ServerCode or ServerCode == "" then
            Rayfield:Notify({Title="Error", Content="Isi Place ID dan Server Code!", Duration=3})
            return
        end
        game.RobloxReplicatedStorage.ContactListIrisInviteTeleport:FireServer(PlaceID, "", ServerCode)
   end,
})
