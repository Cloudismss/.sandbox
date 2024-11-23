Set-Location $env:USERPROFILE\Downloads\

start-process -filepath "C:\Windows\Resources\Themes\dark.theme"

$progressPreference = 'silentlyContinue'

Write-Information "Downloading WinGet and its dependencies..."
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Repair-WinGetPackageManager -IncludePrerelease

Write-Information "Downloading Terminal, PowerShell, and NanaZip..."
Invoke-WebRequest -Uri https://github.com/microsoft/terminal/releases/download/v1.22.2702.0/Microsoft.WindowsTerminalPreview_1.22.2702.0_8wekyb3d8bbwe.msixbundle -OutFile Microsoft.WindowsTerminalPreview_1.22.2702.0_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri https://github.com/PowerShell/PowerShell/releases/download/v7.5.0-preview.5/PowerShell-7.5.0-preview.5-Win.msixbundle -OutFile PowerShell-7.5.0-preview.5-Win.msixbundle
Invoke-WebRequest -Uri https://github.com/M2Team/NanaZip/releases/download/3.5.1000.0/NanaZipPreview_3.5.1000.0.msixbundle -OutFile NanaZipPreview_3.5.1000.0.msixbundle
Add-AppxPackage Microsoft.WindowsTerminalPreview_1.22.2702.0_8wekyb3d8bbwe.msixbundle
Add-AppxPackage PowerShell-7.5.0-preview.5-Win.msixbundle
Add-AppxPackage NanaZipPreview_3.5.1000.0.msixbundle

Remove-Item * -Include *.appx 
Remove-Item * -Include *.msixbundle

Write-Information "Downloading PowerShell utilities..."
winget install Starship.Starship Fastfetch-cli.Fastfetch junegunn.fzf lsd-rs.lsd tldr-pages.tlrc --accept-source-agreements --accept-package-agreements

Write-Information "Downloading VSCode..."
winget install Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements
Copy-Item -Path $env:USERPROFILE\Shared\scripts\settings.json -destination $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json -Force
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
Start-Process code -ArgumentList "--install-extension ms-vscode.cpptools-extension-pack --install-extension ms-vscode.cmake-tools --install-extension llvm-vs-code-extensions.vscode-clangd --install-extension usernamehw.errorlens --install-extension aaron-bond.better-comments --install-extension MagdalenaLipka.tokyo-night-frameless --install-extension chadalen.vscode-jetbrains-icon-theme"

Write-Information "Downloading Git and C++ build tools..."
winget install Git.Git Kitware.CMake --accept-source-agreements --accept-package-agreements

# Option 1 - MSVC
winget install Microsoft.VisualStudio.2022.BuildTools --silent --override "--wait --quiet --add ProductLang En-us --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
# Uncomment below if you'd like the MSVC Clang tools
# winget install Microsoft.VisualStudio.2022.BuildTools --silent --override "--wait --quiet --add ProductLang En-us --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --add Microsoft.VisualStudio.Component.VC.CLI.Support --add Microsoft.VisualStudio.Component.VC.Llvm.Clang --add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang"
# Uncomment below if you'd like the Visual Sudio IDE
# winget install Microsoft.VisualStudio.2022.Community.Preview

# Option 2 - Clang & Ninja
# winget install LLVM.LLVM Ninja-build.Ninja --accept-package-agreements
# You need to provide c++ std library and Windows SDK

Write-Information "Downloading Fonts..."
Invoke-WebRequest -Uri https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -OutFile JetBrainsMono.zip
Expand-Archive -Path "JetBrainsMono.zip"
Remove-Item JetBrainsMono.zip
# Auto-install fonts (slow)
$ShellApplication = New-Object -ComObject shell.application
$Fonts = $ShellApplication.NameSpace(0x14)
Get-ChildItem -Path ".\JetBrainsMono" -Include '*.ttf' -Recurse | ForEach-Object -Process { $Fonts.CopyHere($_.FullName) }

Write-Information "Installation Completed!"

wt cmd /k fastfetch
