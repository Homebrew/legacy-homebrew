# fish (http://fishshell.org) completion script for brew(1)
# To install, symlink into (brew --prefix)/share/fish/completions
# or ~/.config/fish/completions with the name 'brew.fish'
# e.g.:
#   mkdir -p ~/.config/fish/completions
#   ln -s (brew --prefix)/Library/Contributions/brew_fish_completion.fish
#     ~/.config/fish/completions/brew.fish

for command in (ls (brew --repository)/Library/Homebrew/cmd | sed s/\.rb//)
  set commands $command $commands
end

for command in (ls -p (brew --repository)/Library/Contributions/cmds | sed -e "s/\.rb//g" -e "s/brew-//g" -e "s/.*\///g")
  set commands $command $commands
end

for command in abv ln ls remove rm
  set commands $command $commands
end

function __fish_complete_brew_argument
  set arguments (commandline -opc)
  for cmd in $arguments
  
    if contains -- $cmd abv audit cat deps edit fetch home homepage info install log ls list options uses versions --cache --cellar --prefix
      ls (brew --repository)/Library/Formula 2>/dev/null | sed 's/\.rb//g'
      ls (brew --repository)/Library/Aliases 2>/dev/null | sed 's/\.rb//g'
      for dir in (ls (brew --repository)/Library/Taps 2>/dev/null)
        set tap (echo "$dir" | sed 's|-|/|g')
        ls -1R (brew --repository)/Library/Taps/$dir 2>/dev/null | grep '.\+.rb' | sed -E 's|(.+).rb|'"$tap"'/\1|g'
      end
      return 0
    end
    
    if contains -- $cmd cleanup link ln missing rm remove test unlink uninstall upgrade
      ls (brew --prefix)/Cellar
      return 0
    end

    if contains -- $cmd tap
      brew ls-taps
      return 0
    end

    if contains -- $cmd untap
      ls (brew --repository)/Library/Taps 2>/dev/null | sed 's/-/\//g'
      return 0
    end
    
  end
end

function __fish_complete_brew_has_command
  set arguments (commandline -opc)
  
  if [ (count $arguments) = 1 ]
    return 1
  end
  
  for cmd in $arguments
    if contains -- $cmd $commands
      return 0
    end
  end
  return 1
  
end

function __fish_complete_brew_command
  set arguments (commandline -opc)
  
  for item in $argv
    if contains -- $item $arguments
      return 0
    end
  end
  return 1
end

function __fish_complete_brew_no_command
  for cmd in (commandline -opc)
    if contains -- $cmd $commands
      return 1
    end
  end
  return 0
end

complete -c brew -x -a "$commands" -n '__fish_complete_brew_no_command'
complete -c brew -x -a '(__fish_complete_brew_argument)' -n '__fish_complete_brew_has_command'

complete -c brew -s f -l force -n '__fish_complete_brew_command cleanup' -d "Remove out-of-date keg-only brews"
complete -c brew -s n -l dry-run -n '__fish_complete_brew_command cleanup' -d "Show what would be removed, but don't do anything"
complete -c brew -s s -n '__fish_complete_brew_command cleanup' -d "Remove all downloads"

complete -c brew -l autotools -n '__fish_complete_brew_command create' -d "Use autotools template"
complete -c brew -l cmake -n '__fish_complete_brew_command create' -d "Use cmake template"
complete -c brew -l no-fetch -n '__fish_complete_brew_command create' -d "Do not download URL"

complete -c brew -l 1 -n '__fish_complete_brew_command deps' -d "Only show dependencies one level down"
complete -c brew -s n -n '__fish_complete_brew_command deps' -d "Show dependencies in topological order"
complete -c brew -l tree -n '__fish_complete_brew_command deps' -d "Show dependencies as a tree"
complete -c brew -l all -n '__fish_complete_brew_command deps' -d "Show dependencies for all formulae"

complete -c brew -l set-name -n '__fish_complete_brew_command diy' -d "Set package name" -f
complete -c brew -l set-version -n '__fish_complete_brew_command diy' -d "Set package version" -f

complete -c brew -n '__fish_complete_brew_command doctor' -f

complete -c brew -n '__fish_complete_brew_command edit' -x

complete -c brew -s f -l force -n '__fish_complete_brew_command fetch' -d "Always redownload"
complete -c brew -l HEAD -n '__fish_complete_brew_command fetch' -d "Download HEAD version"
complete -c brew -l deps -n '__fish_complete_brew_command fetch' -d "Download dependencies"

complete -c brew -n '__fish_complete_brew_command home' -x

complete -c brew -l all -n '__fish_complete_brew_command info abv' -d "Show info for all formulae"
complete -c brew -l github -n '__fish_complete_brew_command info abv' -d "Open GitHub History page in browser" -x

complete -c brew -s d -l debug -n '__fish_complete_brew_command install' -d "Open a shell if install fails"
complete -c brew -s f -l force -n '__fish_complete_brew_command force' -d "Install formula even if blacklisted"
complete -c brew -s i -l interactive -n '__fish_complete_brew_command install' -d "Open a subshell to install manually"
complete -c brew -l git -n '__fish_complete_brew_command install' -d 'Create a git repo (useful for making patches)'
complete -c brew -l fresh -n '__fish_complete_brew_command install' -d "Do not reuse options from previous installs"
complete -c brew -l use-clang -n '__fish_complete_brew_command install' -d "Attempt to compile using Clang"
complete -c brew -l use-llvm -n '__fish_complete_brew_command install' -d "Attempt to compile using LLVM"
complete -c brew -l use-gcc -n '__fish_complete_brew_command install' -d "Attempt to compile using GCC"
complete -c brew -l build-from-source -n '__fish_complete_brew_command install' -d "Compile from source even if a bottle is provided"
complete -c brew -l devel -n '__fish_complete_brew_command install' -d "Install the development version"
complete -c brew -l HEAD -n '__fish_complete_brew_command install' -d "Install the HEAD version"

complete -c brew -s f -l force -n '__fish_complete_brew_command link ln' -d "Overwrite files while linking"
complete -c brew -s n -l dry-run -n '__fish_complete_brew_command link ln' -d "Show which files would be deleted"

complete -c brew -l unbrewed -n '__fish_complete_brew_command list ls' -d "List files in Homebrew prefix not installed by Homebrew"
complete -c brew -l versions -n '__fish_complete_brew_command list ls' -d "Show the version number for specified formulae"

complete -c brew -n '__fish_complete_brew_command log' -u

complete -c brew -l compact -n '__fish_complete_brew_command options' -d "Show options on a single line"
complete -c brew -l all -n '__fish_complete_brew_command options' -f -d "Show options for all formulae"
complete -c brew -l installed -n '__fish_complete_brew_command options' -f -d "Show options for all installed formulae"

complete -c brew -l quiet -n '__fish_complete_brew_command outdated' -d "Do not print names of outdated brews"

complete -c brew -s f -l force -n '__fish_complete_brew_command uninstall rm remove' -d "Delete all installed versions"

complete -c brew -l macports -n '__fish_complete_brew_command search' -d "Search Macports package search page"
complete -c brew -l fink -n '__fish_complete_brew_command search' -d "Search Fink package search page"

complete -c brew -l rebase -n '__fish_complete_brew_command update' -d "Use git pull --rebase"

complete -c brew -l installed -n '__fish_complete_brew_command uses' -d "Only list installed formulae"

complete -c brew -l compact -n '__fish_complete_brew_command versions' -d "Show all versions on a single line"

complete -c brew -l prefix  -n '__fish_complete_brew_no_command'
complete -c brew -l version -n '__fish_complete_brew_no_command'
complete -c brew -l cache   -n '__fish_complete_brew_no_command'

complete -c brew -s v -l verbose -d "Print extra debugging information"
