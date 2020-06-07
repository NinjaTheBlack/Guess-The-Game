/*
Guess The Number System Made by Axye#5245

Version: 5.0
*/

#include <a_samp>
#include <sscanf2>
#include <zcmd>
#define SCM SendClientMessage
#define SCMA SendClientMessageToAll

#define prize 15000    //Change if you want another value
#define ticket 2500   //Change if you want another value
#define score 5      //Change if you want another value
#define gtntimer 60000*3 // Change if you want another value (= 3 minutes)

new str[500], gtnon, pname[MAX_PLAYER_NAME], rand;

static bool:PlayerGuessedWrong[MAX_PLAYERS] = {false, ...};

forward _ThreeMinTimer( );
public _ThreeMinTimer( ) {

    gtnon = !gtnon;

    if(gtnon == 1) {
      Startgtn();
    }

    else if (gtnon == 0) {
      Endgtn();
    }
    return ( true );
}

public OnFilterScriptInit()
{
    print("       GuessTheNumber made by Axye loaded.");
    SetTimer( "_ThreeMinTimer", gtntimer, true);
    return 1;
}


public OnFilterScriptExit()
{
    print("     GuessTheNumber made by Axye unloaded.");

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
    if(PlayerGuessedWrong[playerid]) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You have already guessed.");

    if(gtnon == 0) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}There is no GTN event running");

    if(GetPlayerMoney(playerid) < ticket) return SCM(playerid, -1, "{E22626}[ERROR]: {C3C2C2}You don't have enough money!");

    new number;

    if(sscanf(params, "i", number)) return SCM(playerid, -1, "{ffff00}[GTN]: {00ff00}/guess [1-50]");

    if(number < 1 || number > 50) return SCM(playerid, -1, "{ffff00}[GTN]: {00ff00}The number must be from 1 to 50");

    if(number == rand)
    {
        GetPlayerName(playerid, pname, sizeof(pname));

        GivePrize(playerid);

        SCM(playerid, -1, "{ffff00}[GTN]: {00ff00}You have guessed the correct number!");

        format(str, sizeof(str), "{FF0000}[GTN]: {FFFFFF}%s(%d) has guessed the correct number (%d) and won %d$ and %d score!", pname, playerid, number, prize, score);
        SCMA(-1, str);

        gtnon = 0;
        TurnOff();
    }

    if(number != rand)
    {

        format(str,sizeof(str), "{ffff00}[GTN]: {00ff00}You have bought a ticket for %d$!", ticket);
        SCM(playerid, -1, str);
        GivePlayerMoney(playerid, -ticket);

        SCM(playerid, -1, "{ffff00}[GTN]: {FF0000}Incorrect number Try again later!");

        PlayerGuessedWrong[playerid] = true;
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

        gtnon = 0;

        TurnOff();

        format(str,sizeof(str), "{E22626}- {ffff00}AS {E22626}- %s(%d) has ended the GTN event!", pname, playerid);
        SCMA(-1, str);

    }
    return 1;
}
stock GivePrize(playerid)
{
    GivePlayerMoney(playerid, prize);
    SetPlayerScore(playerid, GetPlayerScore(playerid) + score);
    return 1;
}
stock Startgtn()
{
  SCMA(-1, "{E22626}- {ffff00}AS {E22626}- Guess The Number event has been started!");
  GameTextForAll("~r~GTN ~y~Started! ~g~/guess", 5000, 3);
  gtnon = 1;

  rand = random(50) + 1;
  return 1;
}
stock TurnOff()
{
  for(new i = 0; i < MAX_PLAYERS; i++)
  {
      PlayerGuessedWrong[i] = false;
  }
  return 1;
}
stock Endgtn()
{
  gtnon = 0;

  SCMA(-1, "{E22626}- {ffff00}AS {E22626}- Guess the Number event has been ended. Restarting in 3 minutes!");

  for(new i = 0; i < MAX_PLAYERS; i++)
  {
      PlayerGuessedWrong[i] = false;
  }
  return 1;
}
