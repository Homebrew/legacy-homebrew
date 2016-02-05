$:.unshift File.expand_path("../..", __FILE__)
$:.unshift File.expand_path("../lib", __FILE__)

require "simplecov" if ENV["HOMEBREW_TESTS_COVERAGE"]
require "global"
require "formulary"

# Test environment setup
%w[ENV Formula].each { |d| HOMEBREW_LIBRARY.join(d).mkpath }
%w[cache formula_cache cellar logs].each { |d| HOMEBREW_PREFIX.parent.join(d).mkpath }

# Test fixtures and files can be found relative to this path
TEST_DIRECTORY = File.dirname(File.expand_path(__FILE__))

begin
  require "rubygems"
  require "minitest/autorun"
  require "mocha/setup"
rescue LoadError
  abort "Run `bundle install` or install the mocha and minitest gems before running the tests"
end

module Homebrew
  module VersionAssertions
    def version(v)
      Version.new(v)
    end

    def assert_version_equal(expected, actual)
      assert_equal Version.new(expected), actual
    end

    def assert_version_detected(expected, url)
      assert_equal expected, Version.parse(url).to_s
    end

    def assert_version_nil(url)
      assert_nil Version.parse(url)
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
    include FSLeakLogger

    TEST_SHA1   = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeef".freeze
    TEST_SHA256 = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef".freeze

    def formula(name = "formula_name", path = Formulary.core_path(name), spec = :stable, &block)
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

    def mktmpdir(prefix_suffix = nil, &block)
      Dir.mktmpdir(prefix_suffix, HOMEBREW_TEMP, &block)
    end

    def needs_compat
      skip "Requires compat/ code" if ENV["HOMEBREW_NO_COMPAT"]
    end

    def assert_nothing_raised
      yield
    end

    def assert_eql(exp, act, msg = nil)
      msg = message(msg, "") { diff exp, act }
      assert exp.eql?(act), msg
    end

    def refute_eql(exp, act, msg = nil)
      msg = message(msg) {
        "Expected #{mu_pp(act)} to not be eql to #{mu_pp(exp)}"
      }
      refute exp.eql?(act), msg
    end
  end
end
