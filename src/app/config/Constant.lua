--
-- Author: rsma
-- Date: 2015-12-08 15:59:47
--
--按钮基类
g_VPauseAction=""
g_BaseButton = require("app.ui.base.BaseButton")
--节点基类
g_BaseNode = require("app.ui.base.BaseNode")
--弹窗基类
g_BasePopUI = require("app.ui.base.BasePopUI")
--图片基类
g_BaseImage = require("app.ui.base.BaseImage")
--常量配置
require("app.configs.Constant")
g_Skin = require("app.configs.SkinInfo")
--战斗配置
require("app.configs.FightConstants")
require("app.config.ResConstant")
--事件管理
g_EventManager = require("app.managers.EventManager")
--定时管理
g_Timer=require("app.managers.TimerManager")
--Physics Engine
g_engine = require("app.managers.PhysicsEngineManager")

g_Items=require("app.config.RoleInfo")
g_XML=require("app.xml.xmlSimple")
g_Parser=require("app.xml.parser.SkeletonParser")

g_RoleMgr=require("app.utils.RoleManager")

--怪的配置信息
g_NPC = require("app.configs.NPCInfo")
--主角配置信息
g_RoleConfig = require("app.configs.RoleInfo")
--战斗逻辑管理
g_fight=require("app.fight.FightCore")
