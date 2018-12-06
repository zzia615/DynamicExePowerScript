$PBExportHeader$dynamicexescripts.sra
$PBExportComments$Generated Application Object
forward
global type dynamicexescripts from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
nvo_application gnv_app
end variables

global type dynamicexescripts from application
string appname = "dynamicexescripts"
end type
global dynamicexescripts dynamicexescripts

type prototypes

end prototypes

type variables
string is_DbConfig_Qybz

end variables

forward prototypes
public function string af_get_config (string config, string section, string key)
end prototypes

public function string af_get_config (string config, string section, string key);string ls_value
ls_value = profilestring(config,section,key,"")
if ls_value = '' or isnull(ls_value) then 
	setprofilestring(config,section,key,"")
end if 

return ls_value
end function

on dynamicexescripts.create
appname="dynamicexescripts"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on dynamicexescripts.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;gnv_app = create nvo_application
gnv_app.of_connectdb()
//µ÷ÊÔÄ£Ê½
if gnv_app.ib_DebugMode then 
	commandline = "testDynamic.pbl|test|asdf"
end if 
gnv_app.of_execute(commandline)


end event

event close;if isvalid(gnv_app) then 
	gnv_app.of_disconnectdb()
	destroy gnv_app
end if 
end event

event systemerror;gnv_app.of_systemerror()

end event

