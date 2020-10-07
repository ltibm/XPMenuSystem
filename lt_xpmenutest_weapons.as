#include "../XPUtils/MenuUtils/XPMenuSystem"
array<string> weaponsList =
{
	"weapon_displacer",
	"weapon_medkit",
	"weapon_crowbar",
	"weapon_grapple",
	"weapon_pipewrench",
	"weapon_eagle",
	"weapon_uzi",
	"weapon_rpg",
	"weapon_gauss",
	"weapon_egon",
	"weapon_handgrenade",
	"weapon_tripmine",
	"weapon_satchel",
	"weapon_snark",
	"weapon_m16",
	"weapon_m249"
};
void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor( "Lt." );
	g_Module.ScriptInfo.SetContactInfo( "https://steamcommunity.com/id/ibmlt/" );
	//CreateTemporaryScriptFile();
	g_Hooks.RegisterHook( Hooks::Player::ClientSay, @ClientSay );
}
HookReturnCode ClientSay( SayParameters@ pParams )
{		
	//TestMenu();
	const CCommand@ args    = pParams.GetArguments();
	if(args.ArgC() < 1 || g_PlayerFuncs.AdminLevel(pParams.GetPlayer()) <= 0) return HOOK_CONTINUE;
	if(args[0] == "/give_weapon_test")
	{
		ShowWeaponsMenu(pParams.GetPlayer());
		pParams.ShouldHide = true;
	}
	return HOOK_CONTINUE;
}
void ShowWeaponsMenu(CBasePlayer@ cPlayer)
{
	XPMenu@ menu = @XPMenu();
	menu.Title = "Select Weapons";
	@menu.OnSetTitle = @OnSetTitle;
	
	//Adding sub menu
	XPMenu@ giveToPlayerItem = XPMenu();
	giveToPlayerItem.Title = "Give To Players";
	//This is contents loads after item selected.
	@giveToPlayerItem.OnMenuLazyInit = @OnPlayersMenuInitializator;
	@giveToPlayerItem.OnMenuItemSelected = @OnGiveToPlayerSelected;
	IXPMenuItem@ clearItem = menu.AddItem("Clear Selection");
	@clearItem.OnMenuItemSelected = @OnClearItemSelected;
	menu.AddItem(@giveToPlayerItem);
	//Every 6. menu item
	menu.SetItemSlot(5, @clearItem);
	//Every 7. menu item
	menu.SetItemSlot(6, @giveToPlayerItem);
	for(uint i = 0; i < weaponsList.length(); i++)
	{
		menu.AddNamedItem(weaponsList[i], weaponsList[i]).Selectable = true;
	}
	menu.Open(@cPlayer);
}
HookReturnCode OnSetTitle(XPMenu@ menu, CBasePlayer@ cPlayer, XPMenuTextReturn@ title)
{
	title = menu.Title + "(" + menu.GetSelectedItemsCount(@cPlayer) + ") ";
	return HOOK_HANDLED;
}
HookReturnCode OnClearItemSelected(CBasePlayer@ cPlayer, IXPMenuItem@ item)
{
	//Set all selected values to false
	item.ParentMenu.SetAllSelectedValue(@cPlayer, false);
	return HOOK_CONTINUE;
}
HookReturnCode OnGiveToPlayerSelected(CBasePlayer@ cPlayer, IXPMenuItem@ item)
{
	if(item.ParentMenu.GetSelectedItemsCount(@cPlayer) == 0)
	{	
		//Show current menu if not players selected;
		item.ParentMenu.ShowAgain(@cPlayer);
		return HOOK_HANDLED;
	}
	return HOOK_CONTINUE;
}
bool OnPlayersMenuInitializator(XPMenu@ menu)
{
	int totalPlayers = 0;
	IXPMenuItem@ giveItem = menu.AddItem("Give Now!");
	//menu.MaxSelection = 5;
	menu.SetItemSlot(5, @giveItem);
	IXPMenuItem@ clearItem = menu.AddItem("Clear Selection");
	@clearItem.OnMenuItemSelected = @OnClearItemSelected;
	menu.AddItem(@clearItem);
	//Every 5. menu item
	menu.SetItemSlot(4, @clearItem);
	@giveItem.OnMenuItemSelected = @OnGiveNowSelected;
	
    for (int i = 1; i <= g_Engine.maxClients; i++) {
        CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
        if (pPlayer is null || !pPlayer.IsPlayer() or !pPlayer.IsConnected()) {
            continue;
        }
		menu.AddNamedItem(pPlayer.entindex(), pPlayer.pev.netname).Selectable = true;
		totalPlayers++;
    }
	return totalPlayers > 0;
}
HookReturnCode OnGiveNowSelected(CBasePlayer@ cPlayer, IXPMenuItem@ item)
{
	XPMenu@ baseMenu = item.ParentMenu.GetBaseMenu();
	if(baseMenu is null) return HOOK_CONTINUE;
	XPMenu@ parentMenu = @item.ParentMenu;
	array<IXPMenuItem@> selectedPlayers = parentMenu.GetSelectedItems(@cPlayer);
	array<IXPMenuItem@> selectedItems =  baseMenu.GetSelectedItems(@cPlayer);
	//HOOK_HANDLED not shown menu again;
	if(selectedPlayers.length() == 0 || selectedItems.length() == 0) return HOOK_CONTINUE;
	for(uint i = 0; i < selectedItems.length(); i++)
	{
		string weaponName = selectedItems[i].Name;
		for(uint j = 0; j < selectedPlayers.length(); j++)
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(atoi(selectedPlayers[j].Name));
			if(pPlayer is null || !pPlayer.IsConnected() || !pPlayer.IsAlive()) continue;
			pPlayer.GiveNamedItem(weaponName);
		}
	}
	return HOOK_CONTINUE;
}