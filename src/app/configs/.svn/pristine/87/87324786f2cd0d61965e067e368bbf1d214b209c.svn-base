
--对象类型
OBJ_TYPE={
    --罗飞
    LUOFEI=1,
    --剑云
    JIANYUN=2,
    --Darker
    DARKER=3,
    --普通怪
    NORMAL=10,
    --精英怪
    ELITE=11,
    --Boss
    BOSS=12,
    -- 道具
    ITEM=20,
}

--用户缺省财富
USER_DEFAULT={
    --每级奖励的属性点
    ATTR_LVL = 2,
    -- 初始各属性点
    ATTRHP = 1,
    ATTRMP = 1,
    --缺省防御指数
    ATTRDEF = {1,0.6,0.8},
    ATTRATK = 1,
    ATTRLUCK = 1,
    --缺省免伤
    AVOIDINJURY = 0.8,
    --最大开放等级
    MAX_LVL = 30,
    --正常用户
    STATUS_NORMAL = 0,
    -- 非法用户
    STATUS_ILLEGAL = 1,
    -- 法律阵营
    CAMP_LAW = 1,
    -- 正义阵营
    CAMP_DARKER = 2,
}

--场景类型
SCEEN_TYPE={
    --一般场景
    NORMAL=1,
    --物理引擎场景
    PHYSICS=2
}

--移动速度
MOVE_SPEED={
    --远景移动速度
    FAR_SPEED=370*GAME_FPS,
    --近景移动速度
    NEAR_SPEED=470*GAME_FPS
}

--身体大小
BODY_SIZE={
    WIDTH=80,
    HEIGHT=180,
}

--动作类型
ACTION_TYPE={
    --罗飞
    LUOFEI=1,
    --剑云
    JIANYUN=2,
    --Darker
    DARKER=3,
    --只有一种攻击类型
    GONGJIA=10,
    --彪哥的攻击类型
    GONGJI10304=12,
    --带有远程攻击类型
    GONGJI10206=13,
    --贾雄起（校长）
    GONGJI103010=14,
    --怪医生
    GONGJI10309=15,
    --假darker
    GONGJI103011=16,
    GONGJI10207=17,
    --luofei-NPC
    GONGJI10001=18,
    --jianyun-NPC
    GONGJI10002=19,
    --darker-NPC
    GONGJI10003=20,
    --食脑者（丧尸）
    GONGJI10205=21,
    --十三妹
    GONGJI102012=22,
    --梦瑶
    GONGJI103013=23,
    --蛮狱屠夫
    GONGJI102014=24,
}

--货币单位
CURRENCY={
    GOLD = 0,
    DIAMOND = 1,
    RMB = 2,
}

-- 装备类型
EQUIP_TYPE={
    QUANTAO=1,
    DAOJIAN=2,
    ZHUA=3
}

-- 装备部位
EQUIP_INDEX = {
    -- 武器
    WEAPONS = 1,
    -- 衣服
    BODY = 2,
    -- 头盔
    HEAD = 3,
    -- 腰带
    BELT = 4,
    -- 鞋子
    FOOT = 5,
    -- 饰品
    DECORATIONS = 6,
}

-- 装备品质
EQUIP_QUALITY={
    D=1,
    C=2,
    B=3,
    A=4,
    S=5,
}

-- 装备品质加成属性
EQUIP_QUALITY_EX = {
    [EQUIP_QUALITY.D] = 0,
    [EQUIP_QUALITY.C] = 0.1,
    [EQUIP_QUALITY.B] = 0.3,
    [EQUIP_QUALITY.A] = 0.6,
    [EQUIP_QUALITY.S] = 1,
}

--消息事件
MESSAGE_EVENT={
    MONEY_CHANGE="MONEY_CHANGE",
    EQUIP_CHANGE="EQUIP_CHANGE",
    ROLE_BAR_CHANGE = "ROLE_BAR_CHANGE",
    ROLE_EXP_CHANGE = "ROLE_EXP_CHANGE",
    ROLE_RESURRECTION = "ROLE_RESURRECTION",
    ROLE_ATTR_CHANGE = "ROLE_ATTR_CHANGE",
    BOSS_BAR_CHANGE = "BOSS_BAR_CHANGE",
    OBJECT_DEAD = "OBJECT_DEAD",
    GUIDE_BEGIN = "GUIDE_BEGIN",
    GUIDE_END = "GUIDE_END",
    ROLE_THROW_CLOTHES = "ROLE_THROW_CLOTHES",
    NETWORK_ERROR = "NETWORK_ERROR",
    LOADING_REMOVE = "LOADING_REMOVE",
    PAYMENT_EVENT_END = "PAYMENT_EVENT_END",
    PAYMENT_EVENT_SUCCESS = "PAYMENT_EVENT_SUCCESS",
    FIGHT_SCORE = "FIGHT_SCORE",
    FIGHT_STAR = "FIGHT_STAR",
    FIGHT_PHASE = "FIGHT_PHASE",
    FIGHT_TIME = "FIGHT_TIME",
    RANK_INFO = "RANK_INFO",
    --上传排行信息
    RANK_UP = "RANK_UP",
    MAIL_INFO = "MAIL_INFO",
    --创建订单成功ALipay
    ALIPAY_EVENT_CREATE_BILL = "ALIPAY_EVENT_CREATE_BILL",
    --创建订单成功YiBao
    YIBAO_EVENT_CREATE_BILL = "YIBAO_EVENT_CREATE_BILL",
    --创建订单成功WX
    WEIXIN_EVENT_CREATE_BILL = "WEIXIN_EVENT_CREATE_BILL",

    -- UI新提示
    UI_NEW_TIP = "UI_NEW_TIP",
    -- UI强化更换装备
    UI_CHANGE_EH = "UI_CHANGE_EH",
    -- 阵营贡献
    CAMP_RANK = "CAMP_RANK", 

    -- 剧情模式进度提醒
    GAME_PERCENT = "GAME_PERCENT",
    --摇杆控制
    CTRL_ROCKER = "CTRL_ROCKER",
    --游戏信息
    GAME_INFO = "GAME_INFO",
}

--战斗状态
FIGHT_STATUS = {
    WAITING = 0,
    RUNNING = 1,
    VICTORY = 2,
    FAILURE = 3,
}

-- 当前选择的大关卡 默认为1
CURR_CASE_INDEX = 1
-- 挑战塔
CURR_NORMAL_INDEX = 1
-- 通天塔
CURR_HARD_INDEX = 0

ROLE_EXINFO_TYPE = {
-- 指引
    GUIDE = 1,
-- 剧情动画
    MOVE = 2,
-- 评价
    EVALUATION = 3,
-- 阵营
    CAMP = 4,
-- 首冲奖励 @ID 1  是否首冲 @ID 2 是否领奖
    FIRST_PAY = 5,
-- 大礼包奖励 @ID 1-5 领取记录
    PAY_REWARD = 6,
    --新手礼包
    NEW_PLAYER = 7,
    -- 关卡印章
    GAMELVL = 8,
    -- 操作指引
    ACTION = 9,
    --音效
    SOUND = 10,
    --声音
    MUSIC = 11,
    --虚拟摇杆
    ROCKER = 12,
    --通天塔层数
    HARD_LAYER = 13,
    --当前周ID
    WEEKID = 14,
    --通天塔奖励flag
    HARD_REWARD = 15,
    --通天塔每周奖励装备信息
    HARD_REWARD_EQUIP = 16,
    --剧情开始记录
    PLOT1 = 17,
    --剧情结尾记录
    PLOT2 = 18,
}

-- 当前装备最大等级
CURR_EQUIPMENT_MAX_LVL = 30

-- 物品类型
ITEM_TYPE = {
    EQUIPMENT = 1,
    GOLD = 2,
    DIAMOND = 3,
    EXP = 4,
    FOOD = 5,
}

-- 关卡胜利条件
GAME_CONDITION = {
    -- 时间
    TIME = 1,
    -- 击杀BOSS 
    BOSS = 2,
    -- 击杀所有敌人
    ALL = 3,
}

-- 关卡积分计算公式
GAME_SCORE = {
    -- 关卡加成
    EXLVL = 100,
    -- 连击加成
    COMBO = 1,
    -- 受击
    ATTACK = -25,
    -- 复活
    RESET = -100,
    -- 时间
    TIME = -1,
}

-- 游戏模式
GAME_MODE = {
-- 剧情
    EASY = 1,
-- 挑战塔
    NORMAL = 2,
-- 通天塔
    HARD = 3,
-- PVP
    PVP = 4,
}

-- 活动列表
ACTIVITY_TYPE = {
    --登录
    LOGIN = 10000,
    --每天免费刷新buff次数定义
    TOWERBUFF = 10001,
}

-- 各个模式下的复活次数
RELIFE_COUNT = {
    [GAME_MODE.EASY]=3,
    [GAME_MODE.NORMAL]=3,
    [GAME_MODE.HARD]=0,
    [GAME_MODE.PVP]=3,
}

-- 特殊关卡挑战次数
MODE_COUNT = {
    [GAME_MODE.EASY]=10,
    [GAME_MODE.NORMAL]=10,
    [GAME_MODE.HARD]=5,
    [GAME_MODE.PVP]=5,
    --每天免费刷新buff次数
    [ACTIVITY_TYPE.TOWERBUFF]=1,
}

-- 当前模式
CURR_GAME_MODE = GAME_MODE.EASY

-- 怪物掉落几率
DROP_P = {
    [OBJ_TYPE.NORMAL] = 5,
    [OBJ_TYPE.ELITE] = 50,
    [OBJ_TYPE.BOSS] = 100,
    [OBJ_TYPE.ITEM] = 100,
}

-- 收支类型
INCOME_EXPENSE={
    --充值
    CHARGE = "CHARGE",
    --奖励
    ACTIVITY_REWARD = "ACTIVITY_REWARD",
    --复活
    REVIVE = "REVIVE",
    --钻石抽
    DIAMOND_LOTTERY = "DIAMOND_LOTTERY",
    --关卡奖励
    GAME_LVL_REWARD = "GAME_LVL_REWARD",
    --金币抽取
    GOLD_LOTTERY = "GOLD_LOTTERY",
    --邮件奖励
    EMAIL_REWARD = "EMAIL_REWARD",
    --技能解锁
    SKILL_UNLOCK = "SKILL_UNLOCK",
    --解锁人物
    ROLE_UNLOCK = "ROLE_UNLOCK",
    --强化
    EQUIP_EH = "EQUIP_EH",
    --更改昵称
    NAME_CHANGE = "NAME_CHANGE",
    --刷新BOSS
    BOSS_CHANGE = "BOSS_CHANGE",
    --通天塔额外次数
    MODE_HARD_GAME = "MODE_HARD_GAME",
    --通天塔奖励
    MODE_HARD_REWARD = "MODE_HARD_REWARD",
    --通天塔刷新BUFF
    MODE_HARD_CHANGEBUFF = "MODE_HARD_CHANGEBUFF",
}

--UI配置
UI_CODE={
    --剧情关卡
    GAME_LVL="GAME_LVL",
    --退出游戏
    EXIT_GAME="EXIT_GAME",
    --新手指引
    USER_GUIDE="USER_GUIDE",
    --首页
    INDEX="INDEX",
    --暂停
    PAUSE="PAUSE",
    --剧情
    PLOT="PLOT",
    --角色基本信息
    ROLE="ROLE",
    --技能
    SKILL="SKILL",
    --装备界面
    EQUIPMENT="EQUIPMENT",
    --属性
    ATTRIBUTE="ATTRIBUTE",
    --角色选择
    SELECT_ROLE="SELECT_ROLE",
    --评价
    EVALUATE="EVALUATE",
    --抽经验
    SHOP_EXP="SHOP_EXP",
    --金币购买
    SHOP_GOLD="SHOP_GOLD",
    --充值界面
    SHOP_DIAMOND="SHOP_DIAMOND",
    --系统界面
    SYSTEM="SYSTEM",
}

--快速出售品阶记录
QUICK_SELL_EQUIP = {
    [EQUIP_QUALITY.D] = true,
    [EQUIP_QUALITY.C] = false,
    [EQUIP_QUALITY.B] = false,
    [EQUIP_QUALITY.A] = false,
    [EQUIP_QUALITY.S] = false,
}
QUICK_SELL_INDEX = 1
QUICK_SELL_PAGE = 1

ROLE_LOCK_DIAMOND = {
    [OBJ_TYPE.LUOFEI] = 300,
    [OBJ_TYPE.JIANYUN] = 300,
    [OBJ_TYPE.DARKER] = 300,
}

EQUIP_COLORS = {
    [1]=cc.c3b(227, 227, 227),
    [2]=cc.c3b(0, 255, 7),
    [3]=cc.c3b(0, 141, 255),
    [4]=cc.c3b(219, 0, 255),
    [5]=cc.c3b(255, 134, 0),
}

--邮件状态
MAIL_STATUS={
    NEW = 1,
    --邮件同步
    SYNC = 2,
    --已读
    READED = 3,
    --提取附件
    GET = 4,
    --已删除
    DELETED = 5,
}

-- 音乐开关
-- 音效
EFFECT_SOUND = true
-- 音乐
EFFECT_MUSIC = true
-- 虚拟摇杆
EFFECT_ROCKER = true

-- 通天塔BUFF类型
BUFF_TYPE = {
    ATTACK = 1,
    HP = 2,
    DEF = 3,
    SPEED = 4,
    CD = 5,
    CONSUME = 6,
}

--  通天塔BUFF对象
BUFF_OBJECT = {
    PLAYER = 1,
    BOSS = 2,
}

BUFF_VALUE = {
    [BUFF_OBJECT.BOSS] = {10,15,20,-10},
    [BUFF_OBJECT.PLAYER] = {-10,-15,-20,10,15,20},
}

-- 通天塔刷新BOSS消耗
MODE_HARD_CHANGEBOSS = {
    currency = CURRENCY.DIAMOND,
    num = 10
}
-- 通天塔刷新BUFF消耗
MODE_HARD_CHANGEBUFF = {
    currency = CURRENCY.GOLD,
    num = 1000
}
-- 同天塔额外次数消耗
MODE_HARD_CHANCE = {
    currency = CURRENCY.DIAMOND,
    num = 20,
}
