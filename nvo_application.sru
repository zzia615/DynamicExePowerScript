$PBExportHeader$nvo_application.sru
forward
global type nvo_application from nonvisualobject
end type
end forward

global type nvo_application from nonvisualobject
end type
global nvo_application nvo_application

type variables
private:
string is_DbConfig_Qybz
public:
string is_config
boolean ib_DebugMode
end variables

forward prototypes
public function integer of_connectdb ()
public function string of_get_config (string config, string section, string key)
public subroutine of_disconnectdb ()
public subroutine of_systemerror ()
public subroutine of_execute (string commandline)
public function any of_split (string data, string split)
end prototypes

public function integer of_connectdb ();long li_FileNum
if not fileexists(is_config) then 
	li_FileNum = FileOpen(is_config)
	FileClose(li_FileNum)
end if 
is_DbConfig_Qybz = of_get_config(is_config,"DbConfig","Qybz")
if is_DbConfig_Qybz = "1" then 
	// Profile bjtzlhyy
	SQLCA.DBMS = of_get_config(is_config,"DbConfig","DBMS")
	SQLCA.Database = of_get_config(is_config,"DbConfig","Database")
	SQLCA.ServerName = of_get_config(is_config,"DbConfig","ServerName")
	SQLCA.LogId = of_get_config(is_config,"DbConfig","LogId")
	SQLCA.LogPass = of_get_config(is_config,"DbConfig","LogPass")
	SQLCA.AutoCommit = False
	SQLCA.DBParm = of_get_config(is_config,"DbConfig","DBParm")
	//连接数据库
	connect using sqlca;
	if sqlca.sqlcode<>0 then 
		Messagebox("提示","连接数据库失败~r~n"+sqlca.sqlerrtext)
		return -1
	end if 
end if 

return 1
end function

public function string of_get_config (string config, string section, string key);string ls_value
ls_value = profilestring(config,section,key,"")
if ls_value = '' or isnull(ls_value) then 
	setprofilestring(config,section,key,"")
end if 

return ls_value
end function

public subroutine of_disconnectdb ();if is_DbConfig_Qybz = "1" then 
	disconnect using sqlca;
end if 
end subroutine

public subroutine of_systemerror ();if is_DbConfig_Qybz = "1" then 
	rollback using sqlca;
end if 
end subroutine

public subroutine of_execute (string commandline);any a_ret
string ls_parms[]
ls_parms = of_split(commandline,"|")
//参数
//Library文件|用户对象|参数值
NonVisualObject object
try
	//加入Library
	AddToLibraryList(ls_parms[1])
	//如果不是调试模式，则动态实例化对象
	if not ib_DebugMode then 
		//实例化对象
		object = create using ls_parms[2]
		//执行代码
		object.dynamic of_exec(ls_parms[3])
	end if 
catch(Exception e)
	Messagebox("提示信息","执行失败~r~n"+e.Text)
finally
	if isvalid(object) then destroy object
end try
end subroutine

public function any of_split (string data, string split);long ll_pos
any a_ret
string ls_data
string temp[]
//拆分字符串
ls_data = data
ll_pos = pos(ls_data,split)
do while ll_pos>0
	temp[upperbound(temp)+1] = left(ls_data,ll_pos - 1)
	ls_data = right(ls_data,len(ls_data) - ll_pos)
	ll_pos = pos(ls_data,split)
loop

if ls_data>'' then 
	temp[upperbound(temp)+1] = ls_data
end if 

a_ret = temp
return a_ret


end function

on nvo_application.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_application.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;is_config = "config.ini"
//校验是否调试模式
if handle(GetApplication())=0 then 
	ib_DebugMode = true
end if 
end event

