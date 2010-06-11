require 'extend/pathname'
require 'extend/ARGV'
require 'extend/string'
require 'utils'

ARGV.extend(HomebrewArgvExtension)

HOMEBREW_VERSION = 0.6
HOMEBREW_WWW = 'http://mxcl.github.com/homebrew/'

if Process.uid == 0
  # technically this is not the correct place, this cache is for *all users*
  # so in that case, maybe we should always use it, root or not?
  HOMEBREW_CACHE=Pathname.new("/Library/Caches/Homebrew")
else
  HOMEBREW_CACHE=Pathname.new("~/Library/Caches/Homebrew").expand_path
end

if not defined? HOMEBREW_BREW_FILE
  HOMEBREW_BREW_FILE = ENV['HOMEBREW_BREW_FILE'] || `which brew`.chomp
end

HOMEBREW_PREFIX = Pathname.new(HOMEBREW_BREW_FILE).dirname.parent # Where we link under
HOMEBREW_REPOSITORY = Pathname.new(HOMEBREW_BREW_FILE).realpath.dirname.parent # Where .git is found

# Where should be build to? 
# If /usr/local/Cellar exists, as a symlink or real folder, use that.
# Otherwise, build into a Cellar in the Repo. folder.
if (HOMEBREW_PREFIX+'Cellar').exist?
  HOMEBREW_CELLAR = HOMEBREW_PREFIX+'Cellar'
else
  HOMEBREW_CELLAR = HOMEBREW_REPOSITORY+'Cellar'
end

MACOS_FULL_VERSION = `/usr/bin/sw_vers -productVersion`.chomp
MACOS_VERSION = /(10\.\d+)(\.\d+)?/.match(MACOS_FULL_VERSION).captures.first.to_f

HOMEBREW_USER_AGENT = "Homebrew #{HOMEBREW_VERSION} (Ruby #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}; Mac OS X #{MACOS_FULL_VERSION})"


RECOMMENDED_LLVM = 2206
RECOMMENDED_GCC_40 = 5493
RECOMMENDED_GCC_42 = (MACOS_VERSION >= 10.6) ? 5646 : 5577


class ExecutionError <RuntimeError
  attr :exit_status
  attr :command

  def initialize cmd, args = [], es = nil
    @command = cmd
    super "Failure while executing: #{cmd} #{pretty(args)*' '}"
    @exit_status = es.exitstatus rescue 1
  end

  def was_running_configure?
    @command == './configure'
  end

  private

  def pretty args
    args.collect do |arg|
      if arg.to_s.include? ' '
        "'#{ arg.gsub "'", "\\'" }'"
      else
        arg
      end
    end
  end
end

class BuildError <ExecutionError
  attr :env

  def initialize cmd, args = [], es = nil
    super
    @env = ENV.to_hash
  end
end
