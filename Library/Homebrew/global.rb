require 'extend/pathname'
require 'extend/ARGV'
require 'extend/string'
require 'utils'
require 'exceptions'
require 'compatibility'

ARGV.extend(HomebrewArgvExtension)

HOMEBREW_VERSION = '0.7.1'
HOMEBREW_WWW = 'http://mxcl.github.com/homebrew/'

HOMEBREW_CACHE =
if ENV['HOMEBREW_CACHE']
  Pathname.new(ENV['HOMEBREW_CACHE'])
elif Process.uid == 0
  # technically this is not the correct place, this cache is for *all users*
  # so in that case, maybe we should always use it, root or not?
  Pathname.new("/Library/Caches/Homebrew")
else
  Pathname.new("~/Library/Caches/Homebrew").expand_path
end

if not defined? HOMEBREW_BREW_FILE
  HOMEBREW_BREW_FILE = ENV['HOMEBREW_BREW_FILE'] || `which brew`.chomp
end

# Introduce ConfigurableVariable class
# class ConfigurableVariable
#   def initialize name
#     @name = name
#   end
#
#   def get
#     if ENV[@name]
#       return ENV[@name]
#     else
#       return eval
#     end
#   end
# end

HOMEBREW_PREFIX =
if ENV['HOMEBREW_PREFIX']
  Pathname.new(ENV['HOMEBREW_PREFIX'])
else
  Pathname.new(HOMEBREW_BREW_FILE).dirname.parent # Where we link under
end

HOMEBREW_REPOSITORY = Pathname.new(HOMEBREW_BREW_FILE).realpath.dirname.parent # Where .git is found

# Where we store built products; /usr/local/Cellar if it exists,
# otherwise a Cellar relative to the Repository.
HOMEBREW_CELLAR = if (HOMEBREW_PREFIX/"Cellar").exist?
  HOMEBREW_PREFIX/"Cellar"
else
  HOMEBREW_REPOSITORY/"Cellar"
end

#MACOS_FULL_VERSION = `/usr/bin/sw_vers -productVersion`.chomp
#MACOS_VERSION = /(10\.\d+)(\.\d+)?/.match(MACOS_FULL_VERSION).captures.first.to_f
MACOS_FULL_VERSION = "10"
MACOS_VERSION = 11.0

HOMEBREW_USER_AGENT = "Homebrew #{HOMEBREW_VERSION} (Ruby #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}; Mac OS X #{MACOS_FULL_VERSION})"


RECOMMENDED_LLVM = 2326
RECOMMENDED_GCC_40 = (MACOS_VERSION >= 10.6) ? 5494 : 5493
RECOMMENDED_GCC_42 = (MACOS_VERSION >= 10.6) ? 5664 : 5577

require 'fileutils'
module Homebrew extend self
  include FileUtils
end

FORMULA_META_FILES = %w[README README.md ChangeLog COPYING LICENSE LICENCE COPYRIGHT AUTHORS]
PLEASE_REPORT_BUG = "#{Tty.white}Please report this bug at #{Tty.em}\nhttps://github.com/mxcl/homebrew/wiki/new-issue#{Tty.reset}"
