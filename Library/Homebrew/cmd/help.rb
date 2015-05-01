HOMEBREW_HELP = <<-EOS
Example usage:
  brew info [FORMULA...]            Show info about FORMULA
  brew home [FORMULA...]            Open FORMULA home page
  brew options [FORMULA...]         Show FORMULA options
  brew install FORMULA...           Install FORMULA
  brew uninstall FORMULA...         Uninstall FORMULA
  brew search [foo]                 Search "foo"
  brew list [FORMULA...]            List FORMULA files
  brew update                       Update formula's database
  brew upgrade [FORMULA... | --all] Donwload new version of FORMULA
  brew pin/unpin [FORMULA...]       [un]Freeze formula from upgrade
  brew cleanup [FORMULA... | --all] Remove old versions of FORMULA
  Check man brew for more info                   

Troubleshooting:
  brew doctor
  brew install -vd FORMULA
  brew [--env | config]

Brewing:
  brew create [URL [--no-fetch]]
  brew edit [FORMULA...]
  open https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md

Further help:
  man brew
  brew home
EOS

# NOTE Keep the lenth of vanilla --help less than 25 lines!
# This is because the default Terminal height is 25 lines. Scrolling sucks
# and concision is important. If more help is needed we should start
# specialising help like the gem command does.
# NOTE Keep lines less than 80 characters! Wrapping is just not cricket.
# NOTE The reason the string is at the top is so 25 lines is easy to measure!

module Homebrew
  def help
    puts HOMEBREW_HELP
  end
  def help_s
    HOMEBREW_HELP
  end
end
