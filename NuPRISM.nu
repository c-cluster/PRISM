# NuPRISM - New Prompt Rendering Integration & Style Manager
$env.SCRIPT_DIR = ($env.FILE_PWD)
let prismconfig = (open --raw ($env.SCRIPT_DIR | path join "PRISM.rice") | from json)
def color [
    name: string
    mode: string = "fg"
] {
    let rgb = match $name {
        # rainbow
        red         => [255 0 0]
        orange      => [255 127 0]
        yellow      => [255 255 0]
        green       => [0 255 0]
        cyan        => [0 255 255]
        blue        => [0 0 255]
        indigo      => [75 0 130]
        violet      => [148 0 211]
        pink        => [255 0 255]

        # grayscale
        white       => [255 255 255]
        lightgray   => [192 192 192]
        gray        => [128 128 128]
        darkgray    => [64 64 64]
        black       => [0 0 0]

        # special
        cobalt      => [51 77 196]
        cereal      => [231 136 214]
        afterthought => [179 0 0]
        azure       => [0 139 255]
        lunar       => [221 204 255]
        win11       => [59 195 255]
        mint        => [111 183 69]
        pop         => [78 187 201]
        debian      => [216 15 86]
        win10       => [0 116 207]
        butter      => [252 255 166]
        lesbian1    => [214 41 0]
        lesbian2    => [255 155 85]
        lesbian3    => [210 98 165]
        lesbian4    => [165 0 98]
        gold        => [255 206 0]
    }

    let cprefix = if $mode == "bg" { "48" } else { "38" }

    let esc = "\u{1b}"

    $"($esc)[($cprefix);2;($rgb.0);($rgb.1);($rgb.2)m"
}

let bgos =  (color $prismconfig.bgcolor_os bg)
let bgosf = (color $prismconfig.bgcolor_os fg)
let bgsh =  (color $prismconfig.bgcolor_shell bg)
let bgshf = (color $prismconfig.bgcolor_shell fg)
let bgfs =  (color $prismconfig.bgcolor_path bg)
let bgfsf = (color $prismconfig.bgcolor_path fg)
let fgos =  (color $prismconfig.fgcolor_os fg)
let fgsh =  (color $prismconfig.fgcolor_shell fg)
let fgfs =  (color $prismconfig.fgcolor_path fg)
let lnxic = $prismconfig.lnxicon
let winic = $prismconfig.winicon
let prefix = $prismconfig.prefix
let suffix = $prismconfig.suffix
let sep = $prismconfig.seperator
let sepfs = $prismconfig.fileseperator
let shname = $prismconfig.shellname
let rescol = (ansi reset)
$env.LNXPATH = 0
$env.ICONOS = $winic

if $nu.os-info.name == "windows" {
	$env.LNXPATH = 0
	$env.ICONOS = $winic
} else {
	$env.LNXPATH = 1
	$env.ICONOS = $lnxic
}
def --env relid [] {
	$env.LNXPATH = 1
}
def --env delid [] {
	$env.LNXPATH = 0
}

def tolnx [path: string = ~] {
	$path
	| str replace -a '\' '/'
	| str replace 'Users' 'home'
	| str replace 'users' 'home'
	| str replace -r '^[A-Z]:' ''
}
def towin [path: string = ~] {
	$path
	| str replace -a '\' '/'
	| str replace -a 'home' 'Users'
}


def renderer [] {
    let real_path = (pwd)

    if $env.LNXPATH == 1 {
        if $nu.os-info.name == "windows" {
            tolnx $real_path
        } else {
            $real_path
        }
    } else {
        if $nu.os-info.name == "windows" {
            $real_path
        } else {
            towin $real_path
        }
    }
}
def --env ico [] {
	if $env.LNXPATH == 1 {
		$env.ICONOS = $lnxic
	} else {
		$env.ICONOS = $winic
	}
}

$env.PROMPT_COMMAND = {||
	ico
    let display_path = (renderer)

    $"($bgosf)($prefix)($rescol)($bgos)($fgos)($env.ICONOS)($rescol)($bgsh)($bgosf)($sep)($rescol)($bgsh)($fgsh)($shname)($rescol)($bgshf)($bgfs)($sep)($rescol)($bgfs)($fgfs)($display_path)($rescol)($bgfsf)($sep)($rescol)"
}
$env.PROMPT_INDICATOR = ""
$env.RENDER_RIGHT_PROMPT_ON_LAST_LINE = false
$env.PROMPT_COMMAND_RIGHT = ""