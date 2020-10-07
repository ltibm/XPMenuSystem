interface IXPMenuItem
{
	string Title { get const; set; }
	string Text { get const; set; }
	string Name {get const; set;}
	any@ Info {get; set;}
	XPMenu@ ParentMenu {get; set;}
	int Index {get const; set;}
	array<string>& ExtraParams {get; set;}
	bool IsMenu {get const;}
	OnMenuItemSelectedHandler@ OnMenuItemSelected {get; set;}
	OnAddedToMenuHandler@ OnAddedToMenu {get; set;}
	HookReturnCode OnMenuItemSelected_Trigger(CBasePlayer@);
	bool opEquals(IXPMenuItem@ other);
	bool GetSelected(CBasePlayer@);
	void SetSelected(CBasePlayer@, bool);
	bool Selectable {get const; set;}
	HookReturnCode OnAddedToMenu_Trigger(CBasePlayer@, XPMenuTextReturn@, int, int);
	void ClearAllSelectedState();
}