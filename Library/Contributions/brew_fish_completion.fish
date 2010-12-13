# This script contains basic completion of brew commands for
# fish (http://fishshell.org). To install it either put it
# in <your-fish-install-location>/share/fish/completions
# or ~/.config/fish/completions - and name it 'brew.fish'
# e.g.:
#   mkdir -p ~/.config/fish/completions
#   cp brew_fish_completion.fish ~/.config/fish/completions/brew.fish

function __fish_complete_homebrew_formula
  set arguments (commandline -opc)
  for cmd in $arguments
  
    if contains -- $cmd edit install homepage home
      ls (brew --prefix)/Library/Formula | sed s/\.rb//
      return 0
    end
    
    if contains -- $cmd abv info list link ls ln rm remove uninstall
      ls (brew --prefix)/Cellar
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
    if contains -- $cmd abv info list link ls ln rm remove uninstall edit install homepage home prune gen
      return 0
    end
  end
  return 1
  
end

function __fish_complete_brew_command
  set arguments (commandline -opc)
  set cmd $argv[1]
  
  if contains -- $cmd abv info list link ls ln rm remove uninstall edit install homepage home prune gen
    return 0
  end
  return 1
end

function __fish_complete_brew_no_command
  for cmd in (commandline -opc)
    if contains -- $cmd abv info list link ls ln rm remove uninstall edit install homepage home prune gen
      return 1
    end
  end
  return 0
end

complete -c brew -x -a "abv info list link ls ln rm remove uninstall edit install homepage home prune gen" -n '__fish_complete_brew_no_command'
complete -c brew -x -a '(__fish_complete_homebrew_formula)' -n '__fish_complete_brew_has_command'

complete -c brew -s d -l debug -n '__fish_complete_brew_command install'
complete -c brew -s i -l interactive -n '__fish_complete_brew_command install'

complete -c brew -l github -n '__fish_complete_brew_command info'

complete -c brew -l prefix  -n '__fish_complete_brew_no_command'
complete -c brew -l version -n '__fish_complete_brew_no_command'
complete -c brew -l cache   -n '__fish_complete_brew_no_command'

complete -c brew -s v -l verbose
