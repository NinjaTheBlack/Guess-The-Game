/*
Guess The Number System Made by Axye#5245

Version: 2.0
*/


#include <a_samp>
#include <sscanf2>
#include <zcmd>
#define SCM SendClientMessage
#define SCMA SendClientMessageToAll
#define prize 15000    //Change if you want another value
#define ticket 2500   //Change if you want another value
new str[500];
new gtnon;
new pname[MAX_PLAYER_NAME];
new already;
new gtnplayer;
new rand;


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
        
        rand = random(50) + 1;
    }
    return 1;
}
CMD:guess(playerid, params[])
{
    if(already == 1) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You have already joined it!");

    if(gtnon == 0) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}There is no GTN event running");

    if(GetPlayerMoney(playerid) < ticket) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You don't have enough money!");

    
    new number;

    if(gtnplayer == 1) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You have already used your try!");

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

        format(str, sizeof(str), "{FF0000}[GTN]: {FFFFFF}%s(%d) has guessed the correct number (%d) and won 15000$", pname, playerid, number);
        SCMA(-1, str);

        already = 0;
        gtnon = 0;
        gtnplayer = 0;
    }

    if(number != rand)
    {
        SCM(playerid, -1, "{ffff00}[GTN]: {FF0000}Incorrect number Try again later!");
        
        already = 0;
        gtnplayer = 1;
    }
    return 1;
}
CMD:reveal(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You are not authorized to use this command!");

    if(gtnon == 0) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}There is no GTN event running");

    else
    {
        format(str, sizeof(str), "{9fbfdf}The Number is %d", rand);
        SCM(playerid, -1, str);
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
        gtnplayer = 0;

        format(str,sizeof(str), "{E22626}- {ffff00}AS {E22626}- %s(%d) has ended the GTN event!", pname, playerid);
        SCMA(-1, str);
    }
    return 1;
}