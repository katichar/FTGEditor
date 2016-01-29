--
-- Author: rsma
-- Date: 2014-06-24 14:15:13
--

--设置缺省字体
if device.platform == "android" then
	-- cc.ui.DEFAULT_TTF_FONT      = "fonts/project.ttf"
 --    display.DEFAULT_TTF_FONT = "fonts/project.ttf"
else
    cc.ui.DEFAULT_TTF_FONT      = "FZDHTJW--GB1-0"
    display.DEFAULT_TTF_FONT = "FZDHTJW--GB1-0"
end

------------不引用其他类----开始---------------
--资源配置
require("app.configs.ResConstants")
--常量配置
require("app.configs.Constant")
--战斗配置
require("app.configs.FightConstants")
--游戏层 (在各scene创建时初始化)
g_LayerManager={}

--数据字典
g_Dict = require("app.configs.DataDictionary")
--任务信息
g_Task = require("app.configs.TaskInfo")
--关卡信息
g_GameLvl = require("app.configs.GameLevel")
--装备信息表
g_Equip = require("app.configs.EquipInfo")
--装备属性配置表
g_EquipAttr = require("app.configs.EquipAttribute")
--商城信息
g_Shop = require("app.configs.ShopInfo")
--技能信息
g_Skill = require("app.configs.SkillInfo")
--主角配置信息
g_RoleConfig = require("app.configs.RoleInfo")
--怪的配置信息
g_NPC = require("app.configs.NPCInfo")
-- 关卡掉落信息
g_Drop = require("app.configs.GameDrop")
--人物换扶配置
g_Skin = require("app.configs.SkinInfo")
-- 物品管理
g_Item = require("app.configs.ItemInfo")
-- 奖励配置
g_Reward = require("app.configs.RewardInfo")
--事件管理
g_EventManager = require("app.managers.EventManager")
--运营商的配置
g_Platform=require("app.managers.Platform")
--常用方法
g_CommonUtil=require("app.utils.CommonUtil")
--数值方法
g_DataUtil = require("app.utils.DataUtil")
--定时管理
g_Timer=require("app.managers.TimerManager")
--数据库
g_DB=require("app.managers.DatabaseManager")
-- 地图管理
g_Map = require("app.managers.MapManager")
-- 剧情对话
g_Plot = require("app.managers.PlotManager")
-- 特效管理
g_Effect = require("app.utils.EffectUtil")
-- 指引管理
g_Guide = require("app.managers.GuideManager")
-- 关卡通关条件管理
g_Condition = require("app.managers.ConditionManager")
-- 第三方SDK
g_SDK = require("app.utils.ThirdSDKUtil")
------------不引用其他类-----结束---------------
--
--
--玩家行为管理
g_UA = require("app.managers.UAManager")
--用户管理
g_User = require("app.managers.UserManager")
--游戏逻辑处理
g_LogicUtil=require("app.utils.LogicUtil")
--战斗逻辑管理
g_fight=require("app.fight.FightCore")
--人物对象管理
g_RoleManager = require("app.managers.RoleManager")
--Physics Engine
g_engine = require("app.managers.PhysicsEngineManager")
--消息处理
require("app.utils.MessageUtil")
--请求操作管理
g_Request = require("app.managers.RequestManager")
-- UI管理
g_UI = require("app.managers.UIManager")
-- 装备管理
g_Equipment = require("app.utils.EquipmentUtil")