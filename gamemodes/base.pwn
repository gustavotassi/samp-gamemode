//===========================================//
//** System: GameMode Base DOF2 v1.5         ( http://forum.sa-mp.com/showthread.php?p=3824052 )
//** Credits: Pedro Eduardo
//===========================================//

//======================================[ INCLUDE ]====================================||
#include    <a_samp>
#include    <DOF2>
#include    <Pawn.CMD>
#include    <sscanf2>
#include    <timerfix>
#include    <pvehicle>
#include    <streamer>
//======================================[ DEFINE  ]====================================||
#undef      MAX_PLAYERS
#define     MAX_PLAYERS     50

#define     SetPlayerCash(%0,%1) ResetPlayerMoney(%0) && GivePlayerMoney(%0,%1)

//======================================[ DIALOG  ]====================================||
#define     DIALOG_REGISTER         0
#define     DIALOG_LOGIN            1
//======================================[ Start ]======================================||

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

//======================================[ SETTINGS ]====================================||

#undef      MAX_PLAYERS
#define     MAX_PLAYERS     100

#define     Kick(%0) SetTimerEx("Kicka", 1000, false, "i", %0)

//======================================================================================||

main(){}

enum pInfo
{
    pSkin,
    pScore,
    pMoney,
    Float:pPosX,
    Float:pPosY,
    Float:pPosZ,
    Float:pPosA,
    pInterior,
    pVW,
    bool:pLogado
}

new
    Player[MAX_PLAYERS][pInfo], reset[pInfo],
    Conta[256]
;

new String[256];

new TimerSalvar[MAX_PLAYERS];

new Engine[MAX_PLAYERS];

new Text:TelinhaPreta;
new IsOnBlackScreen[MAX_PLAYERS];

//=====================================[ CALLBACKS ]====================================||
public OnGameModeInit()
{
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
    SetNameTagDrawDistance(100.0);
    SetGameModeText("Freeroam");
    DisableInteriorEnterExits();
    EnableStuntBonusForAll(false);
    ManualVehicleEngineAndLights();
    //UsePlayerPedAnims();

    TelinhaPreta = TextDrawCreate(-30.000000, -5.000000, "_");
    TextDrawBackgroundColor(TelinhaPreta, 255);
    TextDrawFont(TelinhaPreta, 1);
    TextDrawLetterSize(TelinhaPreta, 0.700000, 53.099998);
    TextDrawColor(TelinhaPreta, -1);
    TextDrawSetOutline(TelinhaPreta, 0);
    TextDrawSetProportional(TelinhaPreta, 1);
    TextDrawSetShadow(TelinhaPreta, 1);
    TextDrawUseBox(TelinhaPreta, 1);
    TextDrawBoxColor(TelinhaPreta, 255);
    TextDrawTextSize(TelinhaPreta, 650.000000, 30.000000);

    return  1;
}

public OnGameModeExit()
{
    for(new i = 0; i <= GetPlayerPoolSize(); ++i)
        SalvarConta(i);
    
    for(new i = 0; i <= GetPlayerPoolSize(); ++i)
        IsOnBlackScreen[i] = 0;

    DOF2_Exit();
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    IsPlayerLogged(playerid);
    return false;
}

public OnPlayerRequestSpawn(playerid) 
    return IsPlayerLogged(playerid);

IsPlayerLogged(playerid)
{
    if(Player[playerid][pLogado] == true)
    {
        SetSpawnInfo(playerid,-1,Player[playerid][pSkin],Player[playerid][pPosX],Player[playerid][pPosY],Player[playerid][pPosZ],Player[playerid][pPosA],0,0,0,0,0,0);
        SpawnPlayer(playerid);
        SetPlayerInterior(playerid, 0);
        SetCameraBehindPlayer(playerid);
    }
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    return 1;
}

public OnPlayerText(playerid, text[ ])
{
    if(Player[playerid][pLogado] == false) return sendErrorMessage(playerid, "Você não está logado."), false;

    if(strlen(text) > 64)
    {
        sendFormatMessageToAll(0xE6E6E6FF, "%s diz: %.64s", ReturnName(playerid, 0), text); 
        sendFormatMessageToAll(0xE6E6E6FF, "...%s", text[64]);
    }
    else sendFormatMessageToAll(0xE6E6E6FF, "%s diz: %s", ReturnName(playerid, 0), text);

    return 0;
}

public OnPlayerConnect(playerid)
{
    Player[playerid][pLogado]=false;

    //=================================[ LOGIN/REGISTRO ]===============================||

    format(Conta, sizeof(Conta), "Contas/%s.ini", Name(playerid));
    if(!DOF2_FileExists(Conta))
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registro", "Escreva uma senha para se registrar.", "Registrar", "Sair");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Escreva a senha abaixo para entrar em sua conta.", "Entrar", "Sair");
    }

    //==================================================================================||
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SalvarConta(playerid);

    //reset in variable's
    Player[playerid] = reset;

    new DisconnectReason[3][] =
    {
        "Conexão/Crash",
        "Desconectou-se (/q)",
        "Kick/Ban"
    };

    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

    sendFormatMessageToAll(COLOR_TEAL, "[SERVER]:{FFFFFF} O jogador %s saiu do servidor. (%s)", playerName, DisconnectReason[reason]);

    KillTimer(TimerSalvar[playerid]);

    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    //=================================[ DIALOG_REGISTER ]==============================||
    if(dialogid == DIALOG_REGISTER)
    {
        if(!response) return Kick(playerid);
        if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Register", "Senha muito pequena.\nEscreva uma senha maior para se registrar.", "Registrar", "Sair");
        if(response)
        {
            if(strlen(inputtext))
            {
                format(Conta, sizeof(Conta), "Contas/%s.ini", Name(playerid));
                DOF2_CreateFile(Conta);
                DOF2_SetString(Conta, "Password", inputtext);
                DOF2_SaveFile();

                CriarConta(playerid);
                CarregarConta(playerid);

                TimerSalvar[playerid] = SetTimerEx("SaveAcc", 1000, true, "i", playerid);
            }
            else ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registro", "Escreva uma senha para se registrar.", "Registrar", "Sair");
        }
        return 1;
    }
    //=================================[ DIALOGO   LOGIN ]==============================||
    if(dialogid == DIALOG_LOGIN)
    {
        if(!response) return Kick(playerid);
        if(response)
        {
            if(!strlen(inputtext))
            {
                return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Escreva a senha abaixo para entrar em sua conta.","Entrar", "Sair");
            }
            format(Conta, sizeof(Conta), "Contas/%s.ini", Name(playerid));
            if(strcmp(inputtext, DOF2_GetString(Conta, "Password"), true))
            {
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Senha incorreta.\nReescreva a senha abaixo para entrar em sua conta.","Entrar", "Sair");
            }
            else //se acertar a senha
            {
                CarregarConta(playerid);
                TimerSalvar[playerid] = SetTimerEx("SaveAcc", 1000, true, "i", playerid);
            }
        }
        return 1;
    }
    return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerColor(playerid, 0xFFFFFFFF);
    SetPlayerSkin(playerid, Player[playerid][pSkin]);
    SetPlayerCash(playerid,Player[playerid][pMoney]);
    TogglePlayerControllable(playerid,true);
    return 1;
}

//=============================[Comandos]==============================================||
/*
CMD:arma(playerid)
{
    ShowPlayerDialog(playerid, 8712, DIALOG_STYLE_TABLIST, "Buy Weapon", "Deagle\t$5000\t100\nSawnoff\t$5000\t100\nPistol\t$1000\t50", "Select", "Cancel");
    return 1;
}
*/
CMD:janelasf(playerid, params[])
{
    new janelas[256];

    if(sscanf(params, "s[256]", janelas)) 
        return sendSyntaxMessage(playerid, "/janelasf [fala]");

    if(strlen(params) > 64)
    {
        sendFormatMessageToAll(0xFFFFFFFF, "[Janelas Fechadas] %s diz: %.64s", ReturnName(playerid, 0), params); 
        sendFormatMessageToAll(0xFFFFFFFF, "...%s", params[64]);
    }
    else sendFormatMessageToAll(0xFFFFFFFF, "[Janelas Fechadas] %s diz: %s", ReturnName(playerid, 0), params);


    return 1;
}

CMD:gritar(playerid, params[])
{
    new grito[256];

    if(sscanf(params, "s[256]", grito)) 
        return sendSyntaxMessage(playerid, "/gritar [fala]");

    if(strlen(params) > 64)
    {
        sendFormatMessageToAll(0xFFFFFFFF, "%s grita: %.64s", ReturnName(playerid, 0), params); 
        sendFormatMessageToAll(0xFFFFFFFF, "...%s", params[64]);
    }
    else sendFormatMessageToAll(0xFFFFFFFF, "%s grita: %s", ReturnName(playerid, 0), grito);

    return 1;
}

alias:gritar("g");

CMD:colete(playerid, params[])
{
    new target, qntd;

    if(sscanf(params, "ud", target, qntd))
        return sendSyntaxMessage(playerid, "/colete [ID] [quantidade]");

    SetPlayerArmour(target, qntd);
    return 1;
}

CMD:vida(playerid, params[])
{
    new target, qntd;

    if(sscanf(params, "ud", target, qntd))
        return sendSyntaxMessage(playerid, "/vida [playerid] [quantidade]");

    SetPlayerHealth(target, qntd);
    return 1;
}

CMD:telapreta(playerid, params[])
{
    switch(IsOnBlackScreen[playerid])
    {
        case 0:
        {
            TextDrawShowForPlayer(playerid,TelinhaPreta);
            IsOnBlackScreen[playerid] = 1;
        }
        case 1:
        {
            TextDrawHideForPlayer(playerid,TelinhaPreta);
            IsOnBlackScreen[playerid] = 0;
        }
    }
    return 1;
}

CMD:trazer(playerid, params[])
{
    new target = (-1);
    if (sscanf(params, "u", target)) 
        return sendSyntaxMessage(playerid, "/trazer [playerid]");

    if (!IsPlayerConnected(target)) 
        return sendErrorMessage(playerid, MSG_PLAYER_OFF);

    if (target == playerid) 
        return sendErrorMessage(playerid, "Você não pode utilizar este comando em si mesmo.");

    new Float: sPp[3];
    GetPlayerPos(playerid, sPp[0], sPp[1], sPp[2]);
    new interior = GetPlayerInterior(playerid);
    new virtualworld = GetPlayerVirtualWorld(playerid);
    SetPlayerPos(target, sPp[0], sPp[1], sPp[2]);
    SetPlayerInterior(target, interior);
    SetPlayerVirtualWorld(target, virtualworld);
    
    sendFormatMessage(target, COLOR_YELLOW, "[AVISO]:{FFFFFF} Você foi levado até o jogador %s.", Name(playerid));
    sendFormatMessage(playerid, COLOR_CLIENT, "[ADMIN]:{FFFFFF} Você trouxe %s até a sua posição.", Name(target));
    return true;
}

CMD:ir(playerid, params[])
{
    new target;

    if (sscanf(params, "u", target)) 
        return sendSyntaxMessage(playerid, "/ir [playerid]");

    if (!IsPlayerConnected(target)) 
        return sendErrorMessage(playerid, MSG_PLAYER_OFF);

    if (target == playerid) 
        return sendErrorMessage(playerid, "Você não pode utilizar este comando em si mesmo.");

    new Float: sPp[3];
    GetPlayerPos(target, sPp[0], sPp[1], sPp[2]);
    new interior = GetPlayerInterior(target);
    new virtualworld = GetPlayerVirtualWorld(target);
    SetPlayerPos(playerid, sPp[0], sPp[1], sPp[2]);
    SetPlayerInterior(playerid, interior);
    SetPlayerVirtualWorld(playerid, virtualworld);

    sendFormatMessage(playerid, COLOR_CLIENT, "[ADMIN]:{FFFFFF} Você foi até o jogador %s.", Name(target));
    return 1;
}

CMD:ls(playerid)
{
    sendAdminMessage(playerid, "Você foi para Los Santos.");
    SetPlayerPos(playerid, 1481.1891,-1738.9368,13.5469);
    SetPlayerFacingAngle(playerid, 0);
    SetCameraBehindPlayer(playerid);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}
CMD:sf(playerid)
{
    sendAdminMessage(playerid, "Você foi para San Fierro.");
    SetPlayerPos(playerid, -1984.1697,137.9343,27.6875);
    SetPlayerFacingAngle(playerid, 90);
    SetCameraBehindPlayer(playerid);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}
CMD:lv(playerid)
{
    sendAdminMessage(playerid, "Você foi para Las Venturas.");
    SetPlayerPos(playerid, 2025.8577,1343.0251,10.8203);
    SetPlayerFacingAngle(playerid, 270);
    SetCameraBehindPlayer(playerid);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}

CMD:luzes(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
        return sendErrorMessage(playerid, "Você não está em um veículo.");

    if(IsPlayerInAnyVehicle(playerid))
    {
        new engine, lights, alarm, doors, bonnet, boot, objective;
        new vid = GetPlayerVehicleID(playerid);
        
        if(Bicicleta(vid)) return 0;
        
        GetVehicleParamsEx(vid, engine, lights, alarm, doors, bonnet, boot, objective);
        if(lights == 0)
        {
            SetVehicleParamsEx(vid,engine,1,alarm,doors,bonnet,boot,objective);
            GameTextForPlayer(playerid, "~g~LUZES LIGADAS", 4000, 3);
            return 1;
        }
        else if(lights == 1)
        {
            SetVehicleParamsEx(vid,engine,0,alarm,doors,bonnet,boot,objective);
            GameTextForPlayer(playerid, "~r~LUZES DESLIGADAS", 4000, 3);
            Engine[playerid]=0;
            return 1;
        }
        else if(lights == -1)
        {
            SetVehicleParamsEx(vid,engine,1,alarm,doors,bonnet,boot,objective);
            GameTextForPlayer(playerid, "~g~LUZES LIGADAS", 4000, 3);
            return 1;
        }
    }
    return 1;
}
CMD:motor(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
        return sendErrorMessage(playerid, "Você não está em um veículo.");

    if(IsPlayerInAnyVehicle(playerid))
    {
        new playervehicle = GetPlayerVehicleID(playerid);
        if(Bicicleta(playervehicle)) return 0;
        
        new engine, lights, alarm, doors, bonnet, boot, objective;
        new vid = GetPlayerVehicleID(playerid);
        GetVehicleParamsEx(vid, engine, lights, alarm, doors, bonnet, boot, objective);
        if(engine == 0)
        {
            SetVehicleParamsEx(vid,1,lights,alarm,doors,bonnet,boot,objective);
            GameTextForPlayer(playerid, "~g~MOTOR LIGADO", 4000, 3);
            Engine[playerid] = 1;
            return 1;
        }
        else if(engine == 1)
        {
            SetVehicleParamsEx(vid,0,lights,alarm,doors,bonnet,boot,objective);
            GameTextForPlayer(playerid, "~r~MOTOR DESLIGADO", 4000, 3);
            Engine[playerid]=0;
            return 1;
        }
        else if(engine == -1)
        {
            SetVehicleParamsEx(vid,1,lights,alarm,doors,bonnet,boot,objective);
            GameTextForPlayer(playerid, "~g~MOTOR LIGADO", 4000, 3);
            Engine[playerid] = 1;
            return 1;
        }
    }
    return 1;
}

CMD:capo(playerid, params[])
{
    new vehicleid,engine,lights,alarm,doors,bonnet,boot,objective;
    vehicleid = GetPlayerVehicleID(playerid);
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    
    if(!IsPlayerInAnyVehicle(playerid))
        return sendErrorMessage(playerid, "Você não está em um veículo.");
    
    if(GetPlayerVehicleSeat(playerid) != 0)
        return sendErrorMessage(playerid, "Você não é o motorista.");
    
    if(bonnet == 1)
    {
        SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,0,0,objective);
    }
    else
    {
        SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,1,0,objective);
    }
    return 1;
}

CMD:portamalas(playerid, params[])
{
    new vehicleid,engine,lights,alarm,doors,bonnet,boot,objective;
    vehicleid = GetPlayerVehicleID(playerid);
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    
    if(!IsPlayerInAnyVehicle(playerid))
        return sendErrorMessage(playerid, "Você não está em um veículo.");
    
    if(GetPlayerVehicleSeat(playerid) != 0)
        return sendErrorMessage(playerid, "Você não é o motorista.");
    
    if(boot == 1)
    {
        SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,0,0,objective);
    }
    else
    {
        SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,0,1,objective);
    }
    return 1;
}

CMD:pintar(playerid, params[])
{
    new vcor1, vcor2;
    if(!IsPlayerInAnyVehicle(playerid))
        return sendErrorMessage(playerid, "Você não está em um veículo.");

    if(sscanf(params,"dd", vcor1, vcor2)) 
        return sendSyntaxMessage(playerid, "/pintar [cor1] [cor2]");

    new vehicleid = GetPlayerVehicleID(playerid);

    ChangeVehicleColor(vehicleid, vcor1, vcor2);
    return 1;
}

CMD:car(playerid, params[])
{
    new vname[20];

    if(sscanf(params,"s[20]", vname)) 
        return sendSyntaxMessage(playerid, "/car [modelo/id]");

    if(!IsPlayerInAnyVehicle(playerid))
    {
        CreateVehicleForPlayer(playerid, vname, -1, -1,1000.0);
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "[ERRO]: {FFFFFF}Você já está em um veículo.");
    
    return 1;
}

CMD:jetpack(playerid)
{
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
    return 1;
}

CMD:reparar(playerid, params[])
{
    RepairVehicle(GetPlayerVehicleID(playerid));
    return 1;
}

CMD:celularm(playerid, params[])
{
    new celltext[32], ctext2[256];
    if(sscanf(params, "s[32]s[256]", celltext, ctext2)) 
        return sendSyntaxMessage(playerid, "/celularm [nome] [mensagem]");


    if(strlen(params) > 64)
    {
        sendFormatMessage(playerid, COLOR_YELLOW, "(celular) %s diz: *voz masculina* %.64s", celltext, ctext2); 
        sendFormatMessage(playerid, COLOR_YELLOW, "...%s", ctext2[64]);
    }
    else sendFormatMessage(playerid, COLOR_YELLOW, "(celular) %s diz: *voz masculina* %s", celltext, ctext2);

    return 1;
}

CMD:celularf(playerid, params[])
{
    new celltext[32], ctext2[256];
    if(sscanf(params, "s[32]s[256]", celltext, ctext2)) 
        return sendSyntaxMessage(playerid, "/celularf [nome] [mensagem]");


    if(strlen(params) > 64)
    {
        sendFormatMessage(playerid, COLOR_YELLOW, "(celular) %s diz: *voz masculina* %.64s", celltext, ctext2); 
        sendFormatMessage(playerid, COLOR_YELLOW, "...%s", ctext2[64]);
    }
    else sendFormatMessage(playerid, COLOR_YELLOW, "(celular) %s diz: *voz masculina* %s", celltext, ctext2);

    return 1;
}

CMD:sms(playerid, params[])
{
    new celltext[32], ctext2[256];
    if(sscanf(params, "s[32]s[256]", celltext, ctext2)) 
        return sendSyntaxMessage(playerid, "/sms [nome/numero] [mensagem]");


    if(strlen(params) > 58)
    {
        sendFormatMessage(playerid, COLOR_YELLOW, "[SMS] %.58s (%s)", ctext2, celltext); 
        sendFormatMessage(playerid, COLOR_YELLOW, "...%s", ctext2[58]);
    }
    else sendFormatMessage(playerid, COLOR_YELLOW, "[SMS] %s (%s)", ctext2, celltext);

    return 1;
}

CMD:meucelular(playerid, params[])
{
    new meucelltext[32], meucelltexts[32],meuctext2[256];
    if(sscanf(params, "s[32]s[32]s[256]", meucelltext, meucelltexts, meuctext2)) 
        return sendSyntaxMessage(playerid, "/meucelular [nome] [sobrenome] [mensagem]");


    if(strlen(params) > 64)
    {
        sendFormatMessage(playerid, 0xE6E6E6FF, "%s %s (celular): %.64s", meucelltext, meucelltexts, meuctext2); 
        sendFormatMessage(playerid, 0xE6E6E6FF, "...%s", meuctext2[64]);
    }
    else sendFormatMessage(playerid, 0xE6E6E6FF, "%s %s (celular): %s", meucelltext, meucelltexts, meuctext2);

    return 1;
}

CMD:me(playerid, params[])
{
    new metext[256];
    if(sscanf(params, "s[256]", metext)) 
        return sendSyntaxMessage(playerid, "/me [ação]");

    if(strlen(params) > 64)
    {
        sendFormatMessageToAll(COLOR_EMOTE, "* %s %.64s", ReturnName(playerid, 0), params); 
        sendFormatMessageToAll(COLOR_EMOTE, "...%s", params[64]);
    }
    else sendFormatMessageToAll(COLOR_EMOTE, "* %s %s", ReturnName(playerid, 0), params);
        
    return 1; 
}

CMD:do(playerid, params[])
{
    new dotext[256];
    if(sscanf(params, "s[256]", dotext))
        return sendSyntaxMessage(playerid, "/do [descrição]");

    if(strlen(params) > 64)
    {
        sendFormatMessageToAll(COLOR_EMOTE, "* %.64s", params); 
        sendFormatMessageToAll(COLOR_EMOTE, "*...%s (( %s ))", params[64], ReturnName(playerid, 0));
    }
    else sendFormatMessageToAll(COLOR_EMOTE, "* %s (( %s ))", params, ReturnName(playerid, 0));
        
    return 1; 
}

CMD:ado(playerid, params[])
{
    new opcao[256], str[256];
    if (sscanf(params, "s[256]", opcao)) 
        return sendSyntaxMessage(playerid, "/ado [descrição]");

    format(str,sizeof(str),"* %s (( %s ))", opcao, ReturnName(playerid, 0));
    SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 10000);

    format(str, sizeof(str), "> %s (( %s ))", opcao, ReturnName(playerid, 0));
    SendClientMessage(playerid, COLOR_EMOTE, str);

    return 1;
}

CMD:ame(playerid, params[])
{
    new text[128],stringa[256];

    if(sscanf(params, "s[128]", text)) 
        return sendSyntaxMessage(playerid, "/ame [ação]");

    format(stringa, sizeof(stringa), "* %s %s", ReturnName(playerid, 0), text);
    SetPlayerChatBubble(playerid, stringa, COLOR_EMOTE, 20.0, 10000);

    format(stringa, sizeof(stringa), "> %s %s ", ReturnName(playerid, 0), text);
    SendClientMessage(playerid, COLOR_EMOTE, stringa);

    return 1;
}

CMD:pagar(playerid, params[])
{
    new target[32], qntd[32];

    if(sscanf(params, "s[32]s[32]", target, qntd))
        return sendSyntaxMessage(playerid, "/pagar [playerid] [quantia]");

    sendFormatMessage(playerid, COLOR_WHITE, "SERVER: Você deu $%s para %s.", target, qntd);
    sendFormatMessage(playerid, COLOR_EMOTE, "* %s recebeu $%s de %s.", qntd, target, ReturnName(playerid, 0));
    sendFormatMessage(playerid, COLOR_WHITE, "SERVER: Você recebeu $%s de %s.", target, qntd);
    sendFormatMessage(playerid, COLOR_EMOTE, "* %s recebeu $%s de %s.", ReturnName(playerid, 0), target, qntd); 

    return 1;
}

CMD:vender(playerid, params[])
{
    new carro[32], valor[32], nome[32];

    if(sscanf(params, "s[32]s[32]s[32]", carro, valor, nome))
        return sendSyntaxMessage(playerid, "/vender [carro] [valor] [nome]");

    sendFormatMessage(playerid, 0x36a717FF, "Você ofereceu a(à) %s a compra de seu %s por (%s).", nome, carro, valor);
    sendFormatMessage(playerid, 0x36a717FF, "%s aceitou a oferta de compra do seu(sua) %s por %s.", nome, carro, valor);

    SendClientMessage(playerid, 0x96cb2eFF, "PROCESSANDO: Reorganizando sua lista de veiculos...");
    SendClientMessage(playerid, 0x96cb2eFF, "PROCESSADO: Lista reorganizada...");

    return 1;
}

CMD:hora(playerid,params[])
{
    new tempo;
    if(sscanf(params, "i", tempo)) 
        return sendSyntaxMessage(playerid, "/hora [horas]");

    SetWorldTime(tempo);
    return 1;
}

CMD:clima(playerid, params[])
{
    new clima;
    if(sscanf(params, "i", clima)) 
        return sendSyntaxMessage(playerid, "/clima [clima]");

    SetWeather(clima);
    return 1;
}

CMD:cairfrente(playerid) 
{ 
    ApplyAnimation(playerid, "PED", "KO_shot_front",4.1,0,1,1,1,1); 
    return 1; 
}

CMD:stopanim(playerid)
{
    ClearAnimations(playerid);
    return 1;
}

CMD:mudarsenha(playerid,params[])
{
    new pass[64];

    if(sscanf(params, "s", pass)) 
        return sendSyntaxMessage(playerid, "/mudarsenha [nova senha]");
    
    format(Conta, sizeof(Conta), "Contas/%s.ini", Name(playerid));
    DOF2_SetString(Conta, "Password", pass);
    DOF2_SaveFile();

    sendFormatMessage(playerid, COLOR_TEAL,"[SERVER]: {FFFFFF}Sua nova senha é '{3498DB}%s{FFFFFF}'.", pass);
    return 1;
}

CMD:mudarnick(playerid, params[])
{
    new KinG2[40], nick[22], ContaVer[256];
    
    if(sscanf(params, "s", nick)) 
        return sendSyntaxMessage(playerid, "/mudarnick [novo nick]");

    for(new i, l = strlen(params); i < l; i++)
    {
        if (params[i] == ' ')
            return sendErrorMessage(playerid, "Um caractere inválido foi detectado no seu novo nick, tente outro.");
    }

    if(strlen(nick) > 21) 
        return sendErrorMessage(playerid, "Seu novo nick é muito grande, tente outro.");

    format(Conta, sizeof(Conta), "Contas/%s.ini", Name(playerid));
    format(ContaVer, sizeof(ContaVer), "Contas/%s.ini", nick);

    if(!DOF2_FileExists(ContaVer))
    {
        sendFormatMessageToAll(COLOR_INFO, "[INFO]:{FFFFFF} O jogador %s mudou o nick para '%s'.", Name(playerid), params);
        format(KinG2, sizeof(KinG2), "Contas/%s.ini", nick);
        DOF2_RenameFile(Conta, KinG2);
        SetPlayerName(playerid, nick);
    }

    else sendErrorMessage(playerid, "O nick escolhido já está sendo utilizado, tente outro.");

    return 1;
}


CMD:setskin(playerid ,params[])
{
    new id, skin;

    if(sscanf(params, "ud", id, skin)) 
        return sendSyntaxMessage(playerid, "/setskin [playerid] [skinid]");

    if(skin > 311) 
        return sendErrorMessage(playerid, "Use apenas skins entre 0 e 311.");

    if(!IsPlayerConnected(id)) 
        return sendErrorMessage(playerid, MSG_PLAYER_OFF);

    sendFormatMessage(id, COLOR_TEAL, "[SERVER]:{FFFFFF} Sua skin foi setada para {3498DB}%d{FFFFFF}.", skin);

    SetPlayerSkin(id, skin);
    Player[id][pSkin] = skin;
    return 1;
}

CMD:setscore(playerid ,params[])
{
    new id, score;

    if(sscanf(params, "ud", id, score)) 
        return sendSyntaxMessage(playerid, "/setscore [playerid] [score]");

    if(!IsPlayerConnected(id)) 
        return sendErrorMessage(playerid, MSG_PLAYER_OFF);

    sendFormatMessage(id, COLOR_TEAL, "[SERVER]:{FFFFFF} Seu score foi setado para {3498DB}%d{FFFFFF}.", score);

    SetPlayerScore(id, score);
    Player[id][pScore] = score;
    return 1;
}

CMD:setmoney(playerid, params[])
{
    new id, money;

    if(sscanf(params, "ud", id, money)) 
        return sendSyntaxMessage(playerid, "/setmoney [playerid] [money]");

    if(!IsPlayerConnected(id)) 
        return sendErrorMessage(playerid, MSG_PLAYER_OFF);

    sendFormatMessage(id, COLOR_TEAL, "[SERVER]:{FFFFFF} Seu dinheiro foi setado para {4f8252}$%d{FFFFFF}.", money);

    SetPlayerCash(id, money);
    Player[id][pMoney] = money;
    return 1;
}

CMD:dararma(playerid,params[])
{
    new gun; new ammo; new id; new gunname[128];

    if(!IsPlayerConnected(id)) 
        return sendErrorMessage(playerid, MSG_PLAYER_OFF);

    if(sscanf(params, "udd", id, gun, ammo)) 
        return sendSyntaxMessage(playerid, "/dararma [ID] [arma] [balas]");

    if(gun < 1 || gun > 46) 
        return sendErrorMessage(playerid, "Use apenas armas entre 1 e 46.");
    
    GetWeaponName(gun, gunname, sizeof(gunname));
    
    sendFormatMessage(id, COLOR_TEAL, "[SERVER]:{FFFFFF} Você recebeu um(a) {3498DB}%s{FFFFFF} com {3498DB}%d{FFFFFF} balas.", gunname, ammo);
    
    GivePlayerWeapon(id, gun, ammo);
    return 1;
}

CMD:limparchat(playerid)
{
    for(new i = 0; i < 50; i++) SendClientMessageToAll(-1,"");
    return 1;
}


CMD:ajuda(playerid)
{
    SendClientMessage(playerid, -1, "/ajuda, /mudarsenha, /mudarnick, /stopanim, /cairfrente");
    SendClientMessage(playerid, -1, "/pagar, /ame, /ado, /me, /ado, /meucelular, /celularm, /celularf, /sms");
    SendClientMessage(playerid, -1, "/reparar, /jetpack, /car, /pintar, /capo, /portamalas, /motor, /luzes");
    SendClientMessage(playerid, -1, "/ls, /sf, /lv, /telapreta, /setvida, /setcolete, /gritar, /janelasf");
    SendClientMessage(playerid, -1, "/setskin, /setscore, /setmoney, /limparchat, /clima, /hora, /dararma");

    return 1;
}

CMD:creditos(playerid)
{
    ShowPlayerDialog(playerid, 8111, DIALOG_STYLE_MSGBOX, "Créditos", "\n{FFFFFF}Créditos ao Tassi pela criação do GM;\nCréditos ao KinG7 pela base do sistema de registro e login.", "Fechar", "");
    return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    if(Player[playerid][pLogado] == false) return sendErrorMessage(playerid, "Você não está logado."), false;
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1) return sendErrorMessage(playerid, "Comando inexistente.");
    return 1;
}

//=====================================================================================||

CriarConta(playerid)
{
    format(Conta, sizeof(Conta), "Contas/%s.ini", Name(playerid));

    DOF2_SetInt(Conta, "Skin", 97);
    DOF2_SetInt(Conta, "Money", 500);
    DOF2_SetInt(Conta, "Score", 0);
    DOF2_SetFloat(Conta, "PosX", 2069.8767);
    DOF2_SetFloat(Conta, "PosY", -1766.6870);
    DOF2_SetFloat(Conta, "PosZ", 13.5621);
    DOF2_SetFloat(Conta, "PosA", 90.0);
    DOF2_SetInt(Conta, "Interior", 0);
    DOF2_SetInt(Conta, "VW", 0);

    DOF2_SaveFile();
}

CarregarConta(playerid)
{
    format(Conta, sizeof(Conta), "Contas/%s.ini", Name(playerid));

    Player[playerid][pSkin] = DOF2_GetInt(Conta, "Skin");
    Player[playerid][pMoney] = DOF2_GetInt(Conta, "Money");
    Player[playerid][pScore] = DOF2_GetInt(Conta, "Score");
    Player[playerid][pPosX] = DOF2_GetInt(Conta, "PosX");
    Player[playerid][pPosY] = DOF2_GetInt(Conta, "PosY");
    Player[playerid][pPosZ] = DOF2_GetInt(Conta, "PosZ");
    Player[playerid][pPosA] = DOF2_GetInt(Conta, "PosA");
    Player[playerid][pInterior] = DOF2_GetInt(Conta, "Interior");
    Player[playerid][pVW] = DOF2_GetInt(Conta, "VW");
    Player[playerid][pLogado]=true;

    SetPlayerScore(playerid, Player[playerid][pScore]);
    SetPlayerCash(playerid, Player[playerid][pMoney]);
    SetPlayerInterior(playerid, Player[playerid][pInterior]);
    SetPlayerVirtualWorld(playerid, Player[playerid][pVW]);
    SetSpawnInfo(playerid, -1, Player[playerid][pSkin], Player[playerid][pPosX], Player[playerid][pPosY], Player[playerid][pPosZ], Player[playerid][pPosA],0,0,0,0,0,0);
    SpawnPlayer(playerid);
}

SalvarConta(playerid)
{
    format(Conta, sizeof(Conta), "Contas/%s.ini", Name(playerid));
    GetPlayerPos(playerid, Player[playerid][pPosX], Player[playerid][pPosY], Player[playerid][pPosZ]);
    GetPlayerFacingAngle(playerid,Player[playerid][pPosA]);

    DOF2_SetInt(Conta, "Skin", Player[playerid][pSkin]);
    DOF2_SetInt(Conta, "Money", Player[playerid][pMoney]);
    DOF2_SetInt(Conta, "Score", Player[playerid][pScore]);

    DOF2_SetFloat(Conta, "PosX", Player[playerid][pPosX]);
    DOF2_SetFloat(Conta, "PosY", Player[playerid][pPosY]);
    DOF2_SetFloat(Conta, "PosZ", Player[playerid][pPosZ]);
    DOF2_SetFloat(Conta, "PosA", Player[playerid][pPosA]);
    DOF2_SetInt(Conta, "Interior", GetPlayerInterior(playerid));
    DOF2_SetInt(Conta, "VW", GetPlayerVirtualWorld(playerid));

    DOF2_SaveFile();
}

Name(playerid)
{
    new pNome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pNome, 24);
    return pNome;
}

forward Kicka(p);
public Kicka(p)
{
    #undef Kick
    Kick(p);
    #define Kick(%0) SetTimerEx("Kicka", 1000, false, "i", %0)
    return 1;
}

forward SaveAcc(playerid);
public SaveAcc(playerid)
{
    SalvarConta(playerid);
    return 1;
}

stock ReturnName(playerid, underScore = 1)
{
    new playersName[MAX_PLAYER_NAME + 2];
    GetPlayerName(playerid, playersName, sizeof(playersName)); 
    
    if(!underScore)
    {
        {
            for(new i = 0, j = strlen(playersName); i < j; i ++) 
            { 
                if(playersName[i] == '_') 
                { 
                    playersName[i] = ' '; 
                } 
            } 
        }
    }
    return playersName;
}

stock Bicicleta(vehicleid)
{
    switch(GetVehicleModel(vehicleid))
    {
        case 481,509,510:return 1;
    }
    return 0;
}