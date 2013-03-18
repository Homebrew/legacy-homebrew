require 'extend/fileutils'
require 'extend/pathname'
require 'extend/ARGV'
require 'extend/string'
require 'extend/symbol'
require 'extend/object'
require 'utils'
require 'exceptions'
require 'set'
require 'rbconfig'

ARGV.extend(HomebrewArgvExtension)

HOMEBREW_VERSION = '0.9.4'
HOMEBREW_WWW = 'http://mxcl.github.com/homebrew/'

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
  HOMEBREW_BREW_FILE = ENV['HOMEBREW_BREW_FILE'] || `which brew`.chomp
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

HOMEBREW_LOGS = Pathname.new('~/Library/Logs/Homebrew/').expand_path

RUBY_CONFIG = RbConfig::CONFIG
RUBY_BIN = Pathname.new("#{RUBY_CONFIG['bindir']}")
RUBY_PATH = RUBY_BIN/RUBY_CONFIG['ruby_install_name'] + RUBY_CONFIG['EXEEXT']

if RUBY_PLATFORM =~ /darwin/
  MACOS_FULL_VERSION = `/usr/bin/sw_vers -productVersion`.chomp
  MACOS_VERSION = /(10\.\d+)(\.\d+)?/.match(MACOS_FULL_VERSION).captures.first.to_f
  OS_VERSION = "Mac OS X #{MACOS_FULL_VERSION}"
  MACOS = true
else
  MACOS_FULL_VERSION = MACOS_VERSION = 0
  OS_VERSION = RUBY_PLATFORM
  MACOS = false
end

HOMEBREW_USER_AGENT = "Homebrew #{HOMEBREW_VERSION} (Ruby #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}; #{OS_VERSION})"

HOMEBREW_CURL_ARGS = '-f#LA'

module Homebrew extend self
  include FileUtils

  attr_accessor :failed
  alias_method :failed?, :failed
end

require 'metafiles'
FORMULA_META_FILES = Metafiles.new
ISSUES_URL = "https://github.com/mxcl/homebrew/wiki/troubleshooting"
HOMEBREW_PULL_URL_REGEX = 'https:\/\/github.com\/(\w+)\/homebrew(-\w+)?\/(pull\/(\d+)|commit\/\w{4,40})'

unless ARGV.include? "--no-compat" or ENV['HOMEBREW_NO_COMPAT']
  $:.unshift(File.expand_path("#{__FILE__}/../compat"))
  require 'compatibility'
end

ORIGINAL_PATHS = ENV['PATH'].split(':').map{ |p| Pathname.new(p).expand_path rescue nil }.compact.freeze
