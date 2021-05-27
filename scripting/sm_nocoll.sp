#include <sourcemod>
#include <sdkhooks>
#include <cstrike>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
    name        = "SM No Collision",
    author      = "rdbo",
    description = "Disable Player Collision",
    version     = "1.0.0",
    url         = ""
};

enum
{
    COLLISION_GROUP_NONE = 0,           //Default; collides with static and dynamic objects
    COLLISION_GROUP_DEBRIS,             //Collides with nothing but world and static stuff
    COLLISION_GROUP_DEBRIS_TRIGGER,     //Same as debris, but hits triggers
    COLLISION_GROUP_INTERACTIVE_DEBRIS, //Collides with everything except other interactive debris or debris
    COLLISION_GROUP_INTERACTIVE,        //Collides with everything except interactive debris or debris
    COLLISION_GROUP_PLAYER,             //Collision group for player
    COLLISION_GROUP_BREAKABLE_GLASS,    //Special group for glass debris
    COLLISION_GROUP_VEHICLE,            //Collision group for driveable vehicles
    COLLISION_GROUP_PLAYER_MOVEMENT,    //For singleplayer, same as Collision_Group_Player, for multiplayer, this filters out other players and CBaseObjects
    COLLISION_GROUP_NPC,                //Generic NPC group
    COLLISION_GROUP_IN_VEHICLE,         //For any entity inside a vehicle
    COLLISION_GROUP_WEAPON,             //For any weapons that need collision detection
    COLLISION_GROUP_VEHICLE_CLIP,       //vehicle clip brush to restrict vehicle movement
    COLLISION_GROUP_PROJECTILE,         //Projectiles
    COLLISION_GROUP_DOOR_BLOCKER,       //Blocks entities not permitted to get near moving doors
    COLLISION_GROUP_PASSABLE_DOOR,      //Doors that the player shouldn't collide with
    COLLISION_GROUP_DISSOLVING,         //Things that are dissolving are in this group
    COLLISION_GROUP_PUSHAWAY            //Nonsolid on client and server, pushs player away
};

ConVar g_cvNoCollEnabled;

public Action HkPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_cvNoCollEnabled.BoolValue)
        return Plugin_Continue;
    
    int client = GetClientOfUserId(event.GetInt("userid"));
    
    if (!client)
        return Plugin_Continue;
    
    int collision_group = GetEntProp(client, Prop_Data, "m_CollisionGroup");
    collision_group &= ~(COLLISION_GROUP_PLAYER | COLLISION_GROUP_PLAYER_MOVEMENT | COLLISION_GROUP_NPC);
    SetEntProp(client, Prop_Data, "m_CollisionGroup", collision_group);
    
    return Plugin_Continue;
}

public void OnPluginStart()
{
    PrintToServer("[SM] NoColl Loaded");
    g_cvNoCollEnabled = CreateConVar("sm_nocoll_enabled", "1", "Enable NoColl");
}
