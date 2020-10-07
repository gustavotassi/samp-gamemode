
/*************************************************/
/* CreateVehicleForPlayer Include by iPLEOMAX    */
/*************************************************/

#if !defined _samp_included
    #tryinclude <a_samp>
    #if !defined _samp_included
        #error Unable to find a_samp.inc Please check your includes.
    #endif
#endif

/* Natives:
native CreateVehicleForPlayer(playerid, vehiclename[], color1, color2, Float:Health);
native DeletePlayerVehicle(playerid);
*/

forward CreateVehicleForPlayer(playerid, vehiclename[], color1, color2, Float:Health);
forward DeletePlayerVehicle(playerid);

enum PV_User
{
	vehicle
};
static P_DATA_VEH[ MAX_PLAYERS ][ PV_User ];

public CreateVehicleForPlayer(playerid, vehiclename[], color1, color2, Float:Health)
{
	new pvmid;
	if(strfind("Landstalker", vehiclename,true,0) != -1) pvmid = 400;
	if(strfind("Bravura", vehiclename,true,0) != -1) pvmid = 401;
	if(strfind("Buffalo", vehiclename,true,0) != -1) pvmid = 402;
	if(strfind("Linerunner", vehiclename,true,0) != -1) pvmid = 403;
	if(strfind("Perenniel", vehiclename,true,0) != -1) pvmid = 404;
	if(strfind("Sentinel", vehiclename,true,0) != -1) pvmid = 405;
	if(strfind("Dumper", vehiclename,true,0) != -1) pvmid = 406;
	if(strfind("Firetuck", vehiclename,true,0) != -1) pvmid = 407;
	if(strfind("Trashmaster", vehiclename,true,0) != -1) pvmid = 408;
	if(strfind("Stretch", vehiclename,true,0) != -1) pvmid = 409;
	if(strfind("Manana", vehiclename,true,0) != -1) pvmid = 410;
	if(strfind("Infernus", vehiclename,true,0) != -1) pvmid = 411;
	if(strfind("Voodoo", vehiclename,true,0) != -1) pvmid = 412;
	if(strfind("Pony", vehiclename,true,0) != -1) pvmid = 413;
	if(strfind("Mule", vehiclename,true,0) != -1) pvmid = 414;
	if(strfind("Cheetah", vehiclename,true,0) != -1) pvmid = 415;
	if(strfind("Ambulance", vehiclename,true,0) != -1) pvmid = 416;
	if(strfind("Leviathan", vehiclename,true,0) != -1) pvmid = 417;
	if(strfind("Moonbeam", vehiclename,true,0) != -1) pvmid = 418;
	if(strfind("Esperanto", vehiclename,true,0) != -1) pvmid = 419;
	if(strfind("Taxi", vehiclename,true,0) != -1) pvmid = 420;
	if(strfind("Washington", vehiclename,true,0) != -1) pvmid = 421;
	if(strfind("Bobcat", vehiclename,true,0) != -1) pvmid = 422;
	if(strfind("Mr Whoopie", vehiclename,true,0) != -1) pvmid = 423;
	if(strfind("BF Injection", vehiclename,true,0) != -1) pvmid = 424;
	if(strfind("Hunter", vehiclename,true,0) != -1) pvmid = 425;
	if(strfind("Premier", vehiclename,true,0) != -1) pvmid = 426;
	if(strfind("Enforcer", vehiclename,true,0) != -1) pvmid = 427;
	if(strfind("Securicar", vehiclename,true,0) != -1) pvmid = 428;
	if(strfind("Banshee", vehiclename,true,0) != -1) pvmid = 429;
	if(strfind("Predator", vehiclename,true,0) != -1) pvmid = 430;
	if(strfind("Bus", vehiclename,true,0) != -1) pvmid = 431;
	if(strfind("Rhino", vehiclename,true,0) != -1) pvmid = 432;
	if(strfind("Barracks", vehiclename,true,0) != -1) pvmid = 433;
	if(strfind("Hotknife", vehiclename,true,0) != -1) pvmid = 434;
	if(strfind("ArticleTrailer", vehiclename,true,0) != -1) pvmid = 435;
	if(strfind("Previon", vehiclename,true,0) != -1) pvmid = 436;
	if(strfind("Coach", vehiclename,true,0) != -1) pvmid = 437;
	if(strfind("Cabbie", vehiclename,true,0) != -1) pvmid = 438;
	if(strfind("Stallion", vehiclename,true,0) != -1) pvmid = 439;
	if(strfind("Rumpo", vehiclename,true,0) != -1) pvmid = 440;
	if(strfind("RCBandit", vehiclename,true,0) != -1) pvmid = 441;
	if(strfind("Romero", vehiclename,true,0) != -1) pvmid = 442;
	if(strfind("Packer", vehiclename,true,0) != -1) pvmid = 443;
	if(strfind("Monster", vehiclename,true,0) != -1) pvmid = 444;
	if(strfind("Admiral", vehiclename,true,0) != -1) pvmid = 445;
	if(strfind("Squallo", vehiclename,true,0) != -1) pvmid = 446;
	if(strfind("Seasparrow", vehiclename,true,0) != -1) pvmid = 447;
	if(strfind("Pizzaboy", vehiclename,true,0) != -1) pvmid = 448;
	if(strfind("Tram", vehiclename,true,0) != -1) pvmid = 449;
	if(strfind("Article Trailer 2", vehiclename,true,0) != -1) pvmid = 450;
	if(strfind("Turismo", vehiclename,true,0) != -1) pvmid = 451;
	if(strfind("Speeder", vehiclename,true,0) != -1) pvmid = 452;
	if(strfind("Reefer", vehiclename,true,0) != -1) pvmid = 453;
	if(strfind("Tropic", vehiclename,true,0) != -1) pvmid = 454;
	if(strfind("Flatbed", vehiclename,true,0) != -1) pvmid = 455;
	if(strfind("Yankee", vehiclename,true,0) != -1) pvmid = 456;
	if(strfind("Caddy", vehiclename,true,0) != -1) pvmid = 457;
	if(strfind("Solair", vehiclename,true,0) != -1) pvmid = 458;
	if(strfind("Berkley's RC Van", vehiclename,true,0) != -1) pvmid = 459;
	if(strfind("Skimmer", vehiclename,true,0) != -1) pvmid = 460;
	if(strfind("PCJ600", vehiclename,true,0) != -1) pvmid = 461;
	if(strfind("Faggio", vehiclename,true,0) != -1) pvmid = 462;
	if(strfind("Freeway", vehiclename,true,0) != -1) pvmid = 463;
	if(strfind("RCBaron", vehiclename,true,0) != -1) pvmid = 464;
	if(strfind("RCRaider", vehiclename,true,0) != -1) pvmid = 465;
	if(strfind("Glendale", vehiclename,true,0) != -1) pvmid = 466;
	if(strfind("Oceanic", vehiclename,true,0) != -1) pvmid = 467;
	if(strfind("Sanchez", vehiclename,true,0) != -1) pvmid = 468;
	if(strfind("Sparrow", vehiclename,true,0) != -1) pvmid = 469;
	if(strfind("Patriot", vehiclename,true,0) != -1) pvmid = 470;
	if(strfind("Quad", vehiclename,true,0) != -1) pvmid = 471;
	if(strfind("Coastguard", vehiclename,true,0) != -1) pvmid = 472;
	if(strfind("Dinghy", vehiclename,true,0) != -1) pvmid = 473;
	if(strfind("Hermes", vehiclename,true,0) != -1) pvmid = 474;
	if(strfind("Sabre", vehiclename,true,0) != -1) pvmid = 475;
	if(strfind("Rustler", vehiclename,true,0) != -1) pvmid = 476;
	if(strfind("ZR350", vehiclename,true,0) != -1) pvmid = 477;
	if(strfind("Walton", vehiclename,true,0) != -1) pvmid = 478;
	if(strfind("Regina", vehiclename,true,0) != -1) pvmid = 479;
	if(strfind("Comet", vehiclename,true,0) != -1) pvmid = 480;
	if(strfind("BMX", vehiclename,true,0) != -1) pvmid = 481;
	if(strfind("Burrito", vehiclename,true,0) != -1) pvmid = 482;
	if(strfind("Camper", vehiclename,true,0) != -1) pvmid = 483;
	if(strfind("Marquis", vehiclename,true,0) != -1) pvmid = 484;
	if(strfind("Baggage", vehiclename,true,0) != -1) pvmid = 485;
	if(strfind("Dozer", vehiclename,true,0) != -1) pvmid = 486;
	if(strfind("Maverick", vehiclename,true,0) != -1) pvmid = 487;
	if(strfind("SAN News Maverick", vehiclename,true,0) != -1) pvmid = 488;
	if(strfind("Rancher", vehiclename,true,0) != -1) pvmid = 489;
	if(strfind("FBI Rancher", vehiclename,true,0) != -1) pvmid = 490;
	if(strfind("Virgo", vehiclename,true,0) != -1) pvmid = 491;
	if(strfind("Greenwood", vehiclename,true,0) != -1) pvmid = 492;
	if(strfind("Jetmax", vehiclename,true,0) != -1) pvmid = 493;
	if(strfind("Hotring Racer", vehiclename,true,0) != -1) pvmid = 494;
	if(strfind("Sandking", vehiclename,true,0) != -1) pvmid = 495;
	if(strfind("Blista Compact", vehiclename,true,0) != -1) pvmid = 496;
	if(strfind("Police Maverick", vehiclename,true,0) != -1) pvmid = 497;
	if(strfind("Boxville", vehiclename,true,0) != -1) pvmid = 498;
	if(strfind("Benson", vehiclename,true,0) != -1) pvmid = 499;
	if(strfind("Mesa", vehiclename,true,0) != -1) pvmid = 500;
	if(strfind("RC Goblin", vehiclename,true,0) != -1) pvmid = 501;
	if(strfind("Hotring Racer", vehiclename,true,0) != -1) pvmid = 502;
	if(strfind("Hotring Racer", vehiclename,true,0) != -1) pvmid = 503;
	if(strfind("Bloodring Banger", vehiclename,true,0) != -1) pvmid = 505;
	if(strfind("Lure Rancher", vehiclename,true,0) != -1) pvmid = 505;
	if(strfind("Super GT", vehiclename,true,0) != -1) pvmid = 506;
	if(strfind("Elegant", vehiclename,true,0) != -1) pvmid = 507;
	if(strfind("Journey", vehiclename,true,0) != -1) pvmid = 508;
	if(strfind("Bike", vehiclename,true,0) != -1) pvmid = 509;
	if(strfind("Mountain Bike", vehiclename,true,0) != -1) pvmid = 510;
	if(strfind("Beagle", vehiclename,true,0) != -1) pvmid = 511;
	if(strfind("Cropduster", vehiclename,true,0) != -1) pvmid = 512;
	if(strfind("Stuntplane", vehiclename,true,0) != -1) pvmid = 513;
	if(strfind("Tanker", vehiclename,true,0) != -1) pvmid = 514;
	if(strfind("Roadtrain", vehiclename,true,0) != -1) pvmid = 515;
	if(strfind("Nebula", vehiclename,true,0) != -1) pvmid = 516;
	if(strfind("Majestic", vehiclename,true,0) != -1) pvmid = 517;
	if(strfind("Buccaneer", vehiclename,true,0) != -1) pvmid = 518;
	if(strfind("Shamal", vehiclename,true,0) != -1) pvmid = 519;
	if(strfind("Hydra", vehiclename,true,0) != -1) pvmid = 520;
	if(strfind("FCR900", vehiclename,true,0) != -1) pvmid = 521;
	if(strfind("NRG500", vehiclename,true,0) != -1) pvmid = 522;
	if(strfind("HPV1000", vehiclename,true,0) != -1) pvmid = 523;
	if(strfind("Cement Truck", vehiclename,true,0) != -1) pvmid = 525;
	if(strfind("Towtruck", vehiclename,true,0) != -1) pvmid = 525;
	if(strfind("Fortune", vehiclename,true,0) != -1) pvmid = 526;
	if(strfind("Cadrona", vehiclename,true,0) != -1) pvmid = 527;
	if(strfind("FBI Truck", vehiclename,true,0) != -1) pvmid = 528;
	if(strfind("Willard", vehiclename,true,0) != -1) pvmid = 529;
	if(strfind("Forklift", vehiclename,true,0) != -1) pvmid = 530;
	if(strfind("Tractor", vehiclename,true,0) != -1) pvmid = 531;
	if(strfind("Combine Harvester", vehiclename,true,0) != -1) pvmid = 532;
	if(strfind("Feltzer", vehiclename,true,0) != -1) pvmid = 533;
	if(strfind("Remington", vehiclename,true,0) != -1) pvmid = 534;
	if(strfind("Slamvan", vehiclename,true,0) != -1) pvmid = 535;
	if(strfind("Blade", vehiclename,true,0) != -1) pvmid = 536;
	if(strfind("Freight Train", vehiclename,true,0) != -1) pvmid = 537;
	if(strfind("Brownstreak Train", vehiclename,true,0) != -1) pvmid = 538;
	if(strfind("Vortex", vehiclename,true,0) != -1) pvmid = 539;
	if(strfind("Vincent", vehiclename,true,0) != -1) pvmid = 540;
	if(strfind("Bullet", vehiclename,true,0) != -1) pvmid = 541;
	if(strfind("Clover", vehiclename,true,0) != -1) pvmid = 542;
	if(strfind("Sadler", vehiclename,true,0) != -1) pvmid = 543;
	if(strfind("Firetruck LA", vehiclename,true,0) != -1) pvmid = 544;
	if(strfind("Hustler", vehiclename,true,0) != -1) pvmid = 545;
	if(strfind("Intruder", vehiclename,true,0) != -1) pvmid = 546;
	if(strfind("Primo", vehiclename,true,0) != -1) pvmid = 547;
	if(strfind("Cargobob", vehiclename,true,0) != -1) pvmid = 548;
	if(strfind("Tampa", vehiclename,true,0) != -1) pvmid = 549;
	if(strfind("Sunrise", vehiclename,true,0) != -1) pvmid = 550;
	if(strfind("Merit", vehiclename,true,0) != -1) pvmid = 551;
	if(strfind("Utility Van", vehiclename,true,0) != -1) pvmid = 552;
	if(strfind("Nevada", vehiclename,true,0) != -1) pvmid = 553;
	if(strfind("Yosemite", vehiclename,true,0) != -1) pvmid = 554;
	if(strfind("Windsor", vehiclename,true,0) != -1) pvmid = 555;
	if(strfind("MonsterA", vehiclename,true,0) != -1) pvmid = 556;
	if(strfind("MonsterB", vehiclename,true,0) != -1) pvmid = 557;
	if(strfind("Uranus", vehiclename,true,0) != -1) pvmid = 558;
	if(strfind("Jester", vehiclename,true,0) != -1) pvmid = 559;
	if(strfind("Sultan", vehiclename,true,0) != -1) pvmid = 560;
	if(strfind("Stratum", vehiclename,true,0) != -1) pvmid = 561;
	if(strfind("Elegy", vehiclename,true,0) != -1) pvmid = 562;
	if(strfind("Raindance", vehiclename,true,0) != -1) pvmid = 563;
	if(strfind("RC Tiger", vehiclename,true,0) != -1) pvmid = 564;
	if(strfind("Flash", vehiclename,true,0) != -1) pvmid = 565;
	if(strfind("Tahoma", vehiclename,true,0) != -1) pvmid = 566;
	if(strfind("Savanna", vehiclename,true,0) != -1) pvmid = 567;
	if(strfind("Bandito", vehiclename,true,0) != -1) pvmid = 568;
	if(strfind("Freight Flat Trailer", vehiclename,true,0) != -1) pvmid = 569;
	if(strfind("Streak Trailer", vehiclename,true,0) != -1) pvmid = 570;
	if(strfind("Kart", vehiclename,true,0) != -1) pvmid = 571;
	if(strfind("Mower", vehiclename,true,0) != -1) pvmid = 572;
	if(strfind("Dune", vehiclename,true,0) != -1) pvmid = 573;
	if(strfind("Sweeper", vehiclename,true,0) != -1) pvmid = 574;
	if(strfind("Broadway", vehiclename,true,0) != -1) pvmid = 575;
	if(strfind("Tornado", vehiclename,true,0) != -1) pvmid = 576;
	if(strfind("AT400", vehiclename,true,0) != -1) pvmid = 577;
	if(strfind("DFT30", vehiclename,true,0) != -1) pvmid = 578;
	if(strfind("Huntley", vehiclename,true,0) != -1) pvmid = 579;
	if(strfind("Stafford", vehiclename,true,0) != -1) pvmid = 580;
	if(strfind("BF400", vehiclename,true,0) != -1) pvmid = 581;
	if(strfind("Newsvan", vehiclename,true,0) != -1) pvmid = 582;
	if(strfind("Tug", vehiclename,true,0) != -1) pvmid = 583;
	if(strfind("Petrol Trailer", vehiclename,true,0) != -1) pvmid = 584;
	if(strfind("Emperor", vehiclename,true,0) != -1) pvmid = 585;
	if(strfind("Wayfarer", vehiclename,true,0) != -1) pvmid = 586;
	if(strfind("Euros", vehiclename,true,0) != -1) pvmid = 587;
	if(strfind("Hotdog", vehiclename,true,0) != -1) pvmid = 588;
	if(strfind("Club", vehiclename,true,0) != -1) pvmid = 589;
	if(strfind("Freight Box Trailer", vehiclename,true,0) != -1) pvmid = 590;
	if(strfind("Article Trailer 3", vehiclename,true,0) != -1) pvmid = 591;
	if(strfind("Andromada", vehiclename,true,0) != -1) pvmid = 592;
	if(strfind("Dodo", vehiclename,true,0) != -1) pvmid = 593;
	if(strfind("RCCam", vehiclename,true,0) != -1) pvmid = 595;
	if(strfind("Launch", vehiclename,true,0) != -1) pvmid = 595;
	if(strfind("Police Car LSPD", vehiclename,true,0) != -1) pvmid = 596;
	if(strfind("Police Car SFPP", vehiclename,true,0) != -1) pvmid = 597;
	if(strfind("Police Car LVPD", vehiclename,true,0) != -1) pvmid = 598;
	if(strfind("Police Ranger", vehiclename,true,0) != -1) pvmid = 599;
	if(strfind("Picador", vehiclename,true,0) != -1) pvmid = 600;
	if(strfind("S.W.A.T. SWAT", vehiclename,true,0) != -1) pvmid = 601;
	if(strfind("Alpha", vehiclename,true,0) != -1) pvmid = 602;
	if(strfind("Phoenix", vehiclename,true,0) != -1) pvmid = 603;
	if(strfind("Glendale Shit", vehiclename,true,0) != -1) pvmid = 604;
	if(strfind("Sadler Shit", vehiclename,true,0) != -1) pvmid = 605;
	if(strfind("Baggage Trailer A", vehiclename,true,0) != -1) pvmid = 606;
	if(strfind("Baggage Trailer B", vehiclename,true,0) != -1) pvmid = 607;
	if(strfind("Tug Stairs Trailer", vehiclename,true,0) != -1) pvmid = 608;
	if(strfind("Boxville", vehiclename,true,0) != -1) pvmid = 609;
	if(strfind("Farm Trailer", vehiclename,true,0) != -1) pvmid = 610;
	if(strfind("Utility Trailer", vehiclename,true,0) != -1) pvmid = 611;

	if(strlen(vehiclename) == 3 && strval(vehiclename) >= 400 && strval(vehiclename) <= 611) pvmid = strval(vehiclename);
	if(pvmid == 0) return SendClientMessage(playerid, 0xFF6347FF, "[ERRO]:{FFFFFF} Modelo inválido, não foi possíel criar o veículo.");
	new Float:pVposX, Float:pVposY, Float:pVposZ, Float:pVposFA;
	GetPlayerPos(playerid, pVposX, pVposY, pVposZ);
	GetPlayerFacingAngle(playerid, pVposFA);
	if(IsPlayerInAnyVehicle(playerid))
	{
	    new VID;
	    VID = GetPlayerVehicleID(playerid);
	    GetVehicleZAngle(VID, pVposFA);
	}
	new CVID, pVW, pINT;
	pVW = GetPlayerVirtualWorld(playerid);
	pINT = GetPlayerInterior(playerid);
	//DeletePlayerVehicle(playerid);
	CVID = CreateVehicle(pvmid, pVposX, pVposY, pVposZ+0.6, pVposFA,color1,color2,0);
	SetVehicleVirtualWorld(CVID, pVW);
	LinkVehicleToInterior(CVID, pINT);
	SetVehicleHealth(CVID, Health);
	PutPlayerInVehicle(playerid,CVID,0);
	P_DATA_VEH[playerid][vehicle] = CVID;
	return CVID;
}

stock DeletePlayerVehicle(playerid)
{
	new CVID;
	CVID = P_DATA_VEH[playerid][vehicle];
	SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	DestroyVehicle(CVID);
	return true;
}
