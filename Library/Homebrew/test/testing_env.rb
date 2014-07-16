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
require 'tmpdir'

TEST_TMPDIR = Dir.mktmpdir("homebrew_tests")
at_exit { FileUtils.remove_entry(TEST_TMPDIR) }

# Constants normally defined in global.rb
HOMEBREW_PREFIX        = Pathname.new(TEST_TMPDIR).join("prefix")
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

# Test environment setup
%w{ENV Formula}.each { |d| HOMEBREW_LIBRARY.join(d).mkpath }
%w{cache formula_cache cellar logs}.each { |d| HOMEBREW_PREFIX.parent.join(d).mkpath }

# Test fixtures and files can be found relative to this path
TEST_DIRECTORY = File.dirname(File.expand_path(__FILE__))

ARGV.extend(HomebrewArgvExtension)

begin
  require "rubygems"
  require "minitest/autorun"
  require "mocha/setup"
rescue LoadError
  abort "Run `rake deps` or install the mocha and minitest gems before running the tests"
end

module Homebrew
  include FileUtils
  extend self

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

  module FSLeakLogger
    def self.included(klass)
      require "find"
      @@log = File.open("fs_leak_log", "w")
      klass.make_my_diffs_pretty!
    end

    def before_setup
      @__files_before_test = []
      Find.find(TEST_TMPDIR) { |f| @__files_before_test << f.sub(TEST_TMPDIR, "") }
      super
    end

    def after_teardown
      super
      files_after_test = []
      Find.find(TEST_TMPDIR) { |f| files_after_test << f.sub(TEST_TMPDIR, "") }
      if @__files_before_test != files_after_test
        @@log.puts location, diff(@__files_before_test, files_after_test)
      end
    end
  end

  class TestCase < ::Minitest::Test
    include VersionAssertions
    include FSLeakLogger if ENV["LOG_FS_LEAKS"]

    TEST_SHA1   = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeef".freeze
    TEST_SHA256 = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef".freeze

    def formula(name="formula_name", path=Formula.path(name), spec=:stable, &block)
      @_f = Class.new(Formula, &block).new(name, path, spec)
    end

    def shutup
      err = $stderr.dup
      out = $stdout.dup

      begin
        $stderr.reopen("/dev/null")
        $stdout.reopen("/dev/null")
        yield
      ensure
        $stderr.reopen(err)
        $stdout.reopen(out)
        err.close
        out.close
      end
    end

    def assert_nothing_raised
      yield
    end

    def assert_eql(exp, act, msg=nil)
      msg = message(msg, "") { diff exp, act }
      assert exp.eql?(act), msg
    end

    def refute_eql(exp, act, msg=nil)
      msg = message(msg) {
        "Expected #{mu_pp(act)} to not be eql to #{mu_pp(exp)}"
      }
      refute exp.eql?(act), msg
    end
  end
end
