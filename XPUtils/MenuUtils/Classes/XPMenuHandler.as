class XPMenuHandler : IXPMenuHandler
{
	XPMenuHandler() {}
	XPMenuHandler(XPMenu@ imenu)
	{
		@this.menu = @imenu;
	}
	XPMenuHandler(XPMenu@ imenu, any@ handlerInfo) 
	{
		@this.menu = @imenu;
		@this.Info = @handlerInfo;
	}
	private any@ info;
	any@ Info
	{
		get
		{
			return info;
		}
		set
		{
			@info = @value;
		}
	}
	private XPMenu@ menu;
	XPMenu@ Menu
	{
		get 
		{
			return menu;
		}
	}
	void SetParent(XPMenu@ menu)
	{
		@this.menu = @menu;
	}
	void OnSetTitle(XPMenuTextReturn@ title, CBasePlayer@ cPlayer)
	{
		if(this.menu.OnSetTitle !is null)
		{
			if(this.menu.OnSetTitle(@this.menu, @cPlayer, @title) == HOOK_HANDLED)
			{
				return;
			}
		}
		if(this.Menu.Title.IsEmpty())
		{
			title = "XPMenuSystem ";
		}
		else
		{
			title = this.Menu.Title;
		}
	}
	bool OnItemAdded(IXPMenuItem@ item, XPMenuTextReturn@ menuText, CBasePlayer@ cPlayer, int pageIndex, int menuIndex)
	{
		if(item.OnAddedToMenu_Trigger(@cPlayer, @menuText, pageIndex, menuIndex) == HOOK_HANDLED) return false;
		if(this.menu.OnItemAdded !is null)
		{
			if(this.menu.OnItemAdded(@this.menu, @item, @menuText, @cPlayer, pageIndex, menuIndex) == HOOK_HANDLED) return false;
		}
		//cPlayer be have a value if set  this.Options.RerefshMenuForEachPlayer is true
		bool isempty = menuText.IsEmpty();
		if(item.GetSelected(cPlayer))
		{
			menuText = "[x]" + menuText;
		}
	
		if(item.IsMenu)
		{
			if(isempty)
			{
				menuText += item.Title;
			}
			else
			{
				menuText += item.Text;
			}
			menuText += "->";
		}
		else
		{
			if(isempty)
			{
				menuText += item.Text;
			}

		}
		return true;
	}
	bool OnMenuShown(CBasePlayer@ cPlayer, XPMenuReturn2Int@ menuDislayType)
	{
		return true;
	}
	bool OnUnregister()
	{
		return true;
	}
	bool OnRegister(CBasePlayer@ cPlayer)
	{
		//cPlayer be have a value if set  this.Options.RerefshMenuForEachPlayer is true
		return true;
	}
	bool OnUpperItemAdded(XPMenuTextReturn@ menuText, CBasePlayer@ cPlayer, int pageIndex, int menuIndex)
	{
		//cPlayer be have a value if set  this.Options.RerefshMenuForEachPlayer is true
		menuText = "<- Go Up";
		return true;
	}
	bool OnEmptyItemAdded(XPMenuTextReturn@ menuText, CBasePlayer@ cPlayer, int pageIndex, int menuIndex)
	{
		menuText = "";
		return true;
	}
	bool OnMenuExit(CBasePlayer@ cPlayer)
	{
		return true;
	}
	bool OnItemSelected(CBasePlayer@ cPlayer, IXPMenuItem@ item)
	{
		if(item.Selectable) 
		{
			bool currentState = item.GetSelected(@cPlayer);
			if(this.menu.MaxSelection > 0 && !currentState)
			{
				if(this.menu.GetSelectedItemsCount(@cPlayer) >= this.menu.MaxSelection) return true; 
			}
			item.SetSelected(@cPlayer, !currentState);
		}
		if(item.OnMenuItemSelected_Trigger(@cPlayer) == HOOK_HANDLED) return false;
		return true;
	}
	bool OnUpItemSelected(CBasePlayer@ cPlayer)
	{
		return true;
	}
	bool OnEmptyItemSelected(CBasePlayer@ cPlayer)
	{
		return true;
	}
}