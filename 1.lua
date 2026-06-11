if _G._ANTICHEAT_BYPASS_LOADED then
    return
end
_G._ANTICHEAT_BYPASS_LOADED = true

local expire_time = os.time({year = 2026, month = 7, day = 13, hour = 23, min = 59, sec = 59})

local function is_expired()
    return os.time() > expire_time
end

local legal_title = "@ADITYA_ORG "
local legal_content = "@ADITYA_ORG public file channel @ADITYA_ORG \nThis file is free. If you bought it, you were scammed.\nV6 Features:\nESP: Box/Distance/Name/HP/Ignore bots\n165 FPS + iPad FOV (80-150)\nNo recoil/Crosshair swap/Camera shake removal\nAimbot/Fast switch/Hit effect\nMagic Bullet (Head 150/Body 50/Built-in headshot)\nMaster toggle: Enable in game lobby, auto disable on return to lobby\nSettings: @ADITYA_ORG MOD PAK"
local legal_btnOK = "Confirm"
local legal_btnCancel = "Join Channel"
local legal_url = "https://t.me/ADITYA_ORG"

local function TryShowLegalCredit()
    if _G.V then return end
    pcall(function()
        local msg = require("client.slua.logic.common.logic_common_legal_msg")
        if not msg then return end
        msg.ShowOnePopUI({
            tabType = 0,
            title = legal_title,
            content = legal_content,
            tipsText = nil,
            btnOKText = legal_btnOK,
            btnCancleText = legal_btnCancel,
            acceptFunc = function() end,
            refuseFunc = function()
                local KismetSystemLibrary = import("KismetSystemLibrary")
                if KismetSystemLibrary then
                    KismetSystemLibrary:LaunchURL(legal_url)
                end
            end
        })
        _G.V = true
    end)
end

_G.TryShowLegalCredit = TryShowLegalCredit
pcall(TryShowLegalCredit)

local function ABC(msg)
    pcall(function()
        local success, loc_util = pcall(require, "common.loc_util")
        if success and loc_util and loc_util.ShowNotice then
            loc_util.ShowNotice("Notification: " .. tostring(msg))
        end
        local success2, InGameTipsTools = pcall(require, "GameLua.Mod.BaseMod.Common.UI.InGameTipsTools")
        if success2 and InGameTipsTools and InGameTipsTools.BattleNormalTips then
            InGameTipsTools.BattleNormalTips("Notification: " .. tostring(msg), 2, 3)
        end
    end)
end
_G.ABC = ABC

if is_expired() then
    ABC("Load complete 1")
    return true
end

local BlockedPkgs = {
    on_crow_update_ntf = true,
    on_crow_update_ntf2 = true,
    on_crow_update_ntf3 = true,
    hisar = true,
    battle_client_sync_allstar_auth_check_result_req = true
}

local BlockedPrefixes = {
    "report_client_net_",
    "report_unrealnet_",
    "report_dh_calc_key"
}

local function ShouldBlockPkg(pkgName)
    if not pkgName then return false end
    if BlockedPkgs[pkgName] then return true end
    for _, prefix in ipairs(BlockedPrefixes) do
        if pkgName:sub(1, #prefix) == prefix then
            return true
        end
    end
    return false
end

if NetUtil and NetUtil.SendPkg then
    local orig_SendPkg = NetUtil.SendPkg
    NetUtil.SendPkg = function(pkgName, ...)
        if ShouldBlockPkg(pkgName) then return end
        return orig_SendPkg(pkgName, ...)
    end
end

local function HookTss()
    if not _G.Tss then return end
    if Tss.SendEigeninfoData then
        Tss.SendEigeninfoData = function() return 0 end
    end
    if Tss.GetUserTag4Lua then
        Tss.GetUserTag4Lua = function() return "" end
    end
    if Tss.SaveSendEigeninfoCode then
        local orig_SaveSendEigeninfoCode = Tss.SaveSendEigeninfoCode
        Tss.SaveSendEigeninfoCode = function(code)
            return orig_SaveSendEigeninfoCode(0)
        end
    end
end

HookTss()

pcall(function()
    if LobbySystem and LobbySystem.SendEigeninfo then
        LobbySystem.SendEigeninfo = function(a, b)
            HookTss()
            if Tss and Tss.SaveSendEigeninfoCode then
                pcall(Tss.SaveSendEigeninfoCode, 0)
            end
        end
    end
end)

pcall(function()
    local Gokuba = require("GameLua.Mod.BaseMod.Client.Security.Gokuba")
    if Gokuba then
        Gokuba.ForwardFeature = function() return {0, 0, 0, 0, 0} end
    end
end)

pcall(function()
    local HiggsBosonComponent = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
    if HiggsBosonComponent then
        HiggsBosonComponent.SendAntiDataFlow = function() end
        HiggsBosonComponent.SendHitFireBtnFlow = function() end
        HiggsBosonComponent.SendHisarData = function() end
        HiggsBosonComponent.OnLogin = function() end
        HiggsBosonComponent.OnBattleResult = function() end
        if HiggsBosonComponent.ShowABCD then
            HiggsBosonComponent.ShowABCD = function() end
        end
        HiggsBosonComponent.SkipAlertServer()
    end
end)

pcall(function()
    local ClientToolsReport = require("client.slua.logic.report.ClientToolsReport")
    if ClientToolsReport and ClientToolsReport.SendReport then
        local orig_SendReport = ClientToolsReport.SendReport
        ClientToolsReport.SendReport = function(a, b, c, ...)
            if c and type(c) == "string" then
                local lower_c = string.lower(c)
                if lower_c:find("anticheat") or lower_c:find("cheat") or lower_c:find("security") or lower_c:find("eigen") or lower_c:find("tss") or lower_c:find("gokuba") then
                    return
                end
            end
            return orig_SendReport(a, b, c, ...)
        end
    end
end)

pcall(function()
    local gem_report_utils = require("client.logic.store.gem_report_utils")
    if gem_report_utils and gem_report_utils.ReportEventImmediate then
        local orig_ReportEventImmediate = gem_report_utils.ReportEventImmediate
        gem_report_utils.ReportEventImmediate = function(a, b, ...)
            local str_a = tostring(a or "")
            local str_b = tostring(b or "")
            if str_a:find("Gokuba") or str_a:find("gokuba") or str_b:find("Tss") or str_b:find("tss") or str_b:find("Eigen") or str_b:find("eigen") or str_a:find("Mini_Pak") then
                return
            end
            return orig_ReportEventImmediate(a, b, ...)
        end
    end
end)

pcall(function()
    local GameReportUtils = require("GameLua.Mod.BaseMod.GamePlay.GameReport.GameReportUtils")
    if GameReportUtils and GameReportUtils.ReportException then
        local orig_ReportException = GameReportUtils.ReportException
        GameReportUtils.ReportException = function(a, ...)
            if a and type(a) == "string" then
                local lower_a = string.lower(a)
                if lower_a:find("anticheat") or lower_a:find("cheat") or lower_a:find("security") or lower_a:find("strategy") then
                    return
                end
            end
            return orig_ReportException(a, ...)
        end
    end
end)

pcall(function()
    EventSystem:registEvent(EVENTTYPE_INGAME, EVENTID_INGAME_CONTROLLER_BEGINPLAY, function()
        pcall(function()
            local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
            if pc then
                pc.bShouldReportAntiCheat = false
            end
        end)
    end)
end)

pcall(function()
    local ClientGlueHiaSystem = require("GameLua.Mod.BaseMod.Client.Security.ClientGlueHiaSystem")
    if ClientGlueHiaSystem then
        ClientGlueHiaSystem.LuaFunc1 = function() return true end
        ClientGlueHiaSystem.LuaFunc4 = function() return false end
        ClientGlueHiaSystem.LuaFunc5 = function() return false end
        ClientGlueHiaSystem.LuaFunc6 = function() return false end
        ClientGlueHiaSystem.LuaFunc7 = function() return false end
        ClientGlueHiaSystem.LuaFunc8 = function() return false end
    end
end)

pcall(function()
    local logic_mini_pak_gem = require("client.slua.logic.download.report.logic_mini_pak_gem")
    if logic_mini_pak_gem then
        logic_mini_pak_gem.StartReport = function() end
        logic_mini_pak_gem.ReportGemLog = function() end
        logic_mini_pak_gem.SetCurDownloadSize = function() end
    end
end)

ABC("Load complete 1")
return true