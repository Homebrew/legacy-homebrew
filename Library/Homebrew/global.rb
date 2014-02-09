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

if not defined? HOMEBREW_BREW_FILE
  HOMEBREW_BREW_FILE = ENV['HOMEBREW_BREW_FILE'] || which('brew').to_s
end

HOMEBREW_PREFIX = Pathname.new(HOMEBREW_BREW_FILE).dirname.parent # Where we link under
HOMEBREW_REPOSITORY = Pathname.new(HOMEBREW_BREW_FILE).realpath.dirname.parent # Where .git is found
HOMEBREW_LIBRARY = HOMEBREW_REPOSITORY/"Library"
HOMEBREW_CONTRIB = HOMEBREW_REPOSITORY/"Library/Contributions"

# Where downloaded files are cached.
HOMEBREW_CACHE = Pathname.new(ENV['HOMEBREW_CACHE'] || HOMEBREW_LIBRARY/"Cache")
HOMEBREW_CACHE_FORMULA = HOMEBREW_CACHE/"Formula" # Where brews installed via URL are cached
class << HOMEBREW_CACHE_FORMULA
  alias mkpath_without_migrate mkpath
  def mkpath
    HOMEBREW_CACHE.migrate! if not exist?   # make sure migration happens
    mkpath_without_migrate
  end
end
class << HOMEBREW_CACHE
  alias mkpath_without_migrate mkpath
  def mkpath
    migrate! if not exist?   # make sure migration happens
    mkpath_without_migrate
  end

  # Previous versions of Homebrew used a world-writable cache directory in
  # /Library/Caches/Homebrew, or a user-owned cache directory in
  # ~/Library/Caches/Homebrew.  There were security problems with that approach
  # (see https://github.com/mxcl/homebrew/issues/23232) so now we just use a
  # subdirectory of the repository.
  #
  # This migrates the old cache directory to the new location, where it's safe to do so.
  def migrate!
    # Nothing to migrate if the HOMEBREW_CACHE env var is set.
    return if ENV['HOMEBREW_CACHE']

    # Only migrate once, and make sure there's only one process doing the
    # migration.
    if HOMEBREW_CACHE.exist?
      return
    else
      HOMEBREW_CACHE.dirname.mkpath
      begin
        HOMEBREW_CACHE.mkdir
      rescue Errno::EEXIST
        # Some other process created the directory.  Don't migrate.
        return
      end
    end

    # Previous versions of homebrew used ~/Library/Caches/Homebrew as a cache
    # if it existed.  Attempt to migrate this to the new cache dir.
    home_cache = Pathname.new("~/Library/Caches/Homebrew").expand_path
    if home_cache.directory? and home_cache.writable_real?
      Dir[home_cache/'*', home_cache/'.*'].each do |src|
        src = Pathname.new(src)
        next if ['.', '..'].include?(src.basename.to_s)
        FileUtils.mv src, HOMEBREW_CACHE
      end

      # We don't remove the empty ~/Library/Caches/Homebrew.  It was created
      # manually, and removing it could leave users insecure if they downgrade
      # to an older version.
      return
    end

    # Let's try the global cache instead.  This is tricky, because it might
    # be/have been owned by another user, and getting this wrong could lead to
    # privilege escalation.
    1.times do
      # Atomically get information about the path
      begin
        site_cache = Pathname.new("/Library/Caches/Homebrew")
        st = site_cache.lstat
      rescue Errno::ENOENT, Errno::EACCES
        break
      end

      # We can't do anything if it's not a directory that we can write to.
      break unless st.directory? and st.writable_real?

      # Don't migrate if it would be unsafe.
      # Note: This doesn't cover every possible unsafe situation that might
      # have been created by the current user, but it should cover the case
      # where a previous version of homebrew created a world-writable cache
      # directory.
      break if (st.mode & 2) != 0   # world-writable
      break if !st.owned? and st.uid != 0   # owned by another user
      break if st.symlink?  # is a symlink (potentially pointing somewhere dangerous)

      # Migrate the files.
      Dir[site_cache/'*', site_cache/'.*'].each do |src|
        src = Pathname.new(src)
        next if ['.', '..'].include?(src.basename.to_s)
        FileUtils.mv src, HOMEBREW_CACHE
      end

      # We don't remove the empty /Library/Caches/Homebrew directory, because
      # another process might be using it (hopefully not, but it's possible),
      # and deleting it might allow an attacker to create a new directory in
      # its place.
      return
    end
  end
end

# Where we store built products; /usr/local/Cellar if it exists,
# otherwise a Cellar relative to the Repository.
HOMEBREW_CELLAR = if (HOMEBREW_PREFIX+"Cellar").exist?
  HOMEBREW_PREFIX+"Cellar"
else
  HOMEBREW_REPOSITORY+"Cellar"
end

HOMEBREW_LOGS = Pathname.new(ENV['HOMEBREW_LOGS'] || '~/Library/Logs/Homebrew/').expand_path

HOMEBREW_TEMP = Pathname.new(ENV.fetch('HOMEBREW_TEMP', '/tmp'))

RUBY_BIN = Pathname.new(RbConfig::CONFIG['bindir'])
RUBY_PATH = RUBY_BIN + RbConfig::CONFIG['ruby_install_name'] + RbConfig::CONFIG['EXEEXT']

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

module Homebrew extend self
  include FileUtils

  attr_accessor :failed
  alias_method :failed?, :failed
end

require 'metafiles'
FORMULA_META_FILES = Metafiles.new
ISSUES_URL = "https://github.com/Homebrew/homebrew/wiki/troubleshooting"
HOMEBREW_PULL_OR_COMMIT_URL_REGEX = 'https:\/\/github.com\/(\w+)\/homebrew(-\w+)?\/(pull\/(\d+)|commit\/\w{4,40})'

require 'compat' unless ARGV.include? "--no-compat" or ENV['HOMEBREW_NO_COMPAT']

ORIGINAL_PATHS = ENV['PATH'].split(File::PATH_SEPARATOR).map{ |p| Pathname.new(p).expand_path rescue nil }.compact.freeze

SUDO_BAD_ERRMSG = <<-EOS.undent
  You can use brew with sudo, but only if the brew executable is owned by root.
  However, this is both not recommended and completely unsupported so do so at
  your own risk.
EOS
