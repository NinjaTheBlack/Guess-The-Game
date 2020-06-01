/*
Guess The Game System Made by Axye#5245

Version: 1.0
*/


#include <a_samp>
#include <sscanf2>
#include <zcmd>
#define SCM SendClientMessage
#define SCMA SendClientMessageToAll
#define red "{E22626}"
#define green 0x00FF00FF
#define grey "{C3C2C2}"
#define yellow "{ffff00}"
#define prize 15000
#define ticket 2500
new str[500];
new gtnon;
new pname[MAX_PLAYER_NAME];
new already;

public OnPlayerConnect(playerid)
{
    already = 0;
    return 1;
}

CMD:startgtn(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You are not authorized to use this command!");

    if(gtnon == 1) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}The GTN event is already started!");

    else{

        GetPlayerName(playerid, pname,sizeof(pname));
        format(str, sizeof(str), "{E22626}- {ffff00}AS {E22626}- %s(%d) has started the Guess The Number event!", pname, playerid);
        SCMA(-1, str);
        GameTextForAll("~r~GTN ~y~Started! ~g~/guess", 5000, 3);
        gtnon = 1;
    }
    return 1;
}
CMD:guess(playerid, params[])
{
    if(already == 1) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You have already joined it!");

    if(gtnon == 0) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}There is no GTN event running");

    if(GetPlayerMoney(playerid) < ticket) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You don't have enough money!");

    new rand = random(50) + 1;
    new number;

    if(sscanf(params, "i", number)) return SCM(playerid, -1, "{ffff00}[GTN]: {00ff00}/guess [1-50]");

    if(number < 1 || number > 50) return SCM(playerid, -1, "{ffff00}[GTN]: {00ff00}The number must be from 1 to 50");

    if(gtnon == 1)
    {
        SCM(playerid, -1, "{ffff00}[GTN]: {00ff00}You have bought a ticket for 2500$!");
        GivePlayerMoney(playerid, -ticket);
        already = 1;
    }

    if(number == rand)
    {
        new pname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, pname, sizeof(pname));

        GivePlayerMoney(playerid, prize);

        SCM(playerid, -1, "{ffff00}[GTN]: {00ff00}You have guessed the correct number!");

        format(str, sizeof(str), "{ffff00}[GTN]: {00ff00}%s(%d) has guessed the correct number and won 15000$", pname, playerid);
        SCMA(-1, str);

        already = 0;
        gtnon = 0;
    }

    if(number != rand)
    {
        SCM(playerid, -1, "{ffff00}[GTN]: {00ff00}Incorrect number Try again later!");
        
        already = 0;
    }
    return 1;
}

CMD:endgtn(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You are not authorized to use this command!");
    
    if(gtnon == 0) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}There is no GTN event running");

    else{

        GetPlayerName(playerid, pname,sizeof(pname));

        already = 0;
        gtnon = 0;

        format(str,sizeof(str), "{E22626}- {ffff00}AS {E22626}- %s(%d) has ended the GTN event!", pname, playerid);
        SCMA(-1, str);
    }
    return 1;
}