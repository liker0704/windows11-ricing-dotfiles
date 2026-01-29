Add-Type @"
using System;
using System.Runtime.InteropServices;
public class XMouse {
    [DllImport("user32.dll")]
    public static extern bool SystemParametersInfo(uint action, uint param, ref bool vparam, uint init);
}
"@
$enabled = $true
[XMouse]::SystemParametersInfo(0x1001, 0, [ref]$enabled, 2) | Out-Null
