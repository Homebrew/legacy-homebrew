require "extend/module"
require "extend/fileutils"
require "extend/pathname"
require "extend/ARGV"
require "extend/string"
require "extend/enumerable"
require "os"
require "utils"
require "exceptions"
require "set"
require "rbconfig"

ARGV.extend(HomebrewArgvExtension)

HOMEBREW_VERSION = "1.0.0"
HOMEBREW_WWW = "http://brew.sh"

require "config"

if RbConfig.respond_to?(:ruby)
  RUBY_PATH = Pathname.new(RbConfig.ruby)
else
  RUBY_PATH = Pathname.new(RbConfig::CONFIG["bindir"]).join(
    RbConfig::CONFIG["ruby_install_name"] + RbConfig::CONFIG["EXEEXT"]
  )
end
RUBY_BIN = RUBY_PATH.dirname

HOMEBREW_GITHUB_API_TOKEN = ENV["HOMEBREW_GITHUB_API_TOKEN"]
HOMEBREW_USER_AGENT = "Homebrew #{HOMEBREW_VERSION} (Ruby #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}; #{OS_VERSION})"

HOMEBREW_CURL_ARGS = "-f#LA"

require "tap_constants"

module Homebrew
  include FileUtils
  extend self

  attr_accessor :failed
  alias_method :failed?, :failed
end

HOMEBREW_PULL_API_REGEX = %r{https://api\.github\.com/repos/([\w-]+)/homebrew(-[\w-]+)?/pulls/(\d+)}
HOMEBREW_PULL_OR_COMMIT_URL_REGEX = %r[https://github\.com/([\w-]+)/homebrew(-[\w-]+)?/(?:pull/(\d+)|commit/[0-9a-fA-F]{4,40})]

require "compat" unless ARGV.include?("--no-compat") || ENV["HOMEBREW_NO_COMPAT"]

ORIGINAL_PATHS = ENV["PATH"].split(File::PATH_SEPARATOR).map { |p| Pathname.new(p).expand_path rescue nil }.compact.freeze

# TODO: remove this as soon as it's removed from commands.rb.
HOMEBREW_INTERNAL_COMMAND_ALIASES = {
  "ls" => "list",
  "homepage" => "home",
  "-S" => "search",
  "up" => "update",
  "ln" => "link",
  "instal" => "install", # gem does the same
  "rm" => "uninstall",
  "remove" => "uninstall",
  "configure" => "diy",
  "abv" => "info",
  "dr" => "doctor",
  "--repo" => "--repository",
  "environment" => "--env",
  "--config" => "config"
}
