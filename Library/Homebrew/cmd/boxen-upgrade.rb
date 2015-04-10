require "boxen-bottle-hooks"
require "cmd/upgrade"

# A custom Homebrew command that loads our bottle hooks.

module Homebrew
  def self.boxen_upgrade
    upgrade
  end
end
