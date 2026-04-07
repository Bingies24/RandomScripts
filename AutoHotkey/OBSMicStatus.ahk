/*
License: MIT

Copyright 2026 Bingies24

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the “Software”), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#Requires AutoHotkey v2.0.18+
#Include %A_AhkPath%/../lib/OBSWebSocket.ahk ; You can get it here: https://github.com/5ony/OBSWebSocketAHK

IconUnmuted := "image path"
IconMuted := "image path"
IconGUI := Gui("+AlwaysOnTop -Caption +E0x20")
IconGUI.BackColor := "888888"
WinSetTransColor("888888", IconGUI)
IconGUI.MarginX := 0
IconGUI.MarginY := 0
Icon := IconGUI.Add("Picture", , IconUnmuted)
IconGUI.Show("x0 y960 w64 h64 NoActivate") ; You will have to change the values according to your desired image size and position.

class OBSC extends OBSWebSocket {
    AfterIdentified() {
        this.GetInputMute("Microphone")
    }

    GetInputMuteResponse(data) {
        if data.d.responseData.inputMuted == "1" {
            Icon.Value := IconMuted
        }
    }

    InputMuteStateChanged(data) {
        if data.d.eventData.inputName == "Microphone" {
            if data.d.eventData.inputMuted == "1" {
                Icon.Value := IconMuted
            } else {
                Icon.Value := IconUnmuted
            }
        }
    }
}

/*
To get the values need for this part, in OBS, go to Tools > WebSocket Server settings.
Make sure the server is enabled and click "Show Connect Info."
*/
OBS := OBSC("ws://ip:port/", "password", OBSC.EventSubscription.Inputs)
OBSWindow := 'ahk_exe obs64.exe'

if WinExist(OBSWindow) {
    Loop {
        if !WinExist(OBSWindow) {
            break
        }
    }
}

ExitApp