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
new str[500];
new lotteryon;
new pname[MAX_PLAYER_NAME];
new already;

public OnPlayerConnect(playerid)
{
    already = 0;
    return 1;
}

CMD:startlottery(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You are not authorized to use this command!");

    if(lotteryon == 1) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}The lottery system is already started!");

    else{

        GetPlayerName(playerid, pname,sizeof(pname));
        format(str, sizeof(str), "{E22626}- {ffff00}AS {E22626}- %s(%d) has started a lottery event!", pname, playerid);
        SCMA(-1, str);
        GameTextForAll("~r~Lottery ~y~Started! ~g~/lottery", 5000, 3);
        lotteryon = 1;
    }
    return 1;
}
CMD:lottery(playerid, params[])
{
    if(already == 1) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You have already joined it!");

    if(lotteryon == 0) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}There is no lottery event running");

    if(GetPlayerMoney(playerid) < 5000) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You don't have enough money!");

    new rand = random(50) + 1;
    new number;

    if(sscanf(params, "i", number)) return SCM(playerid, -1, "{ffff00}[LOTTERY]: {00ff00}/lottery [1-50]");

    if(number < 1 || number > 50) return SCM(playerid, -1, "{ffff00}[LOTTERY]: {00ff00}The number must be from 1 to 50");

    if(lotteryon == 1)
    {
        SCM(playerid, -1, "{ffff00}[LOTTERY]: {00ff00}You have bought a ticket for 2500$!");
        GivePlayerMoney(playerid, -2500);
        already = 1;
    }

    if(number == rand)
    {
        new pname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, pname, sizeof(pname));

        GivePlayerMoney(playerid, 15000);

        SCM(playerid, -1, "{ffff00}[LOTTERY]: {00ff00}You have won the lottery event!");

        format(str, sizeof(str), "{ffff00}[LOTTERY]: {00ff00}%s has won the lottery event with 15000$", pname);
        SCMA(-1, str);

        already = 0;
        lotteryon = 0;
    }

    if(number != rand)
    {
        SCM(playerid, -1, "{ffff00}[LOTTERY]: {00ff00}Incorrect number Try again later!");

        already = 0;
        lotteryon = 0;   
    }
    return 1;
}

CMD:endlottery(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You are not authorized to use this command!");
    
    if(lotteryon == 0) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}There is no lottery event running");

    else{

        GetPlayerName(playerid, pname,sizeof(pname));

        already = 0;
        lotteryon = 0;

        format(str,sizeof(str), "{E22626}- {ffff00}AS {E22626}- %s(%d) has ended the lottery event!", pname, playerid);
        SCMA(-1, str);
    }
    return 1;
}