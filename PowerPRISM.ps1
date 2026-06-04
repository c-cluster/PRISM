# PowerPRISM - PowerShell port of Prompt Rendering Integration & Style Manager
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$config = Get-Content (Join-Path $PSScriptRoot "PRISM.rice") -Raw | ConvertFrom-Json
$esc = [char]0x1b
$color = @{
	reset = "${esc}[0m"
	# rainbow
	red     = "${esc}[38;2;255;0;0m"
	orange  = "${esc}[38;2;255;127;0m"
	yellow  = "${esc}[38;2;255;255;0m"
	green   = "${esc}[38;2;0;255;0m"
	cyan    = "${esc}[38;2;0;255;255m"
	blue    = "${esc}[38;2;0;0;255m"
	indigo  = "${esc}[38;2;75;0;130m"
	violet  = "${esc}[38;2;148;0;211m"
	pink    = "${esc}[38;2;255;0;255m"
	# grayscale
	white     = "${esc}[38;2;255;255;255m"
	lightgray = "${esc}[38;2;192;192;192m"
	gray      = "${esc}[38;2;128;128;128m"
	darkgray  = "${esc}[38;2;64;64;64m"
	black     = "${esc}[38;2;0;0;0m"
	# special
	cobalt = "${esc}[38;2;51;77;196m"
	cereal = "${esc}[38;2;231;136;214m"
	afterthought = "${esc}[38;2;179;0;0m"
	azure = "${esc}[38;2;0;139;255m"
	lunar = "${esc}[38;2;221;204;255m"
	# invert = "${esc}[48;2;255;255;255m${esc}[38;2;0;0;0m" # sorry invert fans
	win11 = "${esc}[38;2;59;195;255m"
	mint = "${esc}[38;2;111;183;69m"
	pop = "${esc}[38;2;78;187;201m"
	debian = "${esc}[38;2;216;15;86m"
	win10 = "${esc}[38;2;0;116;207m"
	butter = "${esc}[38;2;252;255;166m"
	lesbian1 = "${esc}[38;2;214;41;0m"
	lesbian2 = "${esc}[38;2;255;155;85m"
	lesbian3 = "${esc}[38;2;210;98;165m"
	lesbian4 = "${esc}[38;2;165;0;98m"
	gold = "${esc}[38;2;255;206;0m"
}
function CTBTool($name) {
    return $color[$name] -replace "\[38;", "[48;"
}
function Convert-ToLinuxPath {
    param($path)
    $path = $path -replace "\\", "/"
	$path = $path -replace "Users", "home"
	$path = $path -replace "^[A-Z]:", ""
    return $path
}
$rescol = "$($color.reset)"
$bgos = CTBTool $config.bgcolor_os
$bgosf= $color[$config.bgcolor_os]
$bgsh = CTBTool $config.bgcolor_shell
$bgshf= $color[$config.bgcolor_shell]
$bgfs = CTBTool $config.bgcolor_path
$bgfsf= $color[$config.bgcolor_path]
$fgos = $color[$config.fgcolor_os]
$fgsh = $color[$config.fgcolor_shell]
$fgfs = $color[$config.fgcolor_path]
# $iconfs = $config.foldericon #too hard to add
if ($global:LIDS) {
	$script:iconos = $config.lnxicon
} else {
	if ($IsWindows) {
		$script:iconos = $config.winicon
	} else {
		$script:iconos = $config.lnxicon
	}
}
$prefix = $config.prefix
$suffix = $config.suffix
$sep = $config.seperator
$sepfs = $config.fileseperator
$shname = $config.shellname
function prompt {
	if ($global:LIDS) {
		$realPath = (Get-Location).Path
		if ($IsWindows -or $PSVersionTable.PSEdition -eq "Desktop") {
			$linuxPath = Convert-ToLinuxPath $realPath
		} else {
			$linuxPath = $realPath
		}
		"$($bgosf)$prefix$rescol$($bgos)$($fgos)$script:iconos$rescol$($bgsh)$($bgosf)$sep$rescol$($bgsh)$($fgsh)$shname$rescol$($bgshf)$($bgfs)$sep$rescol$($bgfs)$($fgfs)$linuxPath$rescol$($bgfsf)$sep$rescol"
	} else {
		"$($bgosf)$prefix$rescol$($bgos)$($fgos)$script:iconos$rescol$($bgsh)$($bgosf)$sep$rescol$($bgsh)$($fgsh)$shname$rescol$($bgshf)$($bgfs)$sep$rescol$($bgfs)$($fgfs)$pwd$rescol$($bgfsf)$sep$rescol"
	}
}

function delid {
	$global:LIDS = $false
	$script:iconos = $config.winicon
}
function relid {
	$global:LIDS = $true
	$script:iconos = $config.lnxicon
}

# Copyright (c) cereal@cluster 2026