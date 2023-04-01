_G.ADBAVERSION = 0.63;
adBASet = {};
local maxtex = 30;
local add={
	gui={{
		name = "adBottomArt",
		version = ADBAVERSION,
		window = "adBottomArtGUI",
	}},
	popup={{
		GetText = function() return adBottomArt_PopText(); end,
		GetTooltip = function() return "/adba, /adBottomArt\n\n"..adBALang["XAddonTip1"].."\n"..adBALang["XAddonTip2"]; end,
		OnClick = function(this, key) adBottomArt_PopClick(this, key); end,
}}};

function adBottomArt_PopClick(this, key)
	if key=="LBUTTON" then
		XAddon_ShowPage("adBottomArtGUI");
	else
		adBottomArtSlash(nil, "switch");
	end
end

function adBottomArt_PopText()
	if adBASet["ArtShown"]==true then
		return "adBottomArt - "..ON;
	else
		return "adBottomArt - "..C_OFF;
	end
end

function adBottomArt_OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED");
	adBottomArtDownMenu_OnLoad();

	local lang = GetLanguage():upper();
	local _, err = loadfile("Interface/Addons/adBottomArt/Locales/"..lang..".lua");
	if err then
		adBottomArt_Print("|cff993333adBA can't find translation, ENUS.lua loaded.|r");
		dofile("Interface/Addons/adBottomArt/Locales/ENUS.lua");
	else
		dofile("Interface/Addons/adBottomArt/Locales/"..lang..".lua");
	end
end

function adBottomArtDownMenu_OnLoad()
	for i = 1, maxtex do
		local _, err = loadfile("Interface/Addons/adBottomArt/Textures/"..i.."/loadfile.lua");
		if err then
			maxtex = i - 1;
			return;
		end
	end
end

function adBottomArtDownMenu_OnShow()
	local info = {};
	info.value = 0;
	info.text = "snl";
	info.func = adBottomArtDownMenu_Click;
	UIDropDownMenu_AddButton(info);

	for i = 1, maxtex do
		info = {};
		info.value = i;
		info.text = i;
		info.func = adBottomArtDownMenu_Click;
		UIDropDownMenu_AddButton(info);
	end
end

function adBottomArtDownMenu_Click(button)
	if button.value==0 then
		adBASet["ArtName"] = "snl";
	else
		adBASet["ArtName"] = button.value;
	end
	adBottomArtSetSkin(adBASet["ArtName"]);
	UIDropDownMenu_SetSelectedID(adBottomArtGUIDownMenu, button.value+1);
end

function adBottomArtSwitch_Click()
	if adBASet["ArtName"]==maxtex then
		adBottomArtSetSkin("snl");
		adBASet["ArtName"] = "snl";
		UIDropDownMenu_SetSelectedID(adBottomArtGUIDownMenu, 1);
	return; end
	local skin = 1;
	for i = 1, maxtex do
		if adBASet["ArtName"]==i then
			skin = i+1;
		end
	end
	adBottomArtSetSkin(skin);
	adBASet["ArtName"] = tonumber(skin);
	UIDropDownMenu_SetSelectedID(adBottomArtGUIDownMenu, skin+1);
end

function adBottomArtSetWidth(v)
	local scale=GetUIScale();
	for i = 1, 8 do
		getglobal("adBottomArtFrameBG"..i):SetWidth(v/scale);
	end
end

function adBottomArtSetHeight(v)
	local scale=GetUIScale();
	for i = 1, 8 do
		getglobal("adBottomArtFrameBG"..i):SetHeight(v/scale);
	end
end

function adBottomArtSetSkin(v)
	for i = 1, 8 do
		getglobal("adBottomArtFrameBG"..i):SetTexture("Interface/AddOns/adBottomArt/Textures/"..v.."/bg"..i..".tga");
	end
end

function adBottomArtSetColor(v)
end

function adBottomArt_LoadSettings()
	local def = {
		["ToggleMenu"] = false,
		["ToggleChat"] = true,
		["ArtScale"] = 1,
		["ArtAlpha"] = 1,
		["ArtWidth"] = 512,
		["ArtHeight"] = 256,
		["ArtXOffset"] = 0,
		["ArtYOffset"] = 0,
		["ArtName"] = "snl",
		["ArtShown"] = true,
	};
	for k,v in pairs(def) do
		if adBASet[k]==nil then
			adBASet[k] = v;
		end
	end
	SaveVariables("adBASet");
end

function adBottomArt_OnEvent(event, this)
	if event=="VARIABLES_LOADED" then
		adBottomArt_LoadSettings();
		adBottomArt_Print(adBALang["Load"], ADBAVERSION, (maxtex+1));
		if adBASet["ToggleMenu"] ~= nil and adBASet["ToggleMenu"]==true then MainMenuFrame:Hide(); ExperienceFrame:Hide(); end
		if adBASet["ToggleChat"] ~= nil and adBASet["ToggleChat"]==true then
			for i = 1, 8 do
				getglobal("ChatFrame"..i):SetBackdropTileAlpha(0);
				getglobal("ChatFrame"..i):SetBackdropEdgeAlpha(0);
				getglobal("ChatFrame"..i.."ResizeButton"):SetAlpha(0.1);
			end
			ChatFrameEmoteButton:SetAlpha(0.1); ChatFrameRestoreButton:SetAlpha(0.1); ChatFrameChannelChangeResizeButton:SetAlpha(0.1);
			MainActionBarFrameButtonEX:SetAlpha(0.1); BottomActionBarFrameButtonEX:SetAlpha(0.1); LeftActionBarFrameButtonEX:SetAlpha(0.1); RightActionBarFrameButtonEX:SetAlpha(0.1);
		end
		if adBASet["ArtScale"] ~= nil then adBottomArtFrame:SetScale(adBASet["ArtScale"]); end
		if adBASet["ArtAlpha"] ~= nil then adBottomArtFrame:SetAlpha(adBASet["ArtAlpha"]); end
		if adBASet["ArtWidth"] ~= nil then adBottomArtSetWidth(adBASet["ArtWidth"]); end
		if adBASet["ArtHeight"] ~= nil then adBottomArtSetHeight(adBASet["ArtHeight"]); end
		if adBASet["ArtYOffset"] ~= nil and adBASet["ArtXOffset"] ~= nil then
			adBottomArtFrame:ClearAllAnchors();
			adBottomArtFrame:SetAnchor("BOTTOM", "BOTTOM", "UIParent", adBASet["ArtXOffset"]/adBASet["ArtScale"], -(adBASet["ArtYOffset"]/adBASet["ArtScale"]));
		end
		if adBASet["ArtName"] ~= nil then adBottomArtSetSkin(adBASet["ArtName"]); end
		if adBASet["ArtShown"] ~= nil and adBASet["ArtShown"]==false then adBottomArtFrame:Hide(); end
		if XBARVERSION and XBARVERSION>=1.51 then
			XAddon_Register(add);
		end
	end
end

function adBottomArt_GetWords(str)
	local ret = {};
	local pos=0;
	while(true) do
		local word;
		_,pos,word=string.find(str, "^ *([^%s]+) *", pos+1);
		if(not word) then
			return ret;
		end
		table.insert(ret, word);
	end
end

function adBottomArtSlash(ebox, v)
	local v = string.lower(v);
	local wL = adBottomArt_GetWords(v);
	local scale=GetUIScale();

	if wL[1]=="alpha" then
		adBASet["ArtAlpha"] = wL[2];
		adBottomArtFrame:SetAlpha(wL[2]);
	elseif wL[1]=="scale" then
		adBASet["ArtScale"] = wL[2];
		adBottomArtFrame:SetScale(wL[2]);
	elseif wL[1]=="width" then
		adBASet["ArtWidth"] = wL[2];
		adBottomArtSetWidth(wL[2]);
	elseif wL[1]=="height" then
		adBASet["ArtHeight"] = wL[2];
		adBottomArtSetHeight(wL[2]);
	elseif wL[1]=="xoffset" then
		adBASet["ArtXOffset"] = wL[2];
		adBottomArtFrame:ClearAllAnchors();
		adBottomArtFrame:SetAnchor("BOTTOM", "BOTTOM", "UIParent", adBASet["ArtXOffset"]/adBASet["ArtScale"], -(adBASet["ArtYOffset"]/adBASet["ArtScale"]));
	elseif wL[1]=="yoffset" then
		adBASet["ArtYOffset"] = wL[2];
		adBottomArtFrame:ClearAllAnchors();
		adBottomArtFrame:SetAnchor("BOTTOM", "BOTTOM", "UIParent", adBASet["ArtXOffset"]/adBASet["ArtScale"], -(adBASet["ArtYOffset"]/adBASet["ArtScale"]));
	elseif wL[1]=="switch" then
		adBASet["ArtShown"] = adBottomArtGUIEnable:IsChecked();
		if adBottomArtFrame:IsVisible() then
			adBASet["ArtShown"] = false;
			adBottomArtFrame:Hide();
		else
			adBASet["ArtShown"] = true;
			adBottomArtFrame:Show();
		end
	elseif wL[1]=="skin" then
		adBASet["ArtName"] = wL[2];
		adBottomArtSetSkin(wL[2]);
	elseif wL[1]=="autow" then
		adBottomArtSlash(nil, "width " .. tostring(512 * GetScreenWidth() / 2048)); --512 * scale
		adBottomArtSlash(nil, "scale 1");
		adBottomArtSlash(nil, "xoffset "..tostring(0) ); --1600 scale
	elseif wL[1]=="autoh" then
		adBottomArtSlash(nil, "height "..tostring(GetScreenWidth()/8) ); --4 parts of skin, width:screen = 1:4, height:width = 1:2
		adBottomArtSlash(nil, "scale 1");
	elseif wL[1]=="chath" then
		adBottomArtSlash(nil, "height "..tostring(ChatFrame1:GetHeight()+60 )*scale  ); --looks better
		adBottomArtSlash(nil, "scale 1");
	elseif wL[1]=="16center" then
		adBottomArtSlash(nil, "xoffset "..tostring( (224*(GetScreenWidth()/2048))/scale )  ); --1024-800=224, 1024->2048center, 800->1600center
		adBottomArtSlash(nil, "scale 1");
	elseif wL[1]=="16scale" then
		adBottomArtSlash(nil, "width "..tostring( (GetScreenWidth()/4)*1.28) ); --2048/1600 = 1.28
		adBottomArtSlash(nil, "height "..tostring( (GetScreenWidth()/8)*1.28) );
		adBottomArtSlash(nil, "xoffset "..tostring( (224*(GetScreenWidth()/1600))/scale )  ); --1600 scale
		adBottomArtFrame:SetScale(1);
	elseif wL[1]=="16chath" then
		adBottomArtSlash(nil, "height "..tostring(ChatFrame1:GetHeight()+60 )*scale*1.28  ); --looks better
		adBottomArtSlash(nil, "scale 1");
	else
		if XBARVERSION and XBARVERSION>=1.51 then
			XAddon_ShowPage("adBottomArtGUI");
		else
			ToggleUIFrame(adBottomArtGUI);
		end
	end
	adBottomArtTexts(adBottomArtGUI);
end

SLASH_adBottomArtSlash1 = "/adBottomArt";
SLASH_adBottomArtSlash2 = "/adBA";
SlashCmdList["adBottomArtSlash"] = adBottomArtSlash;

function adBottomArtTexts(this)
	adBottomArtGUIEnable:SetChecked(adBASet["ArtShown"]);
	adBottomArtGUIToggleMenu:SetChecked(adBASet["ToggleMenu"]);
	adBottomArtGUIToggleChat:SetChecked(adBASet["ToggleChat"]);
	adBottomArtGUIWidth:SetValue(adBASet["ArtWidth"]);
	adBottomArtGUIHeight:SetValue(adBASet["ArtHeight"]);
	adBottomArtGUIScale:SetValue(adBASet["ArtScale"]);
	adBottomArtGUIAlpha:SetValue(adBASet["ArtAlpha"]);
	adBottomArtGUIXOffset:SetText(adBASet["ArtXOffset"]);
	adBottomArtGUIYOffset:SetText(adBASet["ArtYOffset"]);

	adBottomArtGUITitle:SetText("adBottomArt")
	adBottomArtGUIHideDesc:SetText(adBALang["HideDesc"]);
	adBottomArtGUIToggleMenuName:SetText(adBALang["ToggleMenu"]);
	adBottomArtGUIToggleChatName:SetText(adBALang["ToggleChat"]);
	adBottomArtGUIAddDesc:SetText(adBALang["AddDesc"]);
	adBottomArtGUIXOffsetName:SetText("X");
	adBottomArtGUIYOffsetName:SetText("Y");
	adBottomArtGUIDownMenuName:SetText(adBALang["Skin"]);
	adBottomArtGUIAutoWidthName:SetText(adBALang["AutoWidth"]);
	adBottomArtGUIAutoHeightName:SetText(adBALang["AutoHeight"]);
	adBottomArtGUIChatHeightName:SetText(adBALang["ChatHeight"]);
	adBottomArtGUI1600Desc:SetText(adBALang["1600Desc"]);
	adBottomArtGUI1600CenterName:SetText(adBALang["1600Center"]);
	adBottomArtGUI1600ScaleName:SetText(adBALang["1600Scale"]);
	adBottomArtGUI1600ChatHeightName:SetText(adBALang["ChatHeight"]);
	adBottomArtGUIVersion:SetText(ADBAVERSION);
	if XBARVERSION and XBARVERSION>=1.51 then
		XAddon_Page(this);
		XAddon_HideBack1(this);
		adBottomArtGUITitle:SetText(" ");
		adBottomArtGUIVersion:SetText(" ");
	end
end

function adBottomArt_Print(str, ...)
	DEFAULT_CHAT_FRAME:AddMessage(str:format(...), 1, 1, 1);
end