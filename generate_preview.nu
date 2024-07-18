#!/usr/bin/env nu
use std repeat

const README = "README.md"
const README_HEADER = "# wallpapers

A gallery of wallpapers forked from amtoine so i can add my own.


## Ownership.
These wallpapers come from the internet. Diffusion and usage rights are not known for all of them.
*I do not own any of the wallpapers listed in this repo.*

If you stumble upon art or photos that you own or that you know and show that special rights have to be used to use or share them, *let me known and I will remove them immediately and without question!*

## Gallery"

def clean [] {
    ls **/*.md | where name =~ README | each {|it|
        rm $it.name
        print $"Removed ($it.name)"
    }
}

def preview [filename: path, name: string, --level: int = 4]: nothing -> string {
    [
        $"('#' | repeat $level | str join) ($name)"
        $"![]\(./($filename)\)\n\n"
    ]
    | str join "\n"
}

def main [] {
    clean

    $README_HEADER ++ "\n" | save --force $README

    ls wallpapers/ | sort-by type | each {|it|
        match $it.type {
            "dir" => {
                let readme = $it.name | path join $README
                "" | save --force $readme

                # $"- [[($readme)][($it.name)]]\n" | save --force --append $README
                $"- [($it.name)]\(($readme)\)\n" | save --force --append $README

                ls $it.name | where type == file | each {|file|
                    print -n $"(ansi erase_line)($file.name)\r"

                    preview ($file.name | path basename) ($file.name | path basename) --level 2
                        | save --force --append $readme
                }
            },
            "file" => {
                preview $it.name ($it.name | path basename) --level 3
                    | save --force --append $README
            },
        }
    }

    null
}
