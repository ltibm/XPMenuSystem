funcdef HookReturnCode OnAddedToMenuHandler(CBasePlayer@, IXPMenuItem@, XPMenuTextReturn@, int, int);
class XPMenuItem : IXPMenuItem
{
	XPMenuItem() {}
	XPMenuItem(string text, array<string> params = {}, any@ info = null, OnMenuItemSelectedHandler@ onselected = null)
	{
		this.Text = text;
		this.extraParams = params;
		@this.OnMenuItemSelected = @onselected;
		@this.Info = @info;
	}
	private array<bool> selectedState(33);
	bool IsMenu
	{
		get const
		{
			return false;
		}
	}
	private XPMenu@ parentMenu;
	XPMenu@ ParentMenu
	{
		get
		{
			return parentMenu;
		}
		set
		{
			@parentMenu = @value;
		}
	}
	private string text;
	string Text
	{
		get const
		{
			return text;
		}
		set
		{
			text = value;
		}
	}
	private string title;
	string Title
	{
		get const
		{
			return title;
		}
		set
		{
			title = value;
		}
	}
	private string name;
	string Name
	{
		get const
		{
			return name;
		}
		set
		{
			name = value;
		}
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
	private int index;
	int Index
	{
		get const
		{
			return index;
		}
		set
		{
			index = value;
		}
	}
	private array<string> extraParams;
	array<string>& ExtraParams
	{
		get 
		{
			return extraParams;
		}
		set
		{
			extraParams = value;
		}
	}

	private OnMenuItemSelectedHandler@ onMenuItemSelected;
	OnMenuItemSelectedHandler@ OnMenuItemSelected
	{
		get
		{
			return onMenuItemSelected;
		}
		set
		{
			@onMenuItemSelected = @value;
		}
	}
	private OnAddedToMenuHandler@ onAddedToMenu;
	OnAddedToMenuHandler@ OnAddedToMenu
	{
		get
		{
			return onAddedToMenu;
		}
		set
		{
			@onAddedToMenu = @value;
		}
	}
	private bool selectable;
	bool Selectable
	{
		get const
		{
			return selectable;
		}
		set
		{
			selectable = value;
		}
	}
	HookReturnCode OnMenuItemSelected_Trigger(CBasePlayer@ cPlayer)
	{
		if(this.OnMenuItemSelected !is null)
		{
			return this.OnMenuItemSelected(@cPlayer, @this);
		}
		return HOOK_CONTINUE;
	}
	bool opEquals(IXPMenuItem@  other)
	{
		return this !is null && @this == @other;
	}
	bool GetSelected(CBasePlayer@ cPlayer)
	{
		if(cPlayer is null)
		{
			return selectedState[0];
		}
		return selectedState[cPlayer.entindex()];
	}
	void SetSelected(CBasePlayer@ cPlayer, bool value)
	{
		if(cPlayer is null)
		{
			selectedState[0] = value;
			return;
		}
		selectedState[cPlayer.entindex()] = value;
	}
	void ClearAllSelectedState()
	{
		selectedState.resize(33);
	}
	HookReturnCode OnAddedToMenu_Trigger(CBasePlayer@ cPlayer, XPMenuTextReturn@ itemText, int pageIndex, int menuIndex)
	{
		if(this.OnAddedToMenu !is null)
		{
			return this.OnAddedToMenu(@cPlayer, @this, @itemText, pageIndex, menuIndex);
		}
		return HOOK_CONTINUE;
	}
}