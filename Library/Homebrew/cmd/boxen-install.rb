require "boxen-bottle-hooks"
require "cmd/install"

# A custom Homebrew command that loads our bottle hooks.

module Homebrew
  def self.boxen_install
    install
  end
end
