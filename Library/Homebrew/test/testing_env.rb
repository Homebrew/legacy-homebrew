# Require this file to build a testing environment.

$:.push(File.expand_path(__FILE__+'/../..'))

require 'extend/module'
require 'extend/fileutils'
require 'extend/pathname'
require 'extend/ARGV'
require 'extend/string'
require 'extend/symbol'
require 'extend/enumerable'
require 'exceptions'
require 'utils'
require 'rbconfig'

# Constants normally defined in global.rb
HOMEBREW_PREFIX        = Pathname.new('/private/tmp/testbrew/prefix')
HOMEBREW_REPOSITORY    = HOMEBREW_PREFIX
HOMEBREW_LIBRARY       = HOMEBREW_REPOSITORY+'Library'
HOMEBREW_CACHE         = HOMEBREW_PREFIX.parent+'cache'
HOMEBREW_CACHE_FORMULA = HOMEBREW_PREFIX.parent+'formula_cache'
HOMEBREW_CELLAR        = HOMEBREW_PREFIX.parent+'cellar'
HOMEBREW_LOGS          = HOMEBREW_PREFIX.parent+'logs'
HOMEBREW_TEMP          = Pathname.new(ENV.fetch('HOMEBREW_TEMP', '/tmp'))
HOMEBREW_USER_AGENT    = 'Homebrew'
HOMEBREW_WWW           = 'http://example.com'
HOMEBREW_CURL_ARGS     = '-fsLA'
HOMEBREW_VERSION       = '0.9-test'

require 'tap_constants'

if RbConfig.respond_to?(:ruby)
  RUBY_PATH = Pathname.new(RbConfig.ruby)
else
  RUBY_PATH = Pathname.new(RbConfig::CONFIG["bindir"]).join(
    RbConfig::CONFIG["ruby_install_name"] + RbConfig::CONFIG["EXEEXT"]
  )
end
RUBY_BIN = RUBY_PATH.dirname

MACOS_FULL_VERSION = `/usr/bin/sw_vers -productVersion`.chomp
MACOS_VERSION = ENV.fetch('MACOS_VERSION') { MACOS_FULL_VERSION[/10\.\d+/] }

ORIGINAL_PATHS = ENV['PATH'].split(File::PATH_SEPARATOR).map{ |p| Pathname.new(p).expand_path rescue nil }.compact.freeze

module Homebrew extend self
  include FileUtils
end

# Test environment setup
%w{Library/Formula Library/ENV}.each do |d|
  HOMEBREW_REPOSITORY.join(d).mkpath
end

at_exit { HOMEBREW_PREFIX.parent.rmtree }

# Test fixtures and files can be found relative to this path
TEST_DIRECTORY = File.dirname(File.expand_path(__FILE__))

require 'compat' unless ARGV.include? "--no-compat" or ENV['HOMEBREW_NO_COMPAT']

ARGV.extend(HomebrewArgvExtension)

begin
  require "rubygems"
  require "minitest/autorun"
  require "mocha/setup"
rescue LoadError
  abort "Run `rake deps` or install the mocha and minitest gems before running the tests"
end

module Homebrew
  module VersionAssertions
    def version v
      Version.new(v)
    end

    def assert_version_equal expected, actual
      assert_equal Version.new(expected), actual
    end

    def assert_version_detected expected, url
      assert_equal expected, Version.parse(url).to_s
    end

    def assert_version_nil url
      assert_nil Version.parse(url)
    end

    def assert_version_tokens tokens, version
      assert_equal tokens, version.send(:tokens).map(&:to_s)
    end
  end

  class TestCase < ::Minitest::Test
    include VersionAssertions

    TEST_SHA1   = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeef".freeze
    TEST_SHA256 = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef".freeze

    def formula(name="formula_name", path=Formula.path(name), &block)
      @_f = Class.new(Formula, &block).new(name, path)
    end

    def shutup
      err = $stderr.clone
      out = $stdout.clone

      begin
        $stderr.reopen("/dev/null", "w")
        $stdout.reopen("/dev/null", "w")
        yield
      ensure
        $stderr.reopen(err)
        $stdout.reopen(out)
      end
    end

    def assert_nothing_raised
      yield
    end
  end
end
