require 'extend/module'
require 'extend/fileutils'
require 'extend/pathname'
require 'extend/ARGV'
require 'extend/string'
require 'extend/symbol'
require 'extend/enumerable'
require 'os'
require 'utils'
require 'exceptions'
require 'set'
require 'rbconfig'

ARGV.extend(HomebrewArgvExtension)

HOMEBREW_VERSION = '0.9.5'
HOMEBREW_WWW = 'http://brew.sh'

def cache
  if ENV['HOMEBREW_CACHE']
    Pathname.new(ENV['HOMEBREW_CACHE'])
  else
    # we do this for historic reasons, however the cache *should* be the same
    # directory whichever user is used and whatever instance of brew is executed
    home_cache = Pathname.new("~/Library/Caches/Homebrew").expand_path
    if home_cache.directory? and home_cache.writable_real?
      home_cache
    else
      root_cache = Pathname.new("/Library/Caches/Homebrew")
      class << root_cache
        alias :oldmkpath :mkpath
        def mkpath
          unless exist?
            oldmkpath
            chmod 0777
          end
        end
      end
      root_cache
    end
  end
end

HOMEBREW_CACHE = cache
undef cache # we use a function to prevent adding home_cache to the global scope

# Where brews installed via URL are cached
HOMEBREW_CACHE_FORMULA = HOMEBREW_CACHE+"Formula"

if not defined? HOMEBREW_BREW_FILE
  HOMEBREW_BREW_FILE = ENV['HOMEBREW_BREW_FILE'] || which('brew').to_s
end

HOMEBREW_PREFIX = Pathname.new(HOMEBREW_BREW_FILE).dirname.parent # Where we link under
HOMEBREW_REPOSITORY = Pathname.new(HOMEBREW_BREW_FILE).realpath.dirname.parent # Where .git is found
HOMEBREW_LIBRARY = HOMEBREW_REPOSITORY/"Library"
HOMEBREW_CONTRIB = HOMEBREW_REPOSITORY/"Library/Contributions"

# Where we store built products; /usr/local/Cellar if it exists,
# otherwise a Cellar relative to the Repository.
HOMEBREW_CELLAR = if (HOMEBREW_PREFIX+"Cellar").exist?
  HOMEBREW_PREFIX+"Cellar"
else
  HOMEBREW_REPOSITORY+"Cellar"
end

HOMEBREW_LOGS = Pathname.new(ENV['HOMEBREW_LOGS'] || '~/Library/Logs/Homebrew/').expand_path

HOMEBREW_TEMP = Pathname.new(ENV.fetch('HOMEBREW_TEMP', '/tmp'))

if RbConfig.respond_to?(:ruby)
  RUBY_PATH = Pathname.new(RbConfig.ruby)
else
  RUBY_PATH = Pathname.new(RbConfig::CONFIG["bindir"]).join(
    RbConfig::CONFIG["ruby_install_name"] + RbConfig::CONFIG["EXEEXT"]
  )
end
RUBY_BIN = RUBY_PATH.dirname

if RUBY_PLATFORM =~ /darwin/
  MACOS_FULL_VERSION = `/usr/bin/sw_vers -productVersion`.chomp
  MACOS_VERSION = MACOS_FULL_VERSION[/10\.\d+/]
  OS_VERSION = "Mac OS X #{MACOS_FULL_VERSION}"
else
  MACOS_FULL_VERSION = MACOS_VERSION = "0"
  OS_VERSION = RUBY_PLATFORM
end

HOMEBREW_GITHUB_API_TOKEN = ENV["HOMEBREW_GITHUB_API_TOKEN"]
HOMEBREW_USER_AGENT = "Homebrew #{HOMEBREW_VERSION} (Ruby #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}; #{OS_VERSION})"

HOMEBREW_CURL_ARGS = '-f#LA'

require 'tap_constants'

module Homebrew
  include FileUtils
  extend self

  attr_accessor :failed
  alias_method :failed?, :failed
end

ISSUES_URL = "https://github.com/Homebrew/homebrew/wiki/troubleshooting"
HOMEBREW_PULL_OR_COMMIT_URL_REGEX = 'https:\/\/github.com\/(\w+)\/homebrew(-\w+)?\/(pull\/(\d+)|commit\/\w{4,40})'

require 'compat' unless ARGV.include? "--no-compat" or ENV['HOMEBREW_NO_COMPAT']

ORIGINAL_PATHS = ENV['PATH'].split(File::PATH_SEPARATOR).map{ |p| Pathname.new(p).expand_path rescue nil }.compact.freeze

SUDO_BAD_ERRMSG = <<-EOS.undent
  You can use brew with sudo, but only if the brew executable is owned by root.
  However, this is both not recommended and completely unsupported so do so at
  your own risk.
EOS
