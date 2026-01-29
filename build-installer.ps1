# Build installer.exe from C# code
# Run this once to generate the exe file

$code = @'
using System;
using System.Diagnostics;
using System.IO;
using System.Security.Principal;

class Installer {
    static void Main() {
        // Check if running as admin
        var identity = WindowsIdentity.GetCurrent();
        var principal = new WindowsPrincipal(identity);
        bool isAdmin = principal.IsInRole(WindowsBuiltInRole.Administrator);

        string exePath = System.Reflection.Assembly.GetExecutingAssembly().Location;
        string exeDir = Path.GetDirectoryName(exePath);
        string installScript = Path.Combine(exeDir, "install.ps1");

        if (!isAdmin) {
            // Restart with elevation
            var startInfo = new ProcessStartInfo {
                FileName = exePath,
                Verb = "runas",
                UseShellExecute = true
            };
            try {
                Process.Start(startInfo);
            } catch {
                Console.WriteLine("Administrator privileges required!");
                Console.ReadKey();
            }
            return;
        }

        // Run PowerShell installer
        var ps = new ProcessStartInfo {
            FileName = "powershell.exe",
            Arguments = "-ExecutionPolicy Bypass -File \"" + installScript + "\"",
            WorkingDirectory = exeDir,
            UseShellExecute = false
        };

        var process = Process.Start(ps);
        process.WaitForExit();
    }
}
'@

$outputPath = Join-Path $PSScriptRoot "install.exe"

Add-Type -TypeDefinition $code -OutputAssembly $outputPath -OutputType ConsoleApplication

if (Test-Path $outputPath) {
    Write-Host "Created: $outputPath" -ForegroundColor Green
} else {
    Write-Host "Failed to create exe" -ForegroundColor Red
}
