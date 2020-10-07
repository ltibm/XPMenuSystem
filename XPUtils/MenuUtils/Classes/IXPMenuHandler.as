interface IXPMenuHandler
{
	XPMenu@ Menu {get;}
	any@ Info {get; set;}
	void OnSetTitle(XPMenuTextReturn@, CBasePlayer@);
	bool OnItemAdded(IXPMenuItem@, XPMenuTextReturn@, CBasePlayer@, int, int);
	bool OnUpperItemAdded(XPMenuTextReturn@, CBasePlayer@, int, int);
	bool OnEmptyItemAdded(XPMenuTextReturn@, CBasePlayer@, int, int);
	bool OnMenuShown(CBasePlayer@, XPMenuReturn2Int@);
	bool OnUnregister();
	bool OnRegister(CBasePlayer@);
	void SetParent(XPMenu@ menu);
	bool OnMenuExit(CBasePlayer@);
	bool OnItemSelected(CBasePlayer@, IXPMenuItem@);
	bool OnUpItemSelected(CBasePlayer@);
	bool OnEmptyItemSelected(CBasePlayer@);
}