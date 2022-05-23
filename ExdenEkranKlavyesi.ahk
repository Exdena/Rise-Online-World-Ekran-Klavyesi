/*
--------------------------------
This is a onscreen keyboard for Rise Online World. Missing most features as game blocks it.
It is a modified version of On-Screen Keyboard -- OSK() v1.5  By FeiYue 

Rise Online World için bir ekran klavyesidir. Oyun engellediği için bir çok özellik eksiktir.
On-Screen Keyboard -- OSK() v1.5  By FeiYue codunun değiştirilmiş halidir.


Discord: Exden#9510
--------------------------------
*/


if !A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}
SetBatchLines -1
#NoEnv
#SingleInstance, Force
SendMode, Input 
SetWorkingDir %A_ScriptDir%
SetKeyDelay, 200

;==================MENU==================
Menu, Tray, Tip , Ekran Klavyesi
k_MenuItemHide = Exden Klavyesini Gizle
k_MenuItemShow = Exden Klavyesini Goster
Menu, Tray, Add, Exden Klavyesini Gizle, k_ShowHide
Menu, Tray, Add, Cikis, k_MenuExit
Menu, Tray, Default, Exden Klavyesini Gizle
Menu, Tray, NoStandard
global k_IsVisible := 1

;==================GUI==================
OSK()

OSK() {

  static NewName:={ "":"Space", Caps:"CapsLock"
     , App:"AppsKey", PrScn:"PrintScreen", ScrLk:"ScrollLock"
     , "^":"Up", "|":"Down", "<":"Left", ">":"Right" }
  w1:=45, h1:=30, w2:=60, w3:=w1*14+2*13

  s1:=[ ["Esc"],["F1",,w3-w1*13-15*2-2*9],["F2"],["F3"],["F4"],["F5",,15]
     ,["F6"],["F7"],["F8"],["F9",,15],["F10"],["F11"],["F12"]
     ,["PrScn",w2,10],["ScrLk",w2],["Pause",w2] ]

  s2:=[ ["~ ``"],["! 1"],["@ 2"],["# 3"],["$ 4"],["% 5"],["^ 6"]
     ,["&& 7"],["* 8"],["( 9"],[") 0"],["_ -"],["+ ="],["BS"]
     ,["Ins",w2,10],["Home",w2],["PgUp",w2] ]

  s3:=[ ["Tab"],["q"],["w"],["e"],["r"],["t"],["y"]
     ,["u"],["i"],["o"],["p"],["{ ["],["} ]"],["| \"]
     ,["Del",w2,10],["End",w2],["PgDn",w2] ]

  s4:=[ ["Caps",w2],["a"],["s"],["d"],["f"],["g"],["h"]
     ,["j"],["k"],["l"],[": `;"],[""" '"],["Enter",w3-w1*11-w2-2*12] ]

  s5:=[ ["Shift",w1*2],["z"],["x"],["c"],["v"],["b"]
     ,["n"],["m"],["< :,"],["> ."],["? /"],["Shift",w3-w1*12-2*11]
     ,["^",w2,10+w2+2] ]

  s6:=[ ["Ctrl",w2],["Win",w2],["Alt",w2],["",w3-w2*7-2*7]
     ,["Alt",w2],["Win",w2],["App",w2],["Ctrl",w2]
     ,["<",w2,10],["|",w2],[">",w2] ]

  Gui, OSK: Destroy
  Gui, OSK: +AlwaysOnTop +Owner +E0x08000000
  Gui, OSK: Font, s12, Verdana
  Gui, OSK: Margin, 10, 10
  Gui, OSK: Color, DDEEFF
  Loop, 6 {
    if (A_Index<=2)
      j=
    For i,v in s%A_Index%
    {
      w:=v.2 ? v.2 : w1, d:=v.3 ? v.3 : 2
      j:=j="" ? "xm" : i=1 ? "xm y+2" : "x+" d
      Gui, OSK: Add, Button, %j% w%w% h%h1% -Wrap gRunOSK, % v.1
    }
  }
  Gui, OSK: Show, NA, Exden'nin Ekran Klavyesi          - Exden#9510
  return

  OSKGuiClose:
	Gui, OSK: Destroy
	ExitApp
  return

  RunOSK:
  k:=A_GuiControl
  if k in Shift,Ctrl,Win,Alt
  {
    v:=k="Win" ? "LWin" : k
    GuiControlGet, isEnabled, OSK: Enabled, %k%
    GuiControl, OSK: Disable%isEnabled%, %k%
    if (!isEnabled)
      SendInput, {Blind}{%v%}
    return
  }
  s:=InStr(k," ") ? SubStr(k,0) : k
  s:=(v:=NewName[s]) ? v : s, s:="{" s "}"
  For i,k in StrSplit("Shift,Ctrl,Win,Alt", ",")
  {
    GuiControlGet, isEnabled, OSK: Enabled, %k%
    if (!isEnabled)
    {
      GuiControl, OSK: Enable, %k%
      v:=k="Win" ? "LWin" : k
      s={%v% Down}%s%{%v% Up}
    }
  }
  SendInput %s%
  Process, Exist, RiseOnline-Win64-Shipping.exe
  if errorlevel
  {
		ControlSend,, %s%, AHK_exe RiseOnline-Win64-Shipping.exe
  }
  return
}

;==================Show/Hide==================
k_ShowHide()
{
	Gui, OSK: Submit, NoHide
	if (k_IsVisible = 1)
	{
		Gui, OSK: Cancel
		Menu, Tray, Rename, Exden Klavyesini Gizle, Exden Klavyesini Goster
		k_IsVisible := 0
	}
	else
	{
		Gui, OSK: Show
		Menu, Tray, Rename, Exden Klavyesini Goster, Exden Klavyesini Gizle
		k_IsVisible := 1
	}
}

k_MenuExit()
{
	Gui, OSK: Destroy
	ExitApp
}