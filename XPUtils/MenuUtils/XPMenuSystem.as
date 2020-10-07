//XPMenuSystem by Lt.
//https://steamcommunity.com/id/ibmlt/

#include "Classes/_XPMenuUncludes"
namespace XPMenuSystem
{

}
funcdef HookReturnCode OnMenuItemSelectedAnyHandler(XPMenu@, CBasePlayer@, IXPMenuItem@, int, int);
funcdef HookReturnCode OnMenuItemSelectedHandler(CBasePlayer@, IXPMenuItem@);
funcdef HookReturnCode OnMenuExitHandler(XPMenu@, CBasePlayer@);
funcdef HookReturnCode OnSetTitleHandler(XPMenu@, CBasePlayer@, XPMenuTextReturn@);
funcdef HookReturnCode OnItemAddedHandler(XPMenu@, IXPMenuItem@, XPMenuTextReturn@, CBasePlayer@, int, int);
funcdef bool OnMenuLazyInitHandler(XPMenu@);
class XPMenuUserData
{
	int DisplayTime;
	uint LastItemId;
}
class XPMenuTextReturn
{
	XPMenuTextReturn(){}
	XPMenuTextReturn(string text)
	{
		this.ReturnText = text;
	}
	string ReturnText;
	string opImplConv() const  
	{
		return ReturnText;
	}
	XPMenuTextReturn@ opAssign(string obj)
	{
		this.ReturnText = obj;
		return this;
	}		
	bool IsEmpty()
	{
		return this.ReturnText.IsEmpty();
	}
	XPMenuTextReturn@ opAdd(string obj)
	{
		this.ReturnText += obj;
		return this;
	}	
	XPMenuTextReturn@ opAddAssign(string obj)
	{
		this.ReturnText += obj;
		return this;
	}		
}
class XPMenuReturn2Int
{
	XPMenuReturn2Int(){}
	XPMenuReturn2Int(int dsplytime, int dpage)
	{
		this.DisplayTime = dsplytime;
		this.DisplayPage = dpage;
	}
	int DisplayTime;
	int DisplayPage;
}

class XPMenuAnyData
{
	XPMenuAnyData() {}
	XPMenuAnyData(bool upmenu, uint index = 0) {
		this.UpMenu = upmenu;
		this.ItemIndex = index;
	}
	XPMenuAnyData(IXPMenuItem@ item = null, uint index = 0)
	{
		this.ItemIndex = index;
		@this.Item = @item;
	}
	uint ItemIndex;
	IXPMenuItem@ Item;
	bool UpMenu;
	bool IsEmpty
	{
		get const
		{
			return this.Item is null;
		}
	}
}

class XPMenu : XPMenuItem
{
	XPMenu()
	{
		@pmenuHandler = @XPMenuHandler();
		pmenuHandler.SetParent(@this);
		@menuA = @CTextMenu(@TextMenuPlayerSlotCallback(@this.InnerMenuCallBack));
		@this.InnerMenu = @this.menuA;
		@this.Options = @XPMenuOptions();
	}
	array<XPMenuUserData> UserMenuData(33);
	XPMenu(OnMenuItemSelectedAnyHandler@ itemSelected, IXPMenuHandler@ menuHandler = null) 
	{
		if(menuHandler is null)
		{
			@pmenuHandler = @XPMenuHandler();
			return;
		}
		@pmenuHandler = @menuHandler;
		pmenuHandler.SetParent(@this);
		@menuA = @CTextMenu(@TextMenuPlayerSlotCallback(@this.InnerMenuCallBack));
		@this.InnerMenu = @this.menuA;
		@this.OnMenuItemSelectedAny = @itemSelected;
		@this.Options = @XPMenuOptions();
	}
	bool IsMenu
	{
		get const override
		{
			return true;
		}
	}
	private bool isLazyInitial;
	private CTextMenu@ menuA;
	private CTextMenu@ menuB;
	private array<IXPMenuItem@> slotItems(7);
	private OnMenuLazyInitHandler@ onMenuLazyInit;
	OnMenuLazyInitHandler@ OnMenuLazyInit
	{
		get
		{
			return onMenuLazyInit;
		}
		set
		{
			@onMenuLazyInit = @value;
		}
	}
	private XPMenuOptions@ options;
	XPMenuOptions@ Options
	{
		get
		{
			return options;
		}
		set
		{
			@options = @value;
		}
	}	
	
	private OnItemAddedHandler@ onItemAdded;
	OnItemAddedHandler@ OnItemAdded
	{
		get
		{
			return onItemAdded;
		}
		set
		{
			@onItemAdded = @value;
		}
	}
	private OnMenuExitHandler@ onMenuExit;
	OnMenuExitHandler@ OnMenuExit
	{
		get
		{
			return onMenuExit;
		}
		set
		{
			@onMenuExit = @value;
		}
	}
	private OnSetTitleHandler@ onSetTitle;
	OnSetTitleHandler@ OnSetTitle
	{
		get
		{
			return onSetTitle;
		}
		set
		{
			@onSetTitle = @value;
		}
	}
	private OnMenuItemSelectedAnyHandler@ onMenuItemSelectedAny;
	OnMenuItemSelectedAnyHandler@ OnMenuItemSelectedAny
	{
		get
		{
			return onMenuItemSelectedAny;
		}
		set
		{
			@onMenuItemSelectedAny = @value;
		}
	}
	
	
	private uint menuId;
	private CBasePlayer@ playerInfo;
	CBasePlayer@ PlayerInfo
	{
		get
		{
			return playerInfo;
		}
		set
		{
			@playerInfo = @value;
		}
	}
	private CTextMenu@ innerMenu;
	private CTextMenu@ InnerMenu
	{
		get
		{
			return innerMenu;
		}
		set
		{
			@innerMenu = @value;
		}
	}
	private int registeredItemsCount;
	int RegisteredItemsCount
	{
		get const
		{
			return registeredItemsCount;
		}
	}
	bool IsRegistered 
	{
		get
		{
			return this.InnerMenu.IsRegistered();
		}
	}
	TextMenuId_t Id
	{
		get
		{
			return this.InnerMenu.Id;
		}
	}
	uint PageCount 
	{
		get
		{
			return this.InnerMenu.GetPageCount();
		}
	}
	private array<IXPMenuItem@> items;
	array<IXPMenuItem@>& Items
	{
		get
		{
			return items;
		}
	}
	private IXPMenuHandler@ pmenuHandler;
	IXPMenuHandler@ MenuHandler
	{
		get
		{
			return pmenuHandler;
		}
	}
	int ItemCount
	{
		get
		{
			return this.Items.length();
		}
	}
	private int itemsOfPage = 7;
	int ItemsOfPage
	{
		get
		{
			return this.itemsOfPage;
		}
		set
		{
			if(value < 1) value = 1;
			if(value > 7) value = 7;
			this.itemsOfPage = value;
		}
	}
	private uint maxSelection;
	uint MaxSelection
	{
		get
		{
			return this.maxSelection;
		}
		set
		{
			this.maxSelection = value;
		}
	}
	IXPMenuItem@  AddItem(IXPMenuItem@ item)
	{
		item.Index = this.ItemCount;
		@item.ParentMenu = @this;
		this.Items.insertLast(@item);
		if(item.IsMenu)
		{
			XPMenu@ xpmenu = cast<XPMenu@>(@item);
			if(this.Options.AutomaticlyBindCallback)
			{
				if(xpmenu.OnMenuItemSelectedAny is null)
				{
					@xpmenu.OnMenuItemSelectedAny = @this.OnMenuItemSelectedAny;
				}
				if(xpmenu.OnMenuItemSelected is null)
				{
					@xpmenu.OnMenuItemSelected = @this.OnMenuItemSelected;
				}
			}
			if(this.Options.AutomaticlyBindHandler)
			{
				if(xpmenu.MenuHandler is null)
				{
					@xpmenu.pmenuHandler = @this.MenuHandler;
				}
			}

		}
		return @item;
	}
	IXPMenuItem@ AddItem(string text)
	{
		return this.AddItem(XPMenuItem(text));
	}
	IXPMenuItem@ AddItem(string text, OnMenuItemSelectedHandler@ onselected)
	{
		 return this.AddItem(XPMenuItem(text, {}, @null, @onselected));
	}
	IXPMenuItem@ AddItem(string text, any@ info)
	{
		return this.AddItem(XPMenuItem(text, {}, @info));
	}
	IXPMenuItem@ AddItem(string text, any@ info, OnMenuItemSelectedHandler@ onselected)
	{
		return this.AddItem(XPMenuItem(text, {}, @info, @onselected));
	}
	IXPMenuItem@ AddItem(string text, array<string> params)
	{
		return this.AddItem(XPMenuItem(text, params));
	}
	IXPMenuItem@ AddItem(string	text, array<string> params, any@ info)
	{
		return this.AddItem(XPMenuItem(text, params, @info));
	}
	IXPMenuItem@ AddItem(string	text, array<string> params, any@ info, OnMenuItemSelectedHandler@ onselected)
	{
		return this.AddItem(XPMenuItem(text, params, @info, @onselected));
	}
	IXPMenuItem@ AddNamedItem(string name, string text, array<string> params = {}, any@ info = null, OnMenuItemSelectedHandler@ onselected = null)
	{
		IXPMenuItem@ item = XPMenuItem(text, params, @info, @onselected);
		item.Name = name;
		return this.AddItem(@item);
	}
	array<IXPMenuItem@> GetSelectedItems(CBasePlayer@ cPlayer, bool depthsearch = false)
	{
		array<IXPMenuItem@> items;

		for(int i = 0; i < this.ItemCount; i++)
		{
			IXPMenuItem@ item = @this.Items[i];
			if(item.IsMenu && depthsearch)
			{
				XPMenu@ xpmenu = cast<XPMenu@>(@item);
				array<IXPMenuItem@> subItems = xpmenu.GetSelectedItems(@cPlayer, depthsearch);
				for(uint j = 0; j < subItems.length(); j++)
				{
					items.insertLast(@subItems[j]);
				}
			}
			if(item.GetSelected(@cPlayer))
			{
				items.insertLast(@item);
			}
		}
		
		return items;
	}
	uint GetSelectedItemsCount(CBasePlayer@ cPlayer, bool depthsearch = false)
	{
		uint totalItems = 0;
		for(int i = 0; i < this.ItemCount; i++)
		{
			IXPMenuItem@ item = @this.Items[i];
			if(item.IsMenu && depthsearch)
			{
				XPMenu@ xpmenu = cast<XPMenu@>(@item);
				totalItems += xpmenu.GetSelectedItemsCount(@cPlayer, depthsearch);
			}
			
			if(item.GetSelected(@cPlayer))
			{
				totalItems++;
			}
		}
		return totalItems;
	}
	void SetAllSelectedValue(CBasePlayer@ cPlayer, bool value, bool depthsearch = false)
	{
		for(int i = 0; i < this.ItemCount; i++)
		{
			IXPMenuItem@ item = @this.Items[i];
			if(item.IsMenu && depthsearch)
			{
				XPMenu@ xpmenu = cast<XPMenu@>(@item);
				xpmenu.SetAllSelectedValue(@cPlayer, value, depthsearch);
			}
			item.SetSelected(@cPlayer, value);
		}
	}
	void ClearAllSelectionData(bool depthsearch = false)
	{
		for(int i = 0; i < this.ItemCount; i++)
		{
			IXPMenuItem@ item = @this.Items[i];
			if(item.IsMenu && depthsearch)
			{
				XPMenu@ xpmenu = cast<XPMenu@>(@item);
				xpmenu.ClearAllSelectionData(depthsearch);
			}
			item.ClearAllSelectedState();
		}
	}
	void Clear()
	{
		this.Items.resize(0);
		this.ClearSlots();
		this.UnRegister();
		this.isLazyInitial = false;
	}
	void ClearData()
	{
		this.UserMenuData.resize(33);
	}
	void ClearSlots()
	{
		this.slotItems.resize(7);
	}
	private bool ItemCanBeAddedMenu(IXPMenuItem@ menuItem, CBasePlayer@ cPlayer, XPMenuTextReturn@ menuText, int pageIndex, int menuIndex)
	{
		return this.MenuHandler.OnItemAdded(@menuItem, @menuText, @cPlayer, pageIndex, menuIndex);
	}
	void Register(CBasePlayer@ cPlayer = null)
	{
		if(this.Options.RerefshMenuForEachPlayer && cPlayer is null) return;
		if(this.IsRegistered || !this.MenuHandler.OnRegister(@cPlayer)) return;
		XPMenuTextReturn@ p_title = XPMenuTextReturn();
		registeredItemsCount = 0;
		this.MenuHandler.OnSetTitle(@p_title, @cPlayer);
		this.InnerMenu.SetTitle(p_title);
		int pageIndex = 0;
		int lastPassedId = 0;
		for(int i = 0; i < this.ItemCount; i++)
		{
			XPMenuTextReturn@ p_menuText = XPMenuTextReturn();
			IXPMenuItem@ menuItem;
			int slotIndex = this.slotItems.find(@this.Items[i]);
			pageIndex = registeredItemsCount % 7;
			bool isslotItem = false;
			if(pageIndex == 6 && this.ParentMenu !is null && this.AddUpMenuItem(@cPlayer))
			{
				i--;
				continue;
			}
			if(slotIndex >= 0 && pageIndex != slotIndex) continue;
			if(lastPassedId != pageIndex && this.slotItems[pageIndex] !is null)
			{
				@menuItem = @this.slotItems[pageIndex];
				i--;
				isslotItem = true;
			}
			else
			{
				if(pageIndex > this.ItemsOfPage - 1)
				{
					string emptyText;
					XPMenuTextReturn@ p_emptyText = XPMenuTextReturn();
					if(this.MenuHandler.OnEmptyItemAdded(@p_emptyText, @cPlayer, pageIndex, registeredItemsCount))
					{
						i--;
						registeredItemsCount++;
						this.InnerMenu.AddItem(p_emptyText, @any(@XPMenuAnyData(null, registeredItemsCount - 1)));
					}
					continue;
				}
				@menuItem = @this.Items[i];
			}
			if(!ItemCanBeAddedMenu(@menuItem, @cPlayer, @p_menuText, pageIndex, registeredItemsCount))
			{
				if(isslotItem) lastPassedId = pageIndex;
				continue;
			}

			//this.Items[i].MenuIndex = registeredItemsCount;

			registeredItemsCount++;
			this.InnerMenu.AddItem(p_menuText, @any(@XPMenuAnyData(@menuItem, registeredItemsCount - 1)));
		}
		uint emptyCount = 0;
		if(this.Options.AlwaysShowSlotItem)
		{
			for(int i = pageIndex + 1; i < 7; i++)
			{
				if(i == 6 && this.ParentMenu !is null && this.AddUpMenuItem(@cPlayer)) continue;
				if(this.slotItems[i] !is null)
				{
					XPMenuTextReturn@ p_slotText = XPMenuTextReturn();
					if(ItemCanBeAddedMenu(@this.slotItems[i], @cPlayer, @p_slotText, i, registeredItemsCount))
					{
						for(uint j = 0; j < emptyCount; j++)
						{
							XPMenuTextReturn@ p_emptyText = XPMenuTextReturn();
							if(this.MenuHandler.OnEmptyItemAdded(@p_emptyText, @cPlayer, i, registeredItemsCount))
							{
								registeredItemsCount++;
								this.InnerMenu.AddItem(p_emptyText, @any(@XPMenuAnyData(null, registeredItemsCount - 1)));
							}

						}
						
						emptyCount = 0;
						registeredItemsCount++;
						this.InnerMenu.AddItem(p_slotText, @any(@XPMenuAnyData(@this.slotItems[i], registeredItemsCount - 1)));
						continue;
					}

				}
				if(this.Options.ShowSlotItemAtOwnIndexIfNotReached)
				{
					emptyCount++;
				}
			}
		}
		else
		{
			if(pageIndex < 6 && this.ParentMenu !is null)
			{
				this.AddUpMenuItem(@cPlayer);
			}
		}

		this.InnerMenu.Register();
	}
	private bool AddUpMenuItem(CBasePlayer@ cPlayer = null)
	{
		if(!this.Options.ShopUpMenuItem) return false;
		XPMenuTextReturn@ p_uptext = XPMenuTextReturn();
		if(this.MenuHandler.OnUpperItemAdded(@p_uptext, @cPlayer, registeredItemsCount % 7, registeredItemsCount))
		{
			registeredItemsCount++;
			this.InnerMenu.AddItem(p_uptext , @any(@XPMenuAnyData(true, registeredItemsCount - 1)));
			return true;
		}
		return false;
	}
	void UnRegister()
	{
		if(!this.IsRegistered) return;
		if(!this.MenuHandler.OnUnregister()) return;
		this.InnerMenu.Unregister();
		//This is for fix crashing...
		if(this.menuId == 0)
		{
			@this.menuB = @CTextMenu(@TextMenuPlayerSlotCallback(@this.InnerMenuCallBack));
			@this.InnerMenu = @menuB;
			this.menuId = 1;
		}
		else
		{	
			@this.menuA = @CTextMenu(@TextMenuPlayerSlotCallback(@this.InnerMenuCallBack));
			@this.InnerMenu = @menuA;
			this.menuId = 0;
		}
	}
	void Refresh()
	{
		this.UnRegister();
		this.Register();
	}
	//void Open(const int iDisplayTime, const uint page, CBasePlayer@ pPlayer)
	void Open(CBasePlayer@ cPlayer, int time = 0, uint page = 0)
	{
		if(!this.Options.RerefshMenuForEachPlayer)
		{
			if(!this.IsRegistered)
			{
				if(this.Options.AutomaticRegister)
				{
					this.Register();
				}
				else
				{
					return;
				}
			}
		}
		//Show all player
		if(cPlayer is null)
		{
			for(int i = 1; i <= g_Engine.maxClients; i++)
			{
				CBasePlayer@ player = @g_PlayerFuncs.FindPlayerByIndex(i);
				if(player is null) continue;
				Open(@player, time, page);
			}
			return;
		}
		if(!cPlayer.IsPlayer() || !cPlayer.IsConnected()) return;
		if(this.Options.RerefshMenuForEachPlayer)
		{
			this.UnRegister();
			this.Register(@cPlayer);
		}
		if(this.RegisteredItemsCount == 0)
		{
			if(this.Options.ShowBackMenuIfIsMenuHasNotItem)
			{
				if(this.ParentMenu !is null)
				{
					this.ShowParent(@cPlayer);
				}
			}
			return;
		}
		XPMenuReturn2Int@ menuShowType = XPMenuReturn2Int(time, page);
		if(this.MenuHandler.OnMenuShown(@cPlayer, @menuShowType))
		{
			time = menuShowType.DisplayTime;
			page = menuShowType.DisplayPage;
			if(page > this.PageCount - 1) page = this.PageCount - 1;
			int playerId = cPlayer.entindex();
			XPMenuUserData userData = this.UserMenuData[playerId];
			userData.DisplayTime = time; 
			this.UserMenuData[playerId] = userData;
			this.InnerMenu.Open(time, page, @cPlayer);
		}
	}
	void ShowParent(CBasePlayer@ cPlayer)
	{
		if(this.ParentMenu !is null)
		{
			if(this.OnMenuLazyInit !is null && this.Options.AutoClearDataIfOnLazySetted)
			{
				this.Clear();
			}
			if(this.Options.AutomaticRefresh)
			{
				this.ParentMenu.Refresh();
			}
			XPMenuUserData userMenuData = this.ParentMenu.UserMenuData[cPlayer.entindex()];
			uint page = 0;
			if(userMenuData.LastItemId > 6)
			{
				page = uint(Math.Floor(float(userMenuData.LastItemId) / 7.0));
			}
			this.ParentMenu.Open(@cPlayer, userMenuData.DisplayTime, page);
		}
	}
	void ShowAgain(CBasePlayer@ cPlayer)
	{
		if(this.Options.AutomaticRefresh && !this.Options.RerefshMenuForEachPlayer)
		{
			this.Refresh();
		}
		XPMenuUserData userMenuData = this.UserMenuData[cPlayer.entindex()];
		uint page = 0;
		if(userMenuData.LastItemId > 6)
		{
			page = uint(Math.Floor(float(userMenuData.LastItemId) / 7.0));
		}
		this.Open(@cPlayer, userMenuData.DisplayTime, page);
	}
	HookReturnCode OnMenuItemSelectedAny_Trigger(CBasePlayer@ cPlayer, IXPMenuItem@ item, int pageIndex, int totalIndex)
	{
		if(this.OnMenuItemSelectedAny !is null)
		{
			return this.OnMenuItemSelectedAny(@this, @cPlayer, @item, pageIndex, totalIndex); 
		}
		return HOOK_CONTINUE;
	}
	HookReturnCode OnMenuExit_Trigger(CBasePlayer@ cPlayer)
	{
		if(this.OnMenuExit !is null)
		{
			return this.OnMenuExit(@this, @cPlayer);
		}
		return HOOK_CONTINUE;
	}
	void SetItemSlot(uint index, IXPMenuItem@ item)
	{
		if(index > 6) return;
		if(item !is null && this.Items.find(@item) < 0) return;
		@this.slotItems[index] = @item;
	}
	private void InnerMenuCallBack(CTextMenu@ menu, CBasePlayer@ cPlayer, int index, const CTextMenuItem@ item) 
	{
		if(item is null)
		{
			if(this.OnMenuLazyInit !is null && this.ParentMenu !is null && this.Options.AutoClearDataIfOnLazySetted) this.Clear();
			if(!this.MenuHandler.OnMenuExit(@cPlayer) || this.OnMenuExit_Trigger(@cPlayer) == HOOK_HANDLED) return;
			if(this.Options.AutomaticyOpenUpMenuOnExit)
			{
				ShowParent(@cPlayer);
			}
			return;
		}
		if(item.m_pUserData is null)
		{
			return;
		}
		int playerId = cPlayer.entindex();
		IXPMenuItem@ xpmenuItem;
		XPMenuAnyData@ anyData;
		item.m_pUserData.retrieve(@anyData);
		XPMenuUserData userData = this.UserMenuData[playerId];
		userData.LastItemId = anyData.ItemIndex;
		this.UserMenuData[playerId] = userData;
		if(anyData !is null && anyData.IsEmpty && !anyData.UpMenu) 
		{
			if(!this.MenuHandler.OnEmptyItemSelected(@cPlayer)) return;
			this.ShowAgain(@cPlayer);
			return;
		}

		if(anyData !is null && anyData.UpMenu)
		{

			if(!this.MenuHandler.OnUpItemSelected(@cPlayer)) return;
			ShowParent(@cPlayer);
			return;
		}
		if(anyData is null || anyData.Item is null) return;
		if(anyData !is null && !this.MenuHandler.OnItemSelected(@cPlayer, @anyData.Item)) return;
		@xpmenuItem = @anyData.Item;
		if(OnMenuItemSelectedAny_Trigger(@cPlayer, @xpmenuItem, index, anyData.ItemIndex) == HOOK_HANDLED) return;
		if(xpmenuItem.IsMenu)
		{
			XPMenu@ xpmenu = cast<XPMenu@>(@xpmenuItem);
			if(xpmenu.OnMenuLazyInit !is null && !xpmenu.isLazyInitial)
			{
				if(!xpmenu.OnMenuLazyInit(@xpmenu))
				{
					xpmenu.isLazyInitial = true;
					return;
				}
				xpmenu.isLazyInitial = true;
			}
			@xpmenu.ParentMenu = @this;
			xpmenu.Open(@cPlayer);
			return;
		}
		else
		{
			if(this.Options.AutomaticShowAgain)
			{
				this.ShowAgain(@cPlayer);
			}
		}
	}
	XPMenu@ GetBaseMenu()
	{
		XPMenu@ parentMenu = @this.ParentMenu;
		while(parentMenu !is null)
		{
			if(parentMenu.ParentMenu is null) return parentMenu;
			@parentMenu = parentMenu.ParentMenu;
		}
		return null;
	}
}