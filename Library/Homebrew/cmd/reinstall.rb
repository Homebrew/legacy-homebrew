require 'cmd/uninstall'
require 'cmd/install'

module Homebrew extend self
  def reinstall
    self.uninstall
    self.install
  end
end
