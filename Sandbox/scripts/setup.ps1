Set-Location $env:USERPROFILE\Downloads\

start-process -filepath "C:\Windows\Resources\Themes\dark.theme"

$progressPreference = 'silentlyContinue'

Write-Information "Downloading WinGet and its dependencies..."
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

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
Start-Process code -ArgumentList "--install-extension llvm-vs-code-extensions.vscode-clangd --install-extension aaron-bond.better-comments --install-extension ms-vscode.cmake-tools --install-extension usernamehw.errorlens --install-extension eamodio.gitlens --install-extension alefragnani.project-manager --install-extension MagdalenaLipka.tokyo-night-frameless"

Write-Information "Downloading Git and C++ build tools..."
winget install Git.Git Kitware.CMake --accept-source-agreements --accept-package-agreements
winget install Microsoft.VisualStudio.2022.BuildTools --silent --override "--wait --quiet --add ProductLang En-us --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --add Microsoft.VisualStudio.Component.VC.Llvm.Clang --add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang"
# winget install Microsoft.VisualStudio.2022.BuildTools --silent --override "--wait --quiet --add ProductLang En-us --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --add Microsoft.VisualStudio.Component.VC.CLI.Support --add Microsoft.VisualStudio.Component.VC.Llvm.Clang --add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang"
# winget install Microsoft.VisualStudio.2022.Community.Preview

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

# Clang & Ninja
# winget install LLVM.LLVM Ninja-build.Ninja --accept-package-agreements

# MSYS2
# winget install MSYS2.MSYS2 
    # pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
        # Add the path of your MinGW-w64 bin folder to the Windows PATH environment variable by using the following steps:
        # In the Windows search bar, type Settings to open your Windows Settings.
        # Search for Edit environment variables for your account.
        # In your User variables, select the Path variable and then select Edit.
        # Select New and add the MinGW-w64 destination folder you recorded during the installation process to the list. If you selected the default installation steps, the path is: C:\msys64\ucrt64\bin.
        # Select OK, and then select OK again in the Environment Variables window to update the PATH environment variable. You have to reopen any console windows for the updated PATH environment variable to be available.