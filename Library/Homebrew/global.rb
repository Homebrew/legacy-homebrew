require 'extend/pathname'
require 'extend/ARGV'
require 'extend/string'
require 'utils'
require 'system_command'

ARGV.extend(HomebrewArgvExtension)

HOMEBREW_VERSION = '0.7.1'
HOMEBREW_WWW = 'http://mxcl.github.com/homebrew/'
HOMEBREW_GIT_URL = 'https://github.com/rubiojr/homebrew'
HOMEBREW_GIT_USER = 'rubiojr'
HOMEBREW_GIT_BRANCH = 'master'

if SystemCommand.platform == :mac
  if Process.uid == 0
    # technically this is not the correct place, this cache is for *all users*
    # so in that case, maybe we should always use it, root or not?
    HOMEBREW_CACHE=Pathname.new("/Library/Caches/Homebrew")
  else
    HOMEBREW_CACHE=Pathname.new("~/Library/Caches/Homebrew").expand_path
  end
else
  HOMEBREW_CACHE = Pathname.new("#{ENV['HOME']}/.homebrew/cache")
end

if not defined? HOMEBREW_BREW_FILE
  HOMEBREW_BREW_FILE = ENV['HOMEBREW_BREW_FILE'] || `which brew`.chomp
end

HOMEBREW_PREFIX = Pathname.new(HOMEBREW_BREW_FILE).dirname.parent # Where we link under
FORMULA_REPOSITORY = ENV['BREW_FORMULA_REPOSITORY'] || "#{Pathname.new(HOMEBREW_BREW_FILE).dirname.parent}/Library/Formula/"
HOMEBREW_REPOSITORY = Pathname.new(HOMEBREW_BREW_FILE).realpath.dirname.parent # Where .git is found

# Where we store built products; /usr/local/Cellar if it exists,
# otherwise a Cellar relative to the Repository.
if (HOMEBREW_PREFIX+'Cellar').exist?
  HOMEBREW_CELLAR = HOMEBREW_PREFIX+'Cellar'
else
  HOMEBREW_CELLAR = HOMEBREW_REPOSITORY+'Cellar'
end

if SystemCommand.platform == :mac
  MACOS_FULL_VERSION = `/usr/bin/sw_vers -productVersion`.chomp
  MACOS_VERSION = /(10\.\d+)(\.\d+)?/.match(MACOS_FULL_VERSION).captures.first.to_f
else
  MACOS_FULL_VERSION = "#{SystemCommand.uname} -r"
  MACOS_VERSION = '2.6'
end

if SystemCommand.platform == :mac
  HOMEBREW_USER_AGENT = "Homebrew #{HOMEBREW_VERSION} (Ruby #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}; Mac OS X #{MACOS_FULL_VERSION})"
else
  HOMEBREW_USER_AGENT = "Homebrew #{HOMEBREW_VERSION} (Ruby #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}; Linux)"
end

RECOMMENDED_LLVM = 2326
if SystemCommand.platform == :mac
  RECOMMENDED_GCC_40 = (MACOS_VERSION >= 10.6) ? 5494 : 5493
  RECOMMENDED_GCC_42 = (MACOS_VERSION >= 10.6) ? 5664 : 5577
else
  RECOMMENDED_GCC_40 = 4
  RECOMMENDED_GCC_42 = 4
end
