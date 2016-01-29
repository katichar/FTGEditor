local sqlite3 = require("lsqlite3")

local database={}

-- 数据库路径
database.path=cc.FileUtils:getInstance():getWritablePath().."darker.hytc"

--打开数据库
function database.openDB()
	--数据库连接
	database.db=sqlite3.open(database.path)
end

-- 返回数据库连接
function database.getConnection()
	if not database.db then
		database.openDB()
	end
	return database.db
end

-- 关闭数据库连接
function database.closeConnection()
	if database.db then
		database.db:close()
		database.db=nil
	end
	return nil
end

-- 返回ErrorCode
function database.getErrorCode(i_CodeName)
	return sqlite3[i_CodeName]
end

local function createTable()
	--数据库版本
	database.db:exec('CREATE TABLE dbinfo(db REAL, game REAL)')
	database.db:exec("insert into dbinfo(db,game) values("..DB_VERSION..",".. GAME_VERSION ..")")
	--IOS收据表
	database.db:exec('CREATE TABLE iosreceipt(tid INTEGER PRIMARY KEY, receipt TEXT,status TEXT, `userid` TEXT,price INTEGER)')
	--Android收据表
	database.db:exec('CREATE TABLE androidreceipt(tradeno TEXT PRIMARY KEY, identifier TEXT,status TEXT, `userid` TEXT,price INTEGER)')
	--玩家信息表
	database.db:exec("CREATE TABLE `user_info` (`userid` TEXT,`sid`	TEXT,`money` INTEGER,`diamond` INTEGER,`lasttime` TEXT,'name' TEXT,'userflag' INTEGER);")
	--角色信息表
	database.db:exec("CREATE TABLE `role_info` (`roleid`	INTEGER PRIMARY KEY AUTOINCREMENT,`type`	INTEGER,`lvl`	INTEGER,`hp`	INTEGER,`atk`	INTEGER,`def`	INTEGER,`mp`	INTEGER,`luck`	INTEGER,`attr`	INTEGER,`exp`	INTEGER,`skillnum`	INTEGER,`userid`	TEXT);")
	--角色装备信息
	database.db:exec("CREATE TABLE `user_equip` (`userequipid` INTEGER PRIMARY KEY AUTOINCREMENT,`equipid` INTEGER,`quality` INTEGER,`roleid` INTEGER,`lvl`	INTEGER,`userid` TEXT,ehexp INTEGER DEFAULT 0);")
	--角色装备属性
	database.db:exec("CREATE TABLE `user_equip_attr` (`id`	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,`userequipid`	INTEGER,`attrid`	INTEGER,`attrvalue`	INTEGER);")
	--角色技能
	database.db:exec("CREATE TABLE `role_skill` (`roleid`	INTEGER,`skillid`	INTEGER,`lvl`	INTEGER,`sn`	INTEGER,PRIMARY KEY(roleid,skillid));")	
	--玩家关卡信息
	database.db:exec("CREATE TABLE `role_gamelvl` (`subglvlid` INTEGER,`roleid` INTEGER,`finishtime` TEXT,`star` INTEGER,`userid` TEXT,`num` INTEGER,`score` INTEGER,`lasttime`	TEXT,PRIMARY KEY(subglvlid,userid));")
	--玩家特殊模式的关卡信息
	database.db:exec("CREATE TABLE `role_modeinfo` (`modeid`	INTEGER,`modetype`	INTEGER,`lasttime`	TEXT,`record`	INTEGER,`combo`	INTEGER,`time`	TEXT,`userid`	TEXT,PRIMARY KEY(modeid,modetype));")
	--玩家任务信息
	database.db:exec("CREATE TABLE `role_task` (`taskid`	INTEGER,`roleid`	INTEGER,`finishtime`	TEXT,`star`	INTEGER,`userid`	TEXT,PRIMARY KEY(taskid,userid));")
	--玩家相关存储信息,指引 动画 等
	database.db:exec("CREATE TABLE `user_exinfo` (`type`	INTEGER,`exinfoid`	INTEGER,`exinfovalue`	TEXT, `userid`	TEXT,`lasttime`	TEXT,PRIMARY KEY(type,exinfoid,userid));")
	--玩家游戏各模式次数记录/活动领取次数等
	database.db:exec("CREATE TABLE `user_activity` (activityid INTEGER,`num` INTEGER,`lasttime` TEXT,`userid` TEXT,PRIMARY KEY(activityid,userid));")
	--玩家邮件表
	database.db:exec("CREATE TABLE `user_mail` (mailid TEXT,mfrom TEXT,mto TEXT,content TEXT,flag INTEGER,sync INTEGER,mailtime TEXT,`lasttime` TEXT,`userid` TEXT,PRIMARY KEY(mailid));")
	--邮件附件
	database.db:exec("CREATE TABLE `user_mailatts` (attid INTEGER PRIMARY KEY AUTOINCREMENT,mailid TEXT,type INTEGER,quality INTEGER,value INTEGER);")
end

--更新表
local function updateTable()
	local dbversion,gameversion
	for row in database.db:nrows("SELECT * FROM dbinfo") do
		dbversion=row.db
	end

	if (dbversion==1.0) then
		database.db:exec("ALTER TABLE iosreceipt ADD COLUMN price INTEGER DEFAULT 0")
		database.db:exec("ALTER TABLE role_gamelvl ADD COLUMN num INTEGE DEFAULT 1")
		database.db:exec("ALTER TABLE role_gamelvl ADD COLUMN score INTEGER DEFAULT 0")
		database.db:exec("ALTER TABLE role_gamelvl ADD COLUMN lasttime TEXT")
		database.db:exec("ALTER TABLE user_info ADD COLUMN name TEXT")
		database.db:exec("ALTER TABLE user_info ADD COLUMN userflag INTEGER")
		--装备强化经验
		database.db:exec("ALTER TABLE user_equip ADD COLUMN ehexp INTEGER DEFAULT 0")
		--玩家邮件表
		database.db:exec("CREATE TABLE `user_mail` (mailid TEXT,mfrom TEXT,mto TEXT,content TEXT,flag INTEGER,sync INTEGER,mailtime TEXT,`lasttime` TEXT,`userid` TEXT,PRIMARY KEY(mailid));")
		--邮件附件
		database.db:exec("CREATE TABLE `user_mailatts` (attid INTEGER PRIMARY KEY AUTOINCREMENT,mailid TEXT,type INTEGER,quality INTEGER,value INTEGER);")
		--扩展表增加字段
		database.db:exec("ALTER TABLE user_exinfo ADD COLUMN exinfovalue TEXT")
	elseif dbversion==1.01 then
		--装备强化经验
		database.db:exec("ALTER TABLE user_equip ADD COLUMN ehexp INTEGER DEFAULT 0")
		--扩展表增加字段
		database.db:exec("ALTER TABLE user_exinfo ADD COLUMN exinfovalue TEXT")
	elseif dbversion==1.02 then
		--扩展表增加字段
		database.db:exec("ALTER TABLE user_exinfo ADD COLUMN exinfovalue TEXT")
	end
	database.db:exec("update dbinfo set db="..DB_VERSION)
end

-- 初始化数据库
function database.checkInit()
	database.getConnection()
	local initflag=false
	-- 如果不存在则初始化
	if(io.exists(database.path)==false) then
		initflag=true
	else
		local result=0
		for row in database.db:nrows("select count(*) as 'num' from sqlite_master where type ='table'") do
			result=row.num
		end
		initflag=(result<=0)
	end
	--	如果没有表，新建
	if (initflag) then
		createTable()
	else
		updateTable()
	end
	database.closeConnection()
end

-- 删除数据库
function database.destroy()
	os.remove(database.path)
end

-- 初始化
database.checkInit()
return database
