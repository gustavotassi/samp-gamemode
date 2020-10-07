#define FILTERSCRIPT

#include <a_samp>
#include <a_sampdb>
#include <Pawn.CMD>
#include <sscanf2>

//======================================[ CORES ]====================================||
#define COLOR_BLUE                      (0x2641FEFF)
#define COLOR_GREY                      (0xBBBBBBFF)
#define COLOR_LIGHTRED                  (0xFF6347FF)
#define COLOR_LIGHTBLUE                 (0x33CCFFAA)
#define COLOR_COINSYSTEM                (0xD1BF3CFF)
#define COLOR_LIGHTGREEN                (0x66ff66FF)
#define COLOR_CLIENT                    (0xAAC4E5FF)
#define COLOR_TEAL                      (0x00A180FF)
#define COLOR_ORANGE                    (0xFF9409FF)
#define COLOR_PURPLE                    (0xD0AEEBFF)
#define COLOR_OPENSERV                  (0xFFBD9DFF)
#define COLOR_WHITE                     (0xFFFFFFFF)
#define COLOR_PINK                      (0xFF66FFAA)
#define COLOR_RED                       (0xFF0000AA)
#define COLOR_YELLOW                    (0xFFFF00AA)
#define COLOR_LIGHTYELLOW               (0xffff44FF)
#define COLOR_GREEN                     (0x33AA33AA)
#define COLOR_LIGHTBLUE2                (0x99ccffAA)
#define COLOR_BROWN                     (0xA8623EAA)
#define COLOR_LIGHTBROWN                (0xf4ac94AA)
#define COLOR_LIGHTBROWN2               (0xc7a6afAA)
#define COLOR_DIVINE                    (0xfffdc6FF)
#define COLOR_SAMP                      (0xA9C4E4AA)
#define COLOR_SAMPGREY                  (0xB9C9BFAA)
#define COLOR_FAVELA                    (0x41F4A0FF)
#define COLOR_MTABLUE                   (0x16ACE2FF)
#define COLOR_PMSEND                    (0xFFD500FF)
#define COLOR_INFO                      (0xFFE184FF)
#define COLOR_FADE1                     (0xFFFFFFFF)
#define COLOR_FADE2                     (0xC8C8C8C8)
#define COLOR_FADE3                     (0xAAAAAAAA)
#define COLOR_FADE4                     (0x8C8C8C8C)
#define COLOR_FADE5                     (0x6E6E6E6E)
#define COLOR_ROOTGREEN                 (0x2ECC71FF)
#define COLOR_WHITE                     (0xFFFFFFFF)
#define COLOR_ADMINPLAYER               (0x5598C1FF)
#define COLOR_EMOTE                     (0xD0AEEBFF)
#define BRANCO                          (0xFFFFFFFF)

//======================================[ MENSAGENS ]====================================||
#define MSG_PLAYER_OFF                  "Jogador inválido."

#define sendServerMessage(%0,%1) \
    SendClientMessage(%0, COLOR_TEAL, "[SERVER]:{FFFFFF} "%1)

#define sendSyntaxMessage(%0,%1) \
    SendClientMessage(%0, COLOR_GREY, "[USO CORRETO]: "%1)

#define sendErrorMessage(%0,%1) \
    SendClientMessage(%0, COLOR_LIGHTRED, "[ERRO]:{FFFFFF} "%1)

#define sendAdminMessage(%0,%1) \
    SendClientMessage(%0, COLOR_CLIENT, "[ADMIN]:{FFFFFF} "%1)

#define sendWarningMessage(%0,%1) \
    SendClientMessage(%0, COLOR_YELLOW, "[AVISO]:{FFFFFF} "%1)

#define sendInfoMessage(%0,%1) \
    SendClientMessage(%0, COLOR_INFO, "[INFO]:{FFFFFF} "%1)

#define sendFormatMessage(%0,%1,%2,%3) format(String, sizeof(String),%2,%3) && SendClientMessage(%0, %1, String)

#define sendFormatMessageToAll(%1,%2,%3) format(String, sizeof(String),%2,%3) && SendClientMessageToAll(%1, String)

#define function%0(%1) forward%0(%1);public%0(%1)

#define AFile ("Actor.db")

enum ActorInfo
{
	 ActorSkin,
	 Float: ActorX,
	 Float: ActorY,
	 Float: ActorZ,
	 Float: ActorA,
	 ActorVirtual,
	 ActorText[360],
	 ActorAd[32],
	 AActive,
	 Actor,
	 Text3D: ActorLabel
}

new	Ainfo[MAX_ACTORS][ActorInfo];

new gValue[128];
new DB:ADB;

new Actor_AI = 1;

public OnFilterScriptInit()
{
	if(!fexist(AFile))
	{
		fcreate(AFile);
	}
	ADB = db_open(AFile);
	LoadActor();
	return 1;
}

public OnFilterScriptExit()
{
    db_close(ADB);
	return 1;
}

CMD:criaractor(playerid, params[])
{
    if(GetLastID() > MAX_ACTORS) 
    	return sendErrorMessage(playerid, "O número máximo de actors já foi alcançado.");

	new Float:PPos[4], string[128], query[256],SkinID,ActorNamee[32],Text[250];

  	GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
  	GetPlayerFacingAngle(playerid,PPos[3]);

    if(sscanf(params,"s[32]s[250]i", ActorNamee, Text, SkinID)) 
    	return sendSyntaxMessage(playerid, "/criaractor [nome] [texto] [skinid]");

	format(query, sizeof(query), "INSERT INTO `ActorDB` (`ActorX`,`ActorY`,`ActorZ`, `ActorName`,`Text`, `ActorVirtual`, `ActorA`,`Skin`,`AActive`) VALUES('%f','%f','%f','%s','%s','%i','%f','%i','1');",PPos[0], PPos[1], PPos[2],ActorNamee,Text,GetPlayerVirtualWorld(playerid),PPos[3],SkinID);
	db_query(ADB,query);
	
	format(string,sizeof(string),"{0F96C7}Actor ID:{FFFFFF} %d\n{0F96C7}Actor Name:{FFFFFF} %s\n{0F96C7}Actor Text:{FFFFFF} %s\n{0F96C7}Actor Skin:{FFFFFF} %i",Actor_AI, ActorNamee,Text,SkinID);
	ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "{0F96C7}Actor criado", string, "Fechar", "");
 	
 	SetPlayerPos(playerid, PPos[0] + (1.5 * floatsin(-PPos[3], degrees)), PPos[1] + (1.5 * floatcos(-PPos[3], degrees)), PPos[2]);	
	K_B_CreateActor(ActorNamee,Actor_AI,Text,SkinID,PPos[0],PPos[1],PPos[2],PPos[3],GetPlayerVirtualWorld(playerid),1);
	Actor_AI++;
	return 1;
}
CMD:removeractor(playerid,params[])
{
    new ID;
    if(sscanf(params,"i",ID)) 
    	return sendSyntaxMessage(playerid, "/removeractor [actorid]");

	new query[250];
 	Ainfo[ID][AActive] = 0;

	format(query, sizeof(query), "UPDATE `ActorDB` SET `AActive` = '0' WHERE `ActorName` = '%s'",Ainfo[ID][ActorAd]);
	db_query(ADB,query);

	DestroyActor(Ainfo[ID][Actor]);
	Delete3DTextLabel(Ainfo[ID][ActorLabel]);
	SendClientMessage(playerid, COLOR_OPENSERV, "[ACTOR]:{FFFFFF} Actor deletado com sucesso.");
    return true;

}
CMD:editaractor(playerid,params[])
{
	new akid ,Text[256],SkinID,Float:PPos[4],ActorNamee[32],query[500];

	if(sscanf(params,"is[32]s[250]i,",akid,ActorNamee,Text,SkinID)) 
		return sendSyntaxMessage(playerid, "/editaractor [actorid] [novo nome] [novo texto] [nova skin]");

	if(Ainfo[akid][AActive] == 0) 
		return sendErrorMessage(playerid, "Este actor não existe.");

	GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
  	GetPlayerFacingAngle(playerid,PPos[3]);

	DestroyActor(Ainfo[akid][Actor]);
	Delete3DTextLabel(Ainfo[akid][ActorLabel]);
	new ad[32];
	//ad = Name
 	format(ad,32,"%s",Ainfo[akid][ActorAd]);

	format(query, sizeof(query), "UPDATE `ActorDB` SET `ActorName` = '%s' WHERE `ActorName` = '%s'",ActorNamee,ad);
	db_query(ADB,query);

	format(query, sizeof(query), "UPDATE `ActorDB` SET `ActorX` = '%f' WHERE `ActorName` = '%s'",PPos[0],ad);
	db_query(ADB,query);
	format(query, sizeof(query), "UPDATE `ActorDB` SET `ActorY` = '%f' WHERE `ActorName` = '%s'",PPos[1],ad);
	db_query(ADB,query);
	format(query, sizeof(query), "UPDATE `ActorDB` SET `ActorZ` = '%f' WHERE `ActorName` = '%s'",PPos[2],ad);
	db_query(ADB,query);
	format(query, sizeof(query), "UPDATE `ActorDB` SET `ActorA` = '%f' WHERE `ActorName` = '%s'",PPos[3],ad);
	db_query(ADB,query);
	format(query, sizeof(query), "UPDATE `ActorDB` SET `Skin` = '%i' WHERE `ActorName` = '%s'",SkinID,ad);
	db_query(ADB,query);
	format(query, sizeof(query), "UPDATE `ActorDB` SET `Text` = '%s' WHERE `ActorName` = '%s'",Text,ad);
	db_query(ADB,query);
	format(query, sizeof(query), "UPDATE `ActorDB` SET `ActorVirtual` = '%i' WHERE `ActorName` = '%s'",GetPlayerVirtualWorld(playerid),ad);
	db_query(ADB,query);

	SetPlayerPos(playerid, PPos[0] + (1.5 * floatsin(-PPos[3], degrees)), PPos[1] + (1.5 * floatcos(-PPos[3], degrees)), PPos[2]);
	K_B_CreateActor(ActorNamee,akid,Text,SkinID,PPos[0],PPos[1],PPos[2],PPos[3],GetPlayerVirtualWorld(playerid),1);
	return true;
}
	/// Stocklar

stock GetLastID()
{
    new DBResult:qresult, count = 0, Value[128];
	qresult = db_query(ADB, "SELECT * FROM `ActorDB` ORDER BY `ID` DESC LIMIT 1");
	count = db_num_rows(qresult);
	for(new a=0;a<count;a++)
	{
		if(count <= MAX_ACTORS)
		{
 			db_get_field_assoc(qresult, "ID", Value, 5);	gValue[a] = Value[a]+1;
			db_next_row(qresult);
		}
	}
	db_free_result(qresult);
	return 1;
}

stock fcreate(filename[])
{
    if (fexist(filename)){return false;}
    new File:fhandle = fopen(filename,io_write);
    fclose(fhandle);
    return true;
}

stock LoadActor()
{

	new query[356], DBResult:qresult, count = 0, value[128],string[356],Float:xim,Float:yim,Float:zim,Float:aim,gelenText[356],ActorName[32],
	Actorvirtualim,ActorSkin2,adurum3;
	if(!db_query(DB: ADB, "SELECT * FROM `ActorDB`"))
	{
		print("Tabela de actors não encontrada. O sistema irá criar uma nova.");
		format(query,sizeof(query),"CREATE TABLE IF NOT EXISTS `ActorDB` (`ID` INTEGER PRIMARY KEY AUTOINCREMENT,`ActorName` TEXT,`ActorVirtual`INTEGER ,`ActorX` TEXT,`ActorA` TEXT,`ActorY` TEXT,`ActorZ` TEXT,`Skin` INTEGER ,`AActive` INTEGER ,`Text` TEXT)");
	 	db_query(ADB,query);
        print("--------------------------------------\n");
		print("Tabela de actors criada. O servidor irá reiniciar para aplicar as mudanças.");
		print("--------------------------------------\n");
		SendRconCommand("exit");
	}
	else
	{
		qresult = db_query(ADB,  "SELECT * FROM `ActorDB`");
		count = db_num_rows(qresult);
		for(new a=0;a<count;a++)
		{
			if(count >= 1 && count <= MAX_ACTORS)
			{
				db_get_field_assoc(qresult, "ActorX", value, 20);	 	xim = floatstr(value);
				db_get_field_assoc(qresult, "ActorY", value, 20);	 	yim = floatstr(value);
				db_get_field_assoc(qresult, "ActorZ", value, 20); 	 	zim = floatstr(value);
				db_get_field_assoc(qresult, "ActorA", value, 20); 	 	aim = floatstr(value);
				db_get_field_assoc(qresult,	"Text",string,356);          format(gelenText,356,string);
				db_get_field_assoc(qresult, "ActorName",string,35);    format(ActorName,32,string);
				db_get_field_assoc(qresult, "ActorVirtual", value, 20);	Actorvirtualim = strval(value);
				db_get_field_assoc(qresult, "Skin", value, 20); 	 	ActorSkin2 = strval(value);
				db_get_field_assoc(qresult, "AActive", value, 20); 	 	adurum3 = strval(value);
				if(adurum3 == 1)
				{
				K_B_CreateActor(ActorName,Actor_AI,gelenText,ActorSkin2,xim,yim,zim,aim,Actorvirtualim,adurum3);
				Actor_AI++;
				}
				db_next_row(qresult);

			}
		}
		db_free_result(qresult);
	}



	return true;
}

stock K_B_CreateActor(ActorNeym[],ActorID,BilgiText[],Smodel,Float:Axxx,Float:Ayyy,Float:Azzz,Float:Aaaa,AWorld,adurum)
{
	if(adurum == 1)
	{
	new dongustr[256];
	format(dongustr,256,"%i", ActorID);
    Ainfo[ActorID][ActorLabel] = Create3DTextLabel(dongustr, 0xFFFFFFFF, Axxx, Ayyy, Azzz, 1.5, AWorld, 0);
    Ainfo[ActorID][Actor] = CreateActor(Smodel,Axxx,Ayyy,Azzz,Aaaa);
    SetActorVirtualWorld(Ainfo[ActorID][Actor], AWorld);

    Ainfo[ActorID][AActive] = 1;
	Ainfo[ActorID][ActorX] = Axxx;
	Ainfo[ActorID][ActorY] = Ayyy;
	Ainfo[ActorID][ActorZ] = Azzz;
	Ainfo[ActorID][ActorA] = Aaaa;
	Ainfo[ActorID][ActorVirtual] = AWorld;
	Ainfo[ActorID][ActorSkin] = Smodel;
	format(Ainfo[ActorID][ActorAd],32,ActorNeym);
	format(Ainfo[ActorID][ActorText],256,BilgiText);
	}

	return true;
}