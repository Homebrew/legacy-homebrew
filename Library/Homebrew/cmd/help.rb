HOMEBREW_HELP = <<-EOS
Example usage:
  brew install FORMULA...
  brew uninstall FORMULA...
  brew search [foo]
  brew list [FORMULA...]
  brew update
  brew outdated
  brew [info | home] [FORMULA...]

Troubleshooting:
  brew doctor
  brew install -vd FORMULA
  brew [--env | --config]

Brewing:
  brew create [URL [--no-fetch]]
  brew edit [FORMULA...]
  open https://github.com/mxcl/homebrew/wiki/Formula-Cookbook

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

module Homebrew extend self
  def help
    puts HOMEBREW_HELP
  end
  def help_s
    HOMEBREW_HELP
  end
end
