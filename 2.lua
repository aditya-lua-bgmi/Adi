if _G.GOKU_FINAL_LOADED then return end
_G.GOKU_FINAL_LOADED = true

pcall(function()
    local Msg = package.loaded["client.slua.logic.common.logic_common_msg_box"]
    if not Msg then Msg = require("client.slua.logic.common.logic_common_msg_box") end
    local Web = require("client.slua.logic.url.logic_webview_sdk")
    local function onClick()
        if Web then Web:OpenURL("https://t.me/ZEROX6T") end
    end
    if Msg and Msg.Show then
        Msg.Show(4, "ZEROX6T",
            "┌─────────────────────────┐\n"..
            "│   ZEROX6T FRAMEWORK 4.4    │\n"..
            "└─────────────────────────┘\n\n"..
            "   ● Status   : Connected\n"..
            "   ● Bypass   : Fully Active\n"..
            "   ● Security : Maximized\n\n"..
            "   All monitoring neutralized.\n"..
            "   Play defensively, stay safe.\n\n"..
            "   Support : @ZEROX6T",
            onClick
        )
    end
end)

local noop = function() return true end
local retFalse = function() return false end
local retZero = function() return 0 end
local retEmpty = function() return {} end
local retTrue = function() return true end

local modulePatches = {
    ["GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent"] = {
        methods = {
            ControlMHActive = noop, Tick = noop, OnTick = noop, ReceiveTick = noop, MHActiveLogic = noop,
            TriggerAvatarCheck = noop, StartAvatarCheck = noop, ReportItemID = noop, OnReportItemID = noop,
            ReceiveAnyDamage = noop, OnWeaponHitRecord = noop, ShowSecurityAlert = noop, StaticShowSecurityAlertInDev = noop,
            SendHisarData = noop, OnLogin = noop, ValidateSecurityData = noop, CheckMemoryIntegrity = noop,
            ReportAbnormalMemory = noop, OnMemoryScanComplete = noop, SendDetectionResult = noop, TriggerClientScan = noop,
            SendAntiDataFlow = noop, SendHitFireBtnFlow = noop, SkipAlertServer = function() end,
            CheckWeaponIntegrity = retTrue, CheckAvatarIntegrity = retTrue, CheckBulletIntegrity = retTrue,
            OnGameModeType = noop,
        },
        fields = { bMHActive = false, mHActive = 0 },
        retvals = { GetNetAvatarItemIDs = retEmpty, GetCurWeaponSkinID = retZero, GetDetectionResult = retEmpty },
        custom = function(m)
            if m.__inner_impl then
                local i = m.__inner_impl
                i.SendAntiDataFlow = noop; i.SendHitFireBtnFlow = noop; i.OnBattleResult = noop; i.SendHisarData = noop
            end
            if m.BlackList then for k in pairs(m.BlackList) do m.BlackList[k] = nil end end
            if m.SkipAlertServer then pcall(m.SkipAlertServer, m) end
        end,
    },
    ["GameLua.Mod.BaseMod.Common.Security.SafetyDetectionSubsystem"] = {
        methods = { DetectAbnormal = noop, ReportAbnormal = noop, OnDetectionResult = noop, TriggerSafetyScan = noop },
        retvals = { GetScanResults = retEmpty, IsAnomalyDetected = retFalse },
    },
    _G_AvatarCheckCallback = {
        table = "_G.AvatarCheckCallback",
        methods = {
            StartAvatarCheck = noop, OnReportItemID = noop,
            PostPlayerControllerLoginInit = function(pc)
                pcall(function()
                    if pc and pc.HiggsBosonComponent then
                        pc.HiggsBosonComponent:ControlMHActive(0)
                        pc.HiggsBosonComponent.bMHActive = false
                    end
                end)
            end
        }
    },
    ["GameLua.Mod.BaseMod.Common.Security.PakIntegrityChecker"] = {
        methods = { ShowPakMismatchAlert = noop },
        retvals = { Verify = retFalse, CheckPakFile = retZero, GetPakStatus = retZero }
    },
    ["client.slua.logic.pak.logic_pak_verify"] = {
        retvals = { Verify = retFalse, CheckPakFile = retZero, GetPakStatus = retZero }
    },
    _G_STExtra = {
        table = "_G.STExtraBlueprintFunctionLibrary",
        retvals = { CheckFileIntegrity = retFalse, VerifySignature = retFalse, CheckGameLuaIntegrity = retFalse }
    },
    _G_TssSDK = {
        table = "_G.TssSDK",
        methods = {
            ReportData = noop, SendToServer = noop, SetUserInfo = noop,
            Init = noop, Start = noop, Verify = retTrue, CheckIntegrity = retTrue, Check = retTrue,
        },
        retvals = { GetSignature = function() return "BYPASSED" end }
    },
    _G_TssSDKHelper = { table = "_G.TssSDKHelper", methods = { ReportData = noop } },
    _G_Bugly = { table = "_G.Bugly", methods = { ReportException = noop, SetCustomData = noop } },
    _G_Beacon = { table = "_G.Beacon", methods = { Report = noop } },
    _G_CrashSight = { table = "_G.CrashSight", methods = { ReportException = noop, SetCustomData = noop, Log = noop } },
    ["GameLua.Mod.BaseMod.Common.Security.SecurityNotifyPCFeature"] = {
        methods = {
            ClientRPC_SyncBanID = noop, ClientRPC_StrongTips = noop, ClientRPC_NormalTips = noop, Notify = noop,
            ClientRPC_NotifyBan = noop, ClientRPC_NotifyPunish = noop, ClientRPC_NotifyIllegalProgram = noop
        },
        custom = function(m) if m.__inner_impl then m.__inner_impl.SyncBanInfo = noop end end,
    },
    ["client.slua.logic.ban.ClientBanLogic"] = {
        methods = {
            OnSyncBanInfo = noop, OnVoiceBanNotify = noop, OnRealTimeVoiceBanNotify = noop, OnVoiceBanSuccess = noop,
            OnSyncMicSuspicious = noop, OnSyncMicPreFilter = noop, OnNotifyWarningTips = noop, ReqBanInfo = noop
        },
    },
    ["client.slua.logic.ban.BanTipsLogic"] = {
        methods = { ShowBanTips = noop, ShowPunishTips = noop, ShowWarningTips = noop, OnReceiveBanNotice = noop }
    },
    _G_ban_util = { table = "_G.ban_util", retvals = { CheckBanStatus = retFalse, GetBanTime = retZero, IsBanForever = retFalse } },
    _G_logic_tt_ban = {
        table = "_G.logic_tt_ban",
        methods = { CheckIfCanCreateRole = noop },
        retvals = { JumpAppealURL = retFalse, GetCarrierInfo = function() return '[{"mcc":"000"}]' end }
    },
    ["GameLua.Mod.BaseMod.Client.Security.ClientHawkEyePatrolSubsystem"] = {
        methods = {
            _OnHawkSync = noop, _OnHawkReportSuccess = noop, _StartExitGameTimer = noop,
            _OnRecvInspectorBroadcastCount = noop, SendReportTLog = noop, ReportCheat = noop,
            _OnHawkFlag = noop, ReportPlayerFlag = noop, RequestFlagPlayer = noop, SendFlagReport = noop,
            RequestImprison = noop, IsDuringHawkEyePatrol = retFalse, HasReported = retTrue,
        },
        retvals = { CanInspectorBroadcast = retFalse },
        custom = function(mod)
            if mod.__inner_impl then
                local i = mod.__inner_impl
                i._OnHawkSync = noop; i._OnHawkReportSuccess = noop; i.TryShowReportedTips = noop
            end
        end,
    },
    ["GameLua.Mod.BaseMod.Client.Security.HawkEyeSpectate.ClientHawkEyePatrolSubsystem"] = {
        custom = function(mod)
            if mod.__inner_impl then
                local i = mod.__inner_impl
                i._OnHawkSync = noop; i._OnHawkReportSuccess = noop; i.TryShowReportedTips = noop
            end
        end,
    },
    ["GameLua.Mod.BaseMod.Common.Subsystem.DataLayerSubsystem"] = {
        custom = function(m)
            if m.OnSpectatorReplayChanged then
                local o = m.OnSpectatorReplayChanged
                m.OnSpectatorReplayChanged = function(...)
                    _G.IsBeingWatched = true
                    return o(...)
                end
            end
        end,
    },
    _G_ServerDataMgr = {
        table = "_G.ServerDataMgr",
        custom = function(m)
            if m.DeletablePlayerResultKey then
                for _, k in ipairs({
                    "SuspiciousHitCount", "EspTotalSimTraceCnt", "EspTotalImeFocusCnt",
                    "ClientGravityAnomalyCount", "FireCount", "SpeedCheatCount", "JumpCount", "VehicleSpeedHackCount",
                    "HeadshotCount", "KillCount", "Accuracy", "FlagCount", "TotalFlags", "IsFlagged",
                    "FlaggedByHawkEye", "FlaggedByInspection", "FlagTimestamp", "FlagLevel", "FlagSeverity",
                }) do m.DeletablePlayerResultKey[k] = true end
            end
            if m.FlagCount then m.FlagCount = 0 end
            if m.TotalFlags then m.TotalFlags = 0 end
            if m.IsFlagged then m.IsFlagged = false end
            if m.FlaggedByHawkEye then m.FlaggedByHawkEye = false end
            if m.FlaggedByInspection then m.FlaggedByInspection = false end
            if m.FlagTimestamp then m.FlagTimestamp = 0 end
            if m.FlagLevel then m.FlagLevel = 0 end
            if m.FlagSeverity then m.FlagSeverity = 0 end
        end
    },
    ["client.slua.logic.report.ToolReportUtil"] = {
        retvals = { IsReleaseVersion = retFalse, IsWhite = retFalse, GetReportSwitch = retFalse }
    },
    _G_ClientToolsReport = { table = "_G.ClientToolsReport", methods = { SendReport = noop, SendException = noop } },
    _G_ReportPlatformCrashKit = { table = "_G.ReportPlatformCrashKit", methods = { Send = noop, ForceSend = noop } },
    ["GameLua.Mod.BaseMod.Client.Security.ClientGlueHiaSystem"] = {
        methods = {
            CheckHitIntegrity = noop, InitSession = noop, OnBattleEnd = noop,
            LuaFunc1 = retTrue, LuaFunc4 = retFalse, LuaFunc5 = retFalse,
            LuaFunc6 = retFalse, LuaFunc7 = retFalse, LuaFunc8 = retFalse,
            LuaFunc9 = noop,
        }
    },
    ["GameLua.Mod.Escape.Gameplay.Subsystem.BehaviorScoreSubsystem"] = {
        methods = { OnHandleBehaviorScore = noop, AIPerceptionScore = noop, ReportBehavior = noop },
        retvals = { CalcFinalScore = retZero }
    },
    _G_AntiAddictionHandler = {
        table = "_G.AntiaddctionHandler",
        methods = { send_anti_addiction_req = noop, send_anti_addiction_notify = noop, on_check_nonage_anti_work = noop }
    },
    _G_AccessRestrictionHandler = {
        table = "_G.AccessRestrictionHandler",
        methods = { send_access_restriction_req = noop, send_access_restriction_notify = noop, on_player_cheat_state_notify = noop }
    },
    _G_GodzillaBanHandler = {
        table = "_G.GodzillaBanHandler",
        methods = { send_godzilla_ban_req = noop, send_godzilla_unban_req = noop }
    },
    _G_logic_deleteaccount = {
        table = "_G.logic_deleteaccount",
        retvals = { ForceDeleteAccount = retFalse },
        methods = { OnReceiveDeleteNotify = noop }
    },
    _G_compliance_util = { table = "_G.compliance_util", methods = { CheckCompliance = noop } },
    ["GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem"] = {
        methods = {
            OnInit = noop, _OnPlayerKilledOtherPlayer = noop, _RecordFatalDamager = noop,
            _OnDeathReplayDataWhenFatalDamaged = noop, _RecordMurdererFromDeathReplayData = noop,
            _RecordTeammatePlayerInfo = noop, _OnBattleResult = noop, _OnShowQuickReportMutualExclusiveUI = noop,
            GetFatalDamagerMap = retEmpty, GetCachedTeammateName2InfoMap = retEmpty,
            GetTeammateName2InfoMapDuringBattle = retEmpty, GetCurrentNotInTeamHistoricalTeammateMap = retEmpty,
            GetInTeamIndexFromHistoricalTeammateInfo = function() return -1 end,
            ReportSuspiciousPlayer = noop, SubmitReport = noop, ProcessReport = noop,
        },
        custom = function(m)
            if m.__inner_impl then
                m.__inner_impl._OnSyncFatalDamage = noop
                m.__inner_impl._OnPlayerKilledOtherPlayer = noop
                m.__inner_impl._SyncBattleResult = noop
            end
        end,
    },
    ["GameLua.Mod.BaseMod.Common.Security.DSReportPlayerSubsystem"] = {
        methods = {
            OnInit = noop, _OnNearDeathOrRescued = noop, _OnCharacterDied = noop, _OnTeammateDamage = noop,
            _OnPlayerSettlementStart = noop, _AddKnockDownerToBattleResult = noop, _AddKillerToBattleResult = noop,
            _AddTeammateMurderToBattleResult = noop, _AddFatalDamagerMapToBattleResult = noop,
            _AddMLKillerUIDToBattleResult = noop, _SaveHistoricalTeammateInfo = noop, _RecordFatalDamager = noop,
            _RecordTeammateMurderer = noop,
            _AddEnemyMapToBattleResult = noop, _AddTeammateMapToBattleResult = noop, _SubmitAbnormalData = noop,
        },
    },
    ["GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils"] = {
        retvals = { GetBotType = retZero, IsCharacterDeliverAI = retFalse },
        methods = { RecordFatalDamager = noop, IsUsingHistoricalTeammateInfo = retFalse },
    },
    ["GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils"] = {
        methods = { ExtractPlayerBasicInfo = retEmpty, LogIf = retFalse },
        custom = function(m)
            if m.EStrategyTypeInReplay then
                m.EStrategyTypeInReplay.EspTotalSimTraceCnt = 0
                m.EStrategyTypeInReplay.EspTotalImeFocusCnt = 0
                m.EStrategyTypeInReplay.ClientGravityAnomalyCount = 0
                m.EStrategyTypeInReplay.FlyingErrorCnt = 0
            end
        end,
    },
    ["GameLua.Mod.BaseMod.Client.Security.ClientQuickReportMaliciousTeammate"] = {
        methods = { OnShowMutualExclusiveUI = noop, OnHideMutualExclusiveUI = noop,
            MaliciousTeammateReceiveWarningTips = noop, MaliciousTeammateVictimReceiveTips = noop },
    },
    _G_ClientTlogHandler = { table = "_G.ClientTlogHandler", methods = { send_report_lobby_common_tlog = noop } },
    _G_LoginAndWinTlogHandler = { table = "_G.LoginAndWinTlogHandler", methods = { on_cloud_game_event_notify = noop } },
    _G_tlog_report_utils = { table = "_G.tlog_report_utils", methods = { ReportTLogEvent = noop, ReportImmediate = noop } },
    _G_BasicDataTLogReport = {
        table = "_G.BasicDataTLogReport",
        methods = { OnSendBatchReqMsg = noop, OnImmediateReqMsg = noop, OnMergeReqMsg = noop, send_report_event_duration_log = noop, SendTlog = noop, ReportEvent = noop },
        retvals = { _GetParamData = retEmpty }
    },
    _G_BasicDataClientReport = {
        table = "_G.BasicDataClientReport",
        methods = { ReportImmediate = noop, ReportDelay = noop, OnSendBatchReqMsg = noop, OnImmediateReqMsg = noop, OnMergeReqMsg = noop },
        retvals = { _IsCanReport = retFalse }
    },
    _G_BasicDataReport = {
        table = "_G.BasicDataReport",
        methods = { ReportImmediate = noop, ReportDelay = noop, OnMergeReqMsg = noop, OnImmediateReqMsg = noop, OnSendBatchReqMsg = noop, _BatchReqMsg = noop }
    },
    _G_puffer_tlog = { table = "_G.puffer_tlog", methods = { report_download_tlog = noop } },
    ["GameLua.Mod.BaseMod.DS.Security.ICTLogSubsystem"] = { methods = { SendICExceptionTLog = noop } },
    ["GameLua.Mod.BaseMod.DS.Security.DSFightTLogSubsystem"] = {
        methods = { ReportFightData = noop, ReportPlayerWeapon = noop },
        retvals = { GetSimpleFightData = retEmpty }
    },
    ["GameLua.Mod.BaseMod.DS.Security.DSSecurityTLogSubsystem"] = {
        methods = { _OnReportServerJumpFlow = noop, _OnReportTeleportFlow = noop, _OnReportSpeedHackFlow = noop }
    },
    ["GameLua.Mod.BaseMod.DS.Security.DSCommonTLogSubsystem"] = { methods = { HandleKillTlog = noop } },
    _G_ClientErrorReportHandler = {
        table = "_G.ClientErrorReportHandler",
        methods = { send_client_error_report = noop, send_client_crash_report = noop, send_client_tools_batch_report_req = noop }
    },
    _G_BattleReportHandler = {
        table = "_G.BattleReportHandler",
        methods = {
            send_battle_report = noop, send_battle_result = noop, send_vod_game_report_req = noop,
            send_batch_get_vod_info_req = noop, send_get_game_report_req = noop, send_batch_get_game_report_req = noop,
            send_get_game_report_by_uid_req = noop
        }
    },
    _G_BugHandler = { table = "_G.BugHandler", methods = { send_report_bug_info = noop, send_report_bug_feedback = noop } },
    _G_LobbyPingReportHandler = { table = "_G.LobbyPingReportHandler", methods = { send_lobby_ping_report = noop, send_ingame_ping_report = noop } },
    _G_WeekRportHandler = { table = "_G.WeekRportHandler", methods = { send_week_report = noop, send_week_detail = noop } },
    _G_logic_complaint = {
        table = "_G.logic_complaint",
        methods = { SendComplaintReq = noop, Submit = noop, ReportPlayer = noop, ShowComplaint = noop, ShowHandle = noop }
    },
    ["GameLua.Mod.BaseMod.Client.BattleResult.ProcessBase.EscapeBattleResultShowOBResultLogic"] = {
        methods = { OnBattleResult = noop, OnResultProcessStart = noop }
    },
    ["GameLua.Mod.BaseMod.Client.BattleResult.ProcessBase.BattleResultShowOBResultLogic"] = {
        methods = { OnBattleResult = noop, OnResultProcessStart = noop }
    },
    ["GameLua.Mod.BaseMod.Client.BattleResult.ProcessBase.BattleResultShowResultLogic"] = {
        methods = {
            OnBattleResult = noop, OnResultProcessStart = noop, OnResultProcessContinue = noop,
            ReceiveData = noop, SendEndFlow = noop, OnReport = noop, ShowResult = noop, ShowResultInternal = noop,
            StopResultProcess = noop
        }
    },
    _G_EmulatorHandler = { table = "_G.EmulatorHandler", methods = { send_emulator_info = noop } },
    _G_emulator_scanner = {
        table = "_G.emulator_scanner",
        methods = { StartScan = noop, ReportScanResult = noop },
        retvals = { GetScanResult = retFalse }
    },
    _G_LoginVerifyHandler = { table = "_G.LoginVerifyHandler", methods = { send_login_verify_req = noop, send_device_verify_req = noop } },
    _G_logic_ds_monitor = { table = "_G.logic_ds_monitor", methods = { OnRecordMsg = noop, OnReportMsg = noop } },
    ["GameLua.Mod.BaseMod.Client.Security.ClientDataStatistcsSubsystem"] = {
        methods = { StartToCheck = noop, OnReceiveRTT = noop, OnReceiveJitter = noop, ReportAbnormal = noop, ResetData = noop }
    },
    ["GameLua.Dev.Subsystem.ShootVerifySubSystemClient"] = { methods = { OnShootVerifyFailed = noop, SendVerifyData = noop } },
    ["GameLua.Mod.BaseMod.DS.Security.HighlightMomentSubsystem_DSChecker"] = { methods = { CheckFuncUpgradedWeaponKill = noop } },
    _G_logic_chat_voice_report = { table = "_G.logic_chat_voice_report", methods = { ReportVoiceData = noop, ReportVoiceText = noop } },
    _G_logic_chat_voice_doctor = { table = "_G.logic_chat_voice_doctor", methods = { UploadVoiceLog = noop, UploadVoiceException = noop } },
    _G_logic_home_audit_state = { table = "_G.logic_home_audit_state", methods = { SendAuditState = noop, ReportAuditResult = noop } },
    _G_logic_home_report = { table = "_G.logic_home_report", methods = { ReportHomeData = noop, ReportHomeVisitor = noop, ShowInGameReportUI = noop, SendReport = noop } },
    _G_gem_report_utils = {
        table = "_G.gem_report_utils",
        methods = { ReportGemData = noop, ReportGemPurchase = noop, ReportEventImmediate = noop }
    },
    _G_ChatHandler = { table = "_G.ChatHandler", methods = { send_report_info = noop, send_report_info_mic = noop } },
    _G_ClientReplayDataReporter = { table = "_G.ClientReplayDataReporter", methods = { ReportIntArrayData = noop, ReportFloatArrayData = noop, ReportUInt8ArrayData = noop } },
    ["GameLua.ExtraModule.MLAI.Client.AIReplaySubsystem"] = {
        custom = function(m)
            if m.uCompletePlayBack then
                m.uCompletePlayBack.AddRecordMLAIInfo = noop
                m.uCompletePlayBack.StopRecording = noop
            end
            if m.ReportAllPlayerInfo then m.ReportAllPlayerInfo = noop end
            if m.ReportFrameData then m.ReportFrameData = noop end
            if m.ReportPlayerInput then m.ReportPlayerInput = noop end
        end,
    },
    _G_GameSafeCallbacks = {
        table = "_G.GameSafeCallbacks",
        methods = {
            PostPlayerControllerLoginInit = noop, OnDSGlueHiaInit = noop, CharacterReceiveBeginPlay = noop,
            DoAttackFlowStrategy = noop, RecordStrategyTimestampInReplay = noop, EditorIncreaseTotalStatisticCnt = noop
        },
        retvals = { GetScriptReportContent = function() return "" end }
    },
    ["GameLua.Mod.BaseMod.GamePlay.GameReport.GameReportUtils"] = {
        methods = { ReportException = noop, ReplayReportData = noop, ReportGameException = noop },
        retvals = { BugglyPostExceptionFull = retFalse, CheckCanBugglyPostException = retFalse }
    },
    _G_NetUtil = { table = "_G.NetUtil", methods = { SendTss = noop, SendToServer = noop, SendToDS = noop } },
    ["UnrealNet"] = {
        global = true,
        custom = function(m)
            if not m then return end
            if m.FilterNetworkException then
                local o = m.FilterNetworkException
                m.FilterNetworkException = function(et, em)
                    if em and type(em) == "string" then
                        local le = em:lower()
                        if le:find("cheatdetected") or le:find("idipban") or le:find("dataerror") or le:find("datamismatch")
                           or le:find("security") or le:find("integrity") or le:find("hashfail") or le:find("flag") then
                            return false
                        end
                    end
                    return o(et, em)
                end
            end
            m.HandleNetworkExceptionReport = noop
            m.HandleNetworkConnectionClosed = noop
            m.HandleSpectateException = noop
        end
    },
    ["GameLua.Mod.BaseMod.Client.Security.Gokuba"] = {
        custom = function(m)
            if m.ForwardFeature then
                m.ForwardFeature = function() return {0, 0, 0, 0, 0} end
            end
            if m.TimerHandle then
                pcall(function()
                    local time_ticker = require("common.time_ticker")
                    time_ticker.RemoveTimer(m.TimerHandle)
                end)
                m.TimerHandle = nil
            end
        end
    },
    ["GameLua.Mod.BaseMod.Common.Security.CoronaUploader"] = { methods = { Upload = noop, Flush = noop } },
    ["GameLua.Mod.BaseMod.Client.Login.LoginLock"] = { methods = { Lock = noop, OnLoginBan = noop }, retvals = { CheckBan = retFalse } },
    ["GameLua.Mod.BaseMod.GamePlay.Battle.BattleResultUploader"] = { methods = { Upload = noop } },
    ["client.slua.logic.ClientAppStat"] = { methods = { Report = noop, Flush = noop } },
    ["GameLua.Mod.BaseMod.Client.Security.DeviceFingerprint"] = {
        methods = { Collect = noop, Sync = noop, GetHash = function() return "unknown" end }
    },
    ["GameLua.Mod.BaseMod.DS.Security.DSDeviceCheck"] = { methods = { VerifyClientDevice = retTrue, ReportMismatch = noop } },
    ["GameLua.Mod.BaseMod.Common.Security.IntegrityCheck"] = { methods = { Run = noop, Verify = retTrue } },
    ["GameLua.Mod.BaseMod.Common.Security.APKIntegrity"] = { methods = { CheckSignature = retTrue, CheckInstallSource = retTrue } },
    ["GameLua.Mod.BaseMod.Common.Security.LibCheck"] = {
        methods = { Verify = retTrue, Check = retTrue, Scan = noop, Report = noop },
        retvals = { IsLibValid = retTrue, GetTamperedLibs = retEmpty }
    },
    _G_TDataMaster = {
        table = "_G.TDataMaster",
        methods = { Report = noop, ReportDeviceInfo = noop, SendHardwareHash = noop, CollectTelemetry = noop, SendData = noop, Sync = noop, Flush = noop },
        custom = function(m)
            if m then for k, v in pairs(m) do if type(v) == "function" then m[k] = noop end end end
        end,
    },
    _G_DeviceInfo = {
        table = "_G.DeviceInfo",
        methods = { GetDeviceID = function() return "unknown" end, GetIMEI = function() return "000000000000000" end, CollectSysInfo = noop }
    },
    ["client.slua.logic.platform.platform_db"] = { methods = { Scan = noop, CheckIntegrity = retFalse, ReportCorruption = noop } },
    ["xunyou_cache_scan"] = { methods = { StartScan = noop, GetResult = retEmpty } },
    _G_SecurityTlogQueue = { table = "_G.SecurityTlogQueue", methods = { Flush = noop, Add = noop } },
    _G_PufferDownloadReport = { table = "_G.PufferDownloadReport", methods = { ReportDownload = noop, ReportError = noop } },
    _G_ReplayRecordSecurity = { table = "_G.ReplayRecordSecurity", methods = { InjectMeta = noop, Validate = noop } },
    _G_GameServerHeartbeat = { table = "_G.GameServerHeartbeat", methods = { ReportMissedBeat = noop, CheckAlive = retTrue } },
    ["GameLua.Mod.BaseMod.Common.Security.AntiDebug"] = { methods = { Check = retFalse, Report = noop } },
    ["GameLua.Mod.BaseMod.Client.Security.SecureBootCheck"] = { methods = { VerifyBoot = retTrue } },
    ["GameLua.Mod.BaseMod.DS.Security.DSPlayerValidCheck"] = { methods = { Validate = retTrue, ReportSuspicious = noop } },
    ["client.slua.logic.common.logic_common_legal_msg"] = {
        custom = function(m)
            if m.ShowOnePopUI then
                local o = m.ShowOnePopUI
                m.ShowOnePopUI = function(self, params)
                    if params and params.title and params.title:find("SECURITY") then return end
                    return o(self, params)
                end
            end
        end,
    },
    ["GameLua.Mod.BaseMod.Client.Security.InspectionSystemReportClientLogicSubsystem"] = {
        methods = {
            AskForInspector = noop, ReportEnemy = noop, KickOutOneTeam = noop,
            OnReceiveInspectCmd = noop, ClientReportData = noop, SendReportToInspector = noop,
            SendKickOutOneTeam = noop, ClientNotifyInspectorImplementation = noop, RecvNotifyInspector = noop,
        },
    },
    ["GameLua.Mod.BaseMod.DS.Security.InspectionSystemReportDSLogicSubsystem"] = {
        methods = {
            ServerKickOutOneTeamByPlayerImplementation = noop, AddReportedCount = noop,
            AddInspectionRecord = noop, BanPlayerByInspection = noop,
            BroadCastToAllInspector = noop, ServerReportToInspectorImplementation = noop,
            InitPlayerInspectionInfo = noop,
        },
    },
    ["client.slua.logic.CustomerService.LogicSafeStation"] = {
        methods = { UploadVideoEvidence = noop, ReportPlayerBehavior = noop },
    },
    ["client.slua.logic.CustomerService.LogicCustomerService"] = {
        methods = { SendComplaint = noop, SendFeedback = noop },
    },
    ["GameLua.GameCore.Module.Vehicle.VehicleFeatures.TLog.AmphibiousBoatTLogFeature"] = {
        methods = { RecordMovement = noop, StartRecordMovement = noop },
    },
    ["client.logic.data.profile_report_cfg"] = { methods = { SendReport = noop } },
    ["GameLua.Mod.BaseMod.Client.ClientInGameCreditLogic"] = {
        methods = {
            _SendUserReaction2ExitTeamBeforeBoardingReturnLobbyNotice = noop,
            ShowReturnLobbyIfFirstExitTeamBeforeBoarding = retFalse,
            OnReceiveCreditScoreChange = noop,
            _IsFirstExitTeamBeforeBoardingReturnLobbyNoticeEnabled = retFalse,
            SetFirstExitTeamBeforeBoardingReturnLobbyNoticeEnabled = noop,
        },
    },
    ["GameLua.Mod.CreativeBase.Gameplay.Subsystem.CreativeDevDebugSubsystem"] = { methods = { IsDebugPanelEnalbedCli = noop } },
    ["GameLua.Mod.CreativeBase.Gameplay.Subsystem.CreativeModeDeathRecordSubsystem"] = { methods = { OnPlayerKilled = noop } },
    ["GameLua.Mod.BaseMod.DS.Security.AFKReportorSubsystem"] = {
        methods = {
            HandleEnterFighting = noop, InitializePlayerInputInfo = noop,
            AddOneAFKInfo = noop, SetPlayerAFKState = noop,
            ResetPlayerInputInfo = noop, PlayerHaveAction = noop, ReportAFK = noop,
        },
    },
    ["GameLua.Mod.TDM.Gameplay.Subsystem.TDMAFKReportorSubsystem"] = { methods = { SendAFKTips = noop, OnHandleLostConnection = noop } },
    ["GameLua.Mod.BaseMod.GamePlay.AI.AITrackingLogSubsystem"] = {
        methods = {
            RealLogoutTimer = noop, AddToLogQue = noop, DoPrint = noop,
            OnAIPawnDied = noop, OnAIPawnReceiveDamage = noop, OnAIPawnEnemyChange = noop,
        },
        fields = { LogQueue = {} },
    },
    ["client.slua.logic.data.data_mgr"] = { retvals = { GetWeaponSkinSoundVolumeInfoByGroup = retZero } },
    ["TApmHelper"] = { methods = { postEvent = noop } },
    ["GameLua.Mod.BaseMod.Common.Security.LuaIntegrityCheck"] = { methods = { Run = noop, Verify = retTrue, Check = retTrue } },
    ["GameLua.Mod.BaseMod.Client.Security.ClientDeviceCheckSubsystem"] = {
        methods = { StartCheck = noop, ReportResult = noop },
        retvals = { IsDeviceSafe = retTrue },
    },
    ["GameLua.Mod.BaseMod.Client.Security.SpectatorAndReplaySubsystem"] = { methods = { SendReport = noop } },
    ["client.slua.logic.login.logic_version_update"] = {
        methods = { CheckVersion = noop, CheckUpdate = noop, IsNeedUpdate = retFalse, GetVersion = function() return "4.4.0" end, ShowUpdateDialog = noop }
    },
    ["client.slua.logic.version.logic_update"] = { methods = { CheckUpdate = noop, ForceUpdate = noop, IsForceUpdate = retFalse } },
    ["client.slua.logic.ban.logic_ban"] = {
        methods = { GetBanEndTime = function() return 0 end, IsInBanTime = retFalse, CheckBanStatus = retFalse, GetBanReason = retEmpty, GetBanTime = retZero }
    },
    ["client.slua.logic.login.logic_login_ban"] = {
        methods = { CheckCanLogin = retTrue, GetBanInfo = function() return { end_time = 0 } end, IsBanned = retFalse, IsSecurityBan = retFalse }
    },
    ["GameLua.Mod.PlanBT.Gameplay.Subsystem.DSActiveSubsystem"] = { methods = { DelayKickOutPlayer = noop, ActiveKickNotify = noop } },
    ["GameLua.Mod.BaseMod.Client.Security.ClientFlagSubsystem"] = {
        methods = {
            EvaluateFlags = noop,
            GetFlagLevel = retZero,
            GetFlagBanDuration = retZero,
            IsFlagged = retFalse,
            ReportFlag = noop,
            SyncFlagStatus = noop,
            IncreaseFlagCount = noop,
            ResetFlags = noop,
        },
        retvals = { IsFlagged = retFalse },
        fields = { FlagCount = 0, FlagLevel = 0, FlagSeverity = 0 },
    },
    ["client.slua.logic.ban.logic_flag_ban"] = {
        methods = {
            GetFlagBanEndTime = function() return 0 end,
            IsFlagBanned = retFalse,
            GetFlagBanDuration = retZero,
            CheckFlagBan = retFalse,
        }
    },
    ["GameLua.Mod.BaseMod.DS.Security.DSAITLogSubsystem"] = {
        methods = { _UpdateTTKRecords = noop, _UpdateOperatingFrequency = noop }
    },
    ["GameLua.Mod.Borderland.Gameplay.Subsystem.TLogSubsystem"] = {
        methods = { OnInit = noop }
    },
    _G_TLogSubsystem = { table = "_G.TLogSubsystem", methods = { OnInit = noop } },
    ["client.slua.logic.download.report.logic_mini_pak_gem"] = {
        methods = { StartReport = noop, ReportGemLog = noop, SetCurDownloadSize = noop }
    },
    ["GameLua.Mod.BaseMod.Client.ClientTLog.ClientTLogManager"] = {
        methods = {
            OnReceiveBattleResults = noop,
            AddValTLog = noop,
            SetValTLog = noop,
            SendReportLobby = noop,
        },
        fields = { ClientTlogData = {} },
    },
    ["GameLua.Mod.SocialIsland.DS.Battle.RacingAntiCheatLogic"] = {
        methods = {
            StartDetectTimer = noop, StopDetectTimer = noop,
            DetectVehicleFloating = noop, HandleFloatingCheat = noop,
            HandleSpeedCheat = noop, HandlePlayerPassCheckBelt = noop,
        },
    },
    ["GameLua.Dev.ClientCloudGM"] = { methods = { HandleCloudGMCMDStr = noop } },
    ["GameLua.Mod.BaseMod.Client.Dev.ClientCloudGM"] = { methods = { HandleCloudGMCMDStr = noop } },
    ["GameLua.Mod.BaseMod.Common.RealTimeBan.RealTimeBan"] = {
        methods = {
            OnPlayerWithRealTimeBan = noop,
            ShowAlias = noop,
            HandleEnterGameModeFightingState = noop,
        },
    },
    ["GameLua.Mod.BaseMod.Client.Security.HawkEyeSpectate.HawkEyeDistanceUI"] = {
        methods = { _RefreshUI = noop, _IsShouldShow = retFalse }
    },
    ["GameLua.Mod.BaseMod.Client.Security.HawkEyeSpectate.HawkEyeNextPatrolWindow"] = {
        methods = { OnShow = noop }
    },
    ["GameLua.Mod.BaseMod.Client.Security.HawkEyeSpectate.HawkEyeReportWindow"] = {
        methods = { _OnClickSubmit = noop, _RefreshWindow = noop, RegistEvents = noop }
    },
    ["GameLua.Mod.BaseMod.Client.Security.SecurityClientUtils"] = {
        methods = {
            HasOtherTeammateOffline = retFalse,
            HasOtherHealthyOnlineTeammate = retFalse,
            IsMyHealthStatusHealthy = retTrue,
            IsMyHealthStatusAlive = retTrue,
            GetMyHealthStatus = function() return 1 end,
        }
    },
    ["GameLua.Mod.BaseMod.Client.Ban.ClientBanLogic"] = {
        methods = {
            OnVoiceBanNotify = noop, OnRealTimeVoiceBanNotify = noop,
            OnSyncBanInfo = noop, OnNotifyWarningTips = noop,
            VoiceBanEndTime = 0, bEnableVoiceReport = false,
        },
    },
    ["GameLua.Mod.BaseMod.Client.Security.ClientBanLogic"] = {
        methods = {
            OnVoiceBanNotify = noop, OnRealTimeVoiceBanNotify = noop,
            OnSyncBanInfo = noop, OnNotifyWarningTips = noop,
        },
    },
    ["ScreenshotMaker"] = {
        custom = function(m)
            if not m then return end
            m.MakePicture = function() return "" end
            m.ReMakePicture = function() return "" end
            m.HasCaptured = function() return true end
        end,
    },
    ["client.slua.logic.ugc.UGCNewTLogReport"] = {
        methods = { SendExposeReq = noop, SendInteractionReq = noop, TLogReport = noop }
    },
    ["client.slua.logic.ugc.logic_ugc_tlog"] = {
        methods = { SendModTLog = noop, ReportStay = noop }
    },
    ["GameLua.Mod.BaseMod.Client.ClientTLog.ClientTLogUtil"] = {
        methods = { ReportGeneralCountByBRPhase = noop, ReportCommonTLogDataByBRPhase = noop }
    },
    ["ReportCrashKitFeature"] = {
        custom = function(m) if m and m.ReportCharacterAttachedOnVehicleException then m.ReportCharacterAttachedOnVehicleException = noop end end,
    },
    ["GameLua.Mod.BaseMod.GamePlay.GameReport.GameReportSubsystemReporter"] = {
        custom = function(m)
            if m then
                m.ReportIntArrayData = noop
                m.ReportUInt8ArrayData = noop
                m.ReportFloatArrayData = noop
            end
        end,
    },
}

local globalSuppress = {
    functions = {
        "ReportTLogEvent","SendTlog","ReportHitFlow","ReportAvatarException","SendComplaintReq","SubmitReport","ReportSuspiciousPlayer",
        "OnSyncBanInfo","OnVoiceBanNotify","SendSecTLog","MarkSuspiciousPlayer","ReportPlayerBehaviorData","CheckCompliance","ReportIllegalProgram",
        "UploadVoiceLog","ReportClientAbnormal","TriggerMemoryScan","SubmitDetectionReport","is_root","is_rooted","detect_emulator","check_system",
        "SendTssSdkAntiDataToLobby","SendActivityTLog","SendDSErrorLogToLobby","SendDSHawkEyePatrolLogToLobby","_OnPlayerKilledOtherPlayer",
        "_RecordFatalDamager","_OnBattleResult","_OnCharacterDied","SendClientMemUsage","SendClientFPS","OnClientCrashReport","ReportMatchRoomData",
        "ShowSecurityAlert","StaticShowSecurityAlertInDev",
        "CheckGameVersion","IsNeedUpdate","ForceUpdate","ShowUpdateDialog",
        "ReportFlag","SendFlagInfo","AddFlagCount","IsAccountFlagged","GetFlagStatus","SendPlayerStatistics","ReportPlayerStats","SendSuspiciousData",
    },
    tables = { "GlobalPlayerCoronaData", "GlobalPlayerCheatTimes" },
}

-- Safe domain blacklist (anti-cheat only, no game services)
local BLACKLIST_HOSTS = {
    "tss.tencent","syzsdk","gcloud.qq","reportlog","tdos","logupload","feedback.wh","crash2",
    "privacy.qq","privacy.tencent","oth.eve","mdt.qq","act.tencentyun","analytics","report.qq",
    "anticheatexpert","crashsight","wetest","log.tav","sngd","tracer","intlsdk","igamecj",
    "igame.gcloudcs","bugly","beacon","helpshift","tdm","apm","safeguard","weiyun","qzone",
    "tencent-cloud","myapp","idqqimg","gtimg","qqmail","tcdn","cloudctrl","sdkostrace",
    "103.134.189.146","mbgame","csoversea","down.anticheatexpert.com",
    "asia.csoversea.mbgame.anticheatexpert.com","log.tav.qq","syzsdk.qq","logiservice.qcloud",
    "opensdk.tencent","exp.helpshift","loginsdkapi.zingplay",
    "flag","reportflag",
}
local BLACKLIST_PORTS = {
    "10334","11045","12221","13331","8011","8015","9001","20000","20001","20002","20003","20004",
    "20005","19700","1670","19900","14545","10213","8700","25177","10685","10336","10262","27000",
    "27040","27015","27030","10706","10095","12401","11008","10309","11075","10157","24798","10709",
    "6667","10087","31113","20371","10120","10664","13728","10769","10761","5061","5062","18081",
    "15692","9030","8080","8086","8088","80","443"
}
local FILE_KEYWORDS = { "tlog","crash","bugly","report","beacon","wetest","analytics","telemetry","trace","dump","exception","feedback","aps_log","mtp_detect","network_loss","client_error","ue4crash","tdm","gcloud" }

local function isBlacklisted(str)
    if type(str) ~= "string" then return false end
    local low = str:lower()
    for _, kw in ipairs(BLACKLIST_HOSTS) do if low:find(kw, 1, true) then return true end end
    for _, port in ipairs(BLACKLIST_PORTS) do if low:find(":"..port) or low:find("/"..port) then return true end end
    return false
end

pcall(function()
    if _G.HttpRequest then
        local orig = _G.HttpRequest
        _G.HttpRequest = function(url, ...)
            if isBlacklisted(url) then return nil end
            return orig(url, ...)
        end
    end
    if _G.FHttpModule and _G.FHttpModule.CreateRequest then
        local orig = _G.FHttpModule.CreateRequest
        _G.FHttpModule.CreateRequest = function(...)
            local url = select(1, ...)
            if isBlacklisted(url) then return nil end
            return orig(...)
        end
    end
    local netMods = {
        "client.slua.logic.network.logic_network","client.slua.logic.download.report.puffer_tlog",
        "client.slua.data.BasicData.BasicDataClientReport","GameLua.GameCore.Module.Network.NetworkManager",
        "client.network.Protocol.ClientTlogHandler","client.network.Protocol.BattleReportHandler",
        "client.network.Protocol.ClientErrorReportHandler"
    }
    for _, mp in ipairs(netMods) do
        local mod = package.loaded[mp]
        if mod then
            for k, v in pairs(mod) do
                if type(v) == "function" and (k:find("Http") or k:find("Request") or k:find("Send") or k:find("Upload") or k:find("Post") or k:find("Get") or k:find("Report")) then
                    local origf = v
                    mod[k] = function(...)
                        local args = {...}
                        for _, arg in ipairs(args) do
                            if type(arg) == "string" and isBlacklisted(arg) then return nil end
                        end
                        return pcall(origf, ...)
                    end
                end
            end
        end
    end
end)

local orig_io_open = io.open
io.open = function(path, mode)
    if type(path) == "string" then
        local lp = path:lower()
        for _, kw in ipairs(FILE_KEYWORDS) do
            if lp:find(kw) then
                if mode and (mode == "w" or mode == "a" or mode == "w+" or mode == "a+") then
                    return nil, "Blocked"
                end
            end
        end
        if lp:find("tdm") or lp:find("gcloud") or lp:find("beacon") then
            if mode and (mode == "w" or mode == "a" or mode == "w+") then return nil end
        end
    end
    return orig_io_open(path, mode)
end

if NetUtil and NetUtil.SendPkg then
    local BlockedPkgs = {
        on_crow_update_ntf = true,
        on_crow_update_ntf2 = true,
        on_crow_update_ntf3 = true,
        hisar = true,
        battle_client_sync_allstar_auth_check_result_req = true
    }
    local BlockedPrefixes = { "report_client_net_", "report_unrealnet_", "report_dh_calc_key" }
    local function ShouldBlockPkg(pkgName)
        if not pkgName then return false end
        if BlockedPkgs[pkgName] then return true end
        for _, prefix in ipairs(BlockedPrefixes) do
            if pkgName:sub(1, #prefix) == prefix then return true end
        end
        return false
    end
    local orig_SendPkg = NetUtil.SendPkg
    NetUtil.SendPkg = function(pkgName, ...)
        if ShouldBlockPkg(pkgName) then return end
        return orig_SendPkg(pkgName, ...)
    end
end

pcall(function()
    if NetUtil and NetUtil.SendPacket then
        local configTable4 = {
            ["ReportAttackFlow"]=1, ["ReportSecAttackFlow"]=1, ["ReportHurtFlow"]=1,
            ["ReportFireArms"]=1, ["ReportVerifyInfoFlow"]=1, ["ReportMrpcsFlow"]=1,
            ["ReportPlayerBehavior"]=1, ["ReportTeammatHurt"]=1, ["ReportTeammateKillConfirmFlow"]=1,
            ["ReportForbiddenPickupFlow"]=1, ["ReportPlayerMoveRoute"]=1, ["ReportPlayerPosition"]=1,
            ["ReportSecVehicleMoveFlow"]=1, ["ReportSecTgameMovingFlow"]=1, ["report_parachute_data"]=1,
            ["report_character_all_drag"]=1, ["report_parachute_all_drag"]=1, ["report_vehicle_move_drag"]=1,
            ["on_tss_sdk_anti_data"]=1, ["report_unrealnet_exception"]=1, ["ReportPlayerEquipmentInfo"]=1,
            ["ReportAimFlow"]=1, ["ReportHitFlow"]=1, ["log_shooting_miss"]=1, ["report_heavy_weapon_box_activation_flow"]=1,
            ["report_heavy_weapon_box_item_flow"]=1, ["ReportCircleFlow"]=1, ["report_ds_player_circle_flow"]=1,
            ["ReportJumpFlow"]=1, ["ReportGameStartFlow"]=1, ["ReportGameEndFlow"]=1, ["report_players_ping"]=1,
            ["report_player_ip"]=1, ["report_player_frame_ping_record"]=1, ["report_net_saturate"]=1,
            ["report_ds_netsaturate"]=1, ["report_ds_net_continuous_saturate"]=1, ["report_ds_netrate"]=1,
            ["report_unrealnet_clientstats"]=1, ["report_serverstat_avgtickdelta"]=1, ["report_all_players_address"]=1,
            ["report_ai_strategyinfo"]=1, ["ReportAIActionFlow"]=1, ["ReportGenerateMonsterFlow"]=1,
            ["report_ds_match_room_data"]=1, ["SendSpectatingLog"]=1, ["ReportIDCardProduceFlow"]=1,
            ["ReportIDCardPickUpFlow"]=1, ["ReportIDCardDestroyFlow"]=1, ["ReportRevivalFlow"]=1,
            ["ReportGameSetting"]=1, ["ReportGameSettingNew"]=1, ["ReportAntsVoiceTeamCreate"]=1,
            ["ReportAntsVoiceTeamQuit"]=1, ["report_common_info"]=1, ["report_common_battle_info"]=1,
            ["report_client_scan_result"]=1, ["tss_sdk_report"]=1, ["report_memory_exception"]=1,
            ["report_avatar_exception"]=1, ["report_ui_state"]=1, ["report_hit_reg_fail"]=1,
            ["report_character_state"]=1, ["report_vehicle_exception"]=1, ["report_camera_exception"]=1,
            ["ReportPlayerControllerStateChanged"]=1, ["ReportAvatarFlow"]=1,
            ["send_ugc_report_uni_mod_expose_req"]=1,
            ["send_ugc_report_uni_mod_interactive_req"]=1,
        }
        local orig_SendPacket = NetUtil.SendPacket
        NetUtil.SendPacket = function(packetName, ...)
            if configTable4[packetName] then return end
            return orig_SendPacket(packetName, ...)
        end
    end
end)

pcall(function()
    if _G.Tss then
        if _G.Tss.SendEigeninfoData then _G.Tss.SendEigeninfoData = function() return 0 end end
        if _G.Tss.GetUserTag4Lua then _G.Tss.GetUserTag4Lua = function() return "" end end
        if _G.Tss.SaveSendEigeninfoCode then
            local orig = _G.Tss.SaveSendEigeninfoCode
            _G.Tss.SaveSendEigeninfoCode = function(code) return orig(0) end
        end
    end
    if LobbySystem and LobbySystem.SendEigeninfo then
        local orig = LobbySystem.SendEigeninfo
        LobbySystem.SendEigeninfo = function(...)
            if _G.Tss and _G.Tss.SaveSendEigeninfoCode then pcall(_G.Tss.SaveSendEigeninfoCode, 0) end
            return orig(...)
        end
    end
end)

pcall(function()
    EventSystem:registEvent(EVENTTYPE_INGAME, EVENTID_INGAME_CONTROLLER_BEGINPLAY, function()
        pcall(function()
            local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
            if pc then pc.bShouldReportAntiCheat = false end
        end)
    end)
end)

pcall(function()
    local ScreenshotMaker = import("ScreenshotMaker")
    if ScreenshotMaker then
        ScreenshotMaker.MakePicture = function() return "" end
        ScreenshotMaker.ReMakePicture = function() return "" end
        ScreenshotMaker.HasCaptured = function() return true end
    end
end)

local function bypass_higgs_per_player(player)
    if not player or not slua.isValid(player) then return end
    pcall(function()
        local Higgs = package.loaded["GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent"]
        if Higgs then
            Higgs.ControlMHActive = noop
            Higgs.TriggerAvatarCheck = noop
            Higgs.StartAvatarCheck = noop
            Higgs.ReportItemID = noop
            Higgs.OnReportItemID = noop
            Higgs.ReceiveAnyDamage = noop
            Higgs.OnWeaponHitRecord = noop
            Higgs.ShowSecurityAlert = noop
            Higgs.ServerReportAvatar = noop
            Higgs.ClientReportNetAvatar = noop
            Higgs.GetNetAvatarItemIDs = retEmpty
            Higgs.GetCurWeaponSkinID = retZero
        end
        if _G.AvatarCheckCallback then
            _G.AvatarCheckCallback.StartAvatarCheck = noop
            _G.AvatarCheckCallback.OnReportItemID = noop
        end
    end)
end

local function applyNetworkShield()
    local GC = _G.GameplayCallbacks or _G.GC
    if not GC then return end
    local orig = GC.OnDSPlayerStateChanged
    GC.OnDSPlayerStateChanged = function(UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
        local s = tostring(InPlayerState):lower()
        local r = tostring(ParamReason):lower()
        for _, k in ipairs({
            "cheatdetected","connectionlost","connectiontimeout","connectionexception","netdrivererror",
            "ban","kick","antihack","speedhack","aimbot","wallhack","modifiedfiles","violation",
            "brutal","brutalplay","brutal_play","abnormal","security","flag"
        }) do
            if s:find(k) or r:find(k) then return end
        end
        if orig then pcall(orig, UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason) end
    end
    local funcs = {
        "OnPlayerNetConnectionClosed","OnPlayerActorChannelError","OnPlayerRPCValidateFailed","OnPlayerSpectateException",
        "OnShutdownAfterError","KickPlayer","BanPlayer",
        "ReportAttackFlow","ReportSecAttackFlow","ReportHurtFlow","ReportFireArms","ReportVerifyInfoFlow","ReportMrpcsFlow",
        "ReportPlayerBehavior","ReportTeammatHurt","ReportMisKillByTeammate","ReportForbitPick",
        "ReportPlayerMoveRoute","ReportPlayerPosition","ReportVehicleMoveFlow","ReportSecTgameMovingFlow","ReportParachuteData",
        "SendTssSdkAntiDataToLobby","SendDSErrorLogToLobby","SendDSErrorLogToLobbyOnece","SendDSHawkEyePatrolLogToLobby",
        "ReportEquipmentFlow","ReportAimFlow","GetWeaponReport","GetOneWeaponReport",
        "ReportHeavyWeaponBoxSpawnFlow","ReportHeavyWeaponBoxActivationFlow","ReportHeavyWeaponBoxOpenPlayerFlow","ReportHeavyWeaponBoxItemFlow",
        "ReportPlayersPing","ReportPlayerIP","ReportPlayerFramePingRecord","OnDSConnectionSaturated","ReportDSNetSaturation",
        "ReportNetContinuousSaturate","ReportDSNetRate","SendClientStats","SendServerAvgTickDelta",
        "ReportCircleFlow","ReportDSCircleFlow","ReportJumpFlow","ReportAIStrategyInfo","SendAIDeliveryInfo",
        "ReportDailyTaskInfo","ReportMatchRoomData","SendPlayerSpectatingLog","ReportIDCardProduceFlow","ReportIDCardPickUpFlow",
        "ReportIDCardDestroyFlow","ReportRevivalFlow","ReportGameSetting","ReportGameSettingNew",
        "ReportAntsVoiceTeamCreate","ReportAntsVoiceTeamQuit","ReportCommonInfo","ReportLightweightStat",
        "SendSecTLog","SendDataMiningTLog","SendActivityTLog","GetGeneralTLogData",
        "HandleClientError","OnNetworkLossDetected",
        "SendPlayerStatistics","ReportPlayerStats","SendSuspiciousData",
        "SendCheatDetection","ReportCheat",
    }
    for _, f in ipairs(funcs) do if GC[f] then GC[f] = noop end end
    if GC.GetWeaponReport then GC.GetWeaponReport = retEmpty end
    if GC.GetOneWeaponReport then GC.GetOneWeaponReport = retEmpty end
end

local function deepHook(obj, depth)
    if depth > 4 then return end
    if type(obj) ~= "table" then return end
    for k, v in pairs(obj) do
        if type(k) == "string" then
            local lk = k:lower()
            if lk:find("crc") or lk:find("verify") or lk:find("integrity") or lk:find("hash") or lk:find("paksign") then
                if type(v) == "function" then
                    obj[k] = function(...)
                        if lk:find("crc") or lk:find("hash") then return 0 end
                        return true
                    end
                end
            end
        end
        if type(v) == "table" and v ~= obj then deepHook(v, depth + 1) end
    end
end

local function applyFullCRCFaker()
    if _G.__CRCFakerDone then return end
    pcall(function()
        if not slua_GameFrontendHUD then return end
        if _G.PufferDownloader then
            if _G.PufferDownloader.VerifyFileCRC then _G.PufferDownloader.VerifyFileCRC = retZero end
            if _G.PufferDownloader.CheckFileIntegrity then _G.PufferDownloader.CheckFileIntegrity = retTrue end
            if _G.PufferDownloader.VerifyFile then _G.PufferDownloader.VerifyFile = retTrue end
            if _G.PufferDownloader.CheckCRC then _G.PufferDownloader.CheckCRC = retZero end
        end
        if Client then
            if Client.VerifyPakFile then Client.VerifyPakFile = function(...) return true end end
            if Client.CheckFileCRC then Client.CheckFileCRC = function(...) return 0 end end
            if Client.GetFileHash then Client.GetFileHash = function(...) return "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" end end
            if Client.VerifySignature then Client.VerifySignature = retTrue end
            if Client.CheckGameLuaIntegrity then Client.CheckGameLuaIntegrity = retTrue end
            if Client.VerifyFileIntegrity then Client.VerifyFileIntegrity = retTrue end
            if Client.VerifyAllPaks then Client.VerifyAllPaks = retTrue end
        end
        if _G.USFSCacheSys then
            if _G.USFSCacheSys.VerifyIntegrity then _G.USFSCacheSys.VerifyIntegrity = retTrue end
            if _G.USFSCacheSys.VerifyFile then _G.USFSCacheSys.VerifyFile = retTrue end
        end
        if _G.ScriptHelperClient and _G.ScriptHelperClient.LoadFileToArrayByFullPath then
            local origLoad = _G.ScriptHelperClient.LoadFileToArrayByFullPath
            _G.ScriptHelperClient.LoadFileToArrayByFullPath = function(path)
                if path and type(path) == "string" and path:find("CommCRC.ini") then return nil end
                local result = origLoad(path)
                if path and path:find(".pak") then
                    if result and type(result) == "table" then
                        result.isValid = true
                        result.crcMatch = true
                    end
                end
                return result
            end
        end
        for _, mod in pairs(package.loaded) do
            if type(mod) == "table" then deepHook(mod, 0) end
        end
        _G.__CRCFakerDone = true
    end)
end

local function applyAdvancedPatches()
    pcall(function()
        local SubsystemMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubsystemMgr then
            local function patchSub(name, methods, retvals, fields)
                local inst = SubsystemMgr:Get(name)
                if inst then
                    if methods then for k, v in pairs(methods) do if type(inst[k]) == "function" then inst[k] = v end end end
                    if retvals then for k, v in pairs(retvals) do if type(inst[k]) == "function" then inst[k] = v end end end
                    if fields then for k, v in pairs(fields) do inst[k] = v end end
                end
            end
            patchSub("AFKReportorSubsystem", { PlayerHaveAction = noop, ReportAFK = noop })
            patchSub("ClientDataStatistcsSubsystem", { StartToCheck = noop, ReportPingDelayTimer = nil }, { ReportPingDelayTimer = nil }, { DelayCount = 0 })
            patchSub("AvatarExceptionSubsystem", { ReportException = noop, BindPlayerCharacter = noop, CheckAvatarValid = retTrue })
            patchSub("ShootVerifySubSystemClient", { ReportVerifyFail = noop, OnVerifyFailed = noop })
            patchSub("RescueBtnReplayTraceSubsystem", { ReportTrace = noop, StartTickMonitor = noop, TickMonitorCheck = noop, ReportTickMonitorHeartbeat = noop })
            patchSub("GameReportSubsystem", { ReplayReportData = retFalse, CheckCanBugglyPostException = retFalse, BugglyPostExceptionFull = retFalse, GetClientReplayDataReporter = function() return nil end })
            patchSub("FileCheckSubsystem", { StartCheck = noop, ReportAbnormalFile = noop })
            patchSub("ReplaySubsystem", { SendReport = noop, Upload = noop })
            patchSub("ClientFlagSubsystem", { EvaluateFlags = noop, GetFlagLevel = retZero, GetFlagBanDuration = retZero, IsFlagged = retFalse })
            patchSub("DSAITLogSubsystem", { _UpdateTTKRecords = noop, _UpdateOperatingFrequency = noop })
            patchSub("TLogSubsystem", { OnInit = noop })
            local gameReportSub = SubsystemMgr:Get("GameReportSubsystem")
            if gameReportSub and gameReportSub.Reporter then
                gameReportSub.Reporter.ReportIntArrayData = noop
                gameReportSub.Reporter.ReportUInt8ArrayData = noop
                gameReportSub.Reporter.ReportFloatArrayData = noop
            end
        end
    end)
    pcall(function()
        local CreativeMode = import("CreativeModeBlueprintLibrary")
        if CreativeMode then
            CreativeMode.MD5HashByteArray = function() return "BYPASSED_MD5_HASH" end
            CreativeMode.GetContentDiffData = function() return true, "BYPASSED" end
        end
    end)
    pcall(function()
        local AvatarExceptionPlayerInst = package.loaded["GameLua.Mod.Library.GamePlay.Avatar.Exception.AvatarExceptionPlayerInst"]
        if AvatarExceptionPlayerInst then
            AvatarExceptionPlayerInst.CheckAvatarException = noop
            AvatarExceptionPlayerInst.CheckAvatarExceptionOnce = noop
            AvatarExceptionPlayerInst.ReportAvatarException = noop
            AvatarExceptionPlayerInst.CheckSlotMeshVisible = retFalse
            AvatarExceptionPlayerInst.CheckPawnVisible = retFalse
            AvatarExceptionPlayerInst.CheckCanBugglyPostException = retFalse
        end
    end)
    pcall(function()
        local AvatarChecker = package.loaded["blacklist.slua.logic.lobby_gm.AvatarCheckerModule"]
        if AvatarChecker then AvatarChecker.CheckAvatar = retTrue; AvatarChecker.ReportException = noop end
    end)
    pcall(function()
        local MemoryWarning = package.loaded["client.slua.logic.memory_warning.logic_memory_warning"]
        if MemoryWarning then MemoryWarning.OnMemoryWarning = noop; MemoryWarning.ReportMemoryWarning = noop end
    end)
    pcall(function()
        local StoreInterface = package.loaded["client.slua.logic.store.logic_store_game_interface"]
        if StoreInterface then StoreInterface.IsStoreGameSupported = retTrue; StoreInterface.NotifyGetPGSLoginInfo = noop end
    end)
    pcall(function()
        local VoiceSubsystem = package.loaded["GameLua.Mod.BaseMod.Client.Voice.VoiceChatSubsystem"]
        if VoiceSubsystem then VoiceSubsystem.OnPlayerSubmitComplaint = noop end
    end)
    pcall(function()
        local TssSdk = package.loaded["TssSdk"] or _G.TssSdk
        if TssSdk then
            local orig = TssSdk.OnRecvData
            TssSdk.OnRecvData = function(data)
                if type(data) == "string" and (data:find("report") or data:find("exception")) then return end
                if orig then orig(data) end
            end
            TssSdk.SendReportInfo = noop
            TssSdk.ScanMemory = retTrue
            TssSdk.IsEmulator = retFalse
            TssSdk.GetTssSdkReportInfo = function() return "" end
        end
    end)
    pcall(function()
        local logicReplayReport = package.loaded["client.slua.logic.replay.logic_report_replay"]
        if logicReplayReport then logicReplayReport.ReportReplay = noop; logicReplayReport.SendReportReq = noop end
    end)
    pcall(function()
        local PufferTlog = package.loaded["client.slua.logic.download.report.puffer_tlog"]
        if PufferTlog then PufferTlog.ReportEvent = noop; PufferTlog.ReportDownloadResult = noop; PufferTlog.ReportODPAKError = noop end
    end)
    pcall(function()
        local AvatarUtils = package.loaded["AvatarUtils"]
        if AvatarUtils then AvatarUtils.CheckIsWeaponInBlackList = retFalse; AvatarUtils.IsValidAvatar = retTrue end
    end)
    pcall(function()
        local EquipmentExceptionReport = package.loaded["client.slua.logic.report.EquipmentExceptionReport"]
        if EquipmentExceptionReport then EquipmentExceptionReport.Report = noop end
    end)
    pcall(function()
        local TLog = _G.TLog or package.loaded["TLog"]
        if TLog then
            TLog.Info = noop; TLog.Warning = noop; TLog.Error = noop; TLog.Debug = noop; TLog.Report = noop
        end
    end)
    pcall(function()
        local pc = (slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController())
        if pc and pc.HiggsBosonComponent then
            pc.HiggsBosonComponent.bMHActive = false
            pc.HiggsBosonComponent:ControlMHActive(0)
        end
    end)
    pcall(function() _G.BlackList = {} end)
end

local function applyGlobalSuppress()
    for _, f in ipairs(globalSuppress.functions) do if type(_G[f]) == "function" then _G[f] = retFalse end end
    for _, t in ipairs(globalSuppress.tables) do
        if type(_G[t]) == "table" then
            local mt = getmetatable(_G[t]) or {}
            mt.__newindex = function() end
            setmetatable(_G[t], mt)
        end
    end
    if _G.GlobalPlayerCoronaData then
        _G.GlobalPlayerCoronaData.FlagCount = 0
        _G.GlobalPlayerCoronaData.IsFlagged = false
        _G.GlobalPlayerCoronaData.FlagTimestamp = 0
        _G.GlobalPlayerCoronaData.SuspiciousFlag = false
        _G.GlobalPlayerCoronaData.SuspiciousHitCount = 0
        _G.GlobalPlayerCoronaData.SuspiciousFireCount = 0
    end
end

local originalRequire = require
local function hookedRequire(name)
    local mod = originalRequire(name)
    if modulePatches[name] then
        local cfg = modulePatches[name]
        if cfg.custom then pcall(cfg.custom, mod)
        elseif not cfg.global then
            if cfg.methods then for k, v in pairs(cfg.methods) do if type(mod[k]) == "function" then mod[k] = v end end end
            if cfg.retvals then for k, v in pairs(cfg.retvals) do if type(mod[k]) == "function" then mod[k] = v end end end
            if cfg.fields then for k, v in pairs(cfg.fields) do if mod[k] ~= nil then mod[k] = v end end end
        end
    end
    return mod
end
if require ~= hookedRequire then require = hookedRequire end

local originalImport = import
local function hookedImport(name)
    local mod = originalImport(name)
    if modulePatches[name] then
        local cfg = modulePatches[name]
        if cfg.custom then pcall(cfg.custom, mod)
        elseif not cfg.global then
            if cfg.methods then for k, v in pairs(cfg.methods) do if type(mod[k]) == "function" then mod[k] = v end end end
            if cfg.retvals then for k, v in pairs(cfg.retvals) do if type(mod[k]) == "function" then mod[k] = v end end end
            if cfg.fields then for k, v in pairs(cfg.fields) do if mod[k] ~= nil then mod[k] = v end end end
        end
    end
    return mod
end
if import ~= hookedImport then import = hookedImport end

local function safeSelfHeal()
    pcall(function()
        local TM = require("GameLua.Mod.BaseMod.Common.TickManager")
        if TM and TM.AddLoopTimer then
            TM.AddLoopTimer(120, function()   -- increased to 120s for performance
                applyNetworkShield()
                pcall(function()
                    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
                    if pc and pc.HiggsBosonComponent then
                        pc.HiggsBosonComponent.bMHActive = false
                        pc.HiggsBosonComponent:ControlMHActive(0)
                    end
                    if slua.isValid(pc) then
                        local pawn = pc:GetCurPawn()
                        if slua.isValid(pawn) then bypass_higgs_per_player(pawn) end
                    end
                end)
                for k, v in pairs(_G) do
                    if type(v) == "function" and k:find("Report") and not (k == "ReportTLogEvent" or k == "SendTlog" or k == "ReportHitFlow") then
                        _G[k] = noop
                    end
                    if type(v) == "function" and k:lower():find("flag") then
                        _G[k] = function(...) return false end
                    end
                end
                for name, mod in pairs(package.loaded) do
                    if type(mod) == "table" then
                        for k, v in pairs(mod) do
                            if type(v) == "function" and type(k) == "string" then
                                local lk = k:lower()
                                if (lk:find("ban") and lk:find("time")) or (lk:find("ban") and lk:find("end")) then
                                    mod[k] = function(...) return 0 end
                                elseif lk:find("isban") or lk:find("is_banned") or lk:find("checkban") or lk:find("banforever") then
                                    mod[k] = retFalse
                                elseif lk:find("checkcanlogin") or lk:find("canlogin") then
                                    mod[k] = retTrue
                                elseif lk:find("ban") and (lk:find("check") or lk:find("status")) then
                                    mod[k] = retFalse
                                elseif lk:find("flag") then
                                    if lk:find("count") or lk:find("total") or lk:find("level") or lk:find("severity") or lk:find("duration") or lk:find("time") or lk:find("end") or lk:find("length") then
                                        mod[k] = function(...) return 0 end
                                    else
                                        mod[k] = function(...) return false end
                                    end
                                end
                            end
                        end
                    end
                end
                for _, mod in pairs(package.loaded) do
                    if type(mod) == "table" then
                        for k, v in pairs(mod) do
                            if type(k) == "string" then
                                local lk = k:lower()
                                if lk:find("suspicious") or lk:find("flag") then
                                    if type(v) == "number" then mod[k] = 0
                                    elseif type(v) == "boolean" then mod[k] = false
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

local function scheduleAdvancedPatches()
    pcall(function()
        local TM = require("GameLua.Mod.BaseMod.Common.TickManager")
        if TM and TM.AddTimerOnce then
            TM.AddTimerOnce(1.0, applyAdvancedPatches)
        else
            applyAdvancedPatches()
        end
    end)
end

local function init()
    applyNetworkShield()
    applyGlobalSuppress()
    applyFullCRCFaker()
    safeSelfHeal()
    scheduleAdvancedPatches()
    pcall(function()
        local GameplayData = require("GameLua.GameCore.Data.GameplayData")
        if GameplayData and GameplayData.GetGameInstance then
            local gi = GameplayData.GetGameInstance()
            if gi then gi:ExecuteCMD("pak.EnablePakVerification", "0") end
        end
    end)
    local PC = rawget(_G, "PacketCallbacks")
    if PC then
        for _, v in ipairs({
            "player_report_cheat","upload_loots_rsp","watch_player_exit","player_login_report",
            "player_logout_report","server_time_report","on_player_cheat_state_notify",
            "report_abnormal_behaviour","send_detection_data"
        }) do
            if PC[v] then PC[v] = noop end
        end
    end
end

pcall(init)

pcall(function()
    _G.global_patch_tss = ""
    if _G.TssSDK then
        _G.TssSDK.Init = noop
        _G.TssSDK.Start = noop
        _G.TssSDK.Verify = retTrue
        _G.TssSDK.CheckIntegrity = retTrue
        _G.TssSDK.Check = retTrue
    end
end)