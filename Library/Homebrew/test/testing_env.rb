# This software is in the public domain, furnished "as is", without technical
# support, and with no warranty, express or implied, as to its usefulness for
# any purpose.

# Require this file to build a testing environment.

ABS__FILE__ = File.expand_path(__FILE__)
$:.push(File.expand_path(__FILE__+'/../..'))

require 'extend/module'
require 'extend/fileutils'
require 'extend/pathname'
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
HOMEBREW_USER_AGENT    = 'Homebrew'
HOMEBREW_WWW           = 'http://example.com'
HOMEBREW_CURL_ARGS     = '-fsLA'
HOMEBREW_VERSION       = '0.9-test'

RUBY_BIN = Pathname.new("#{RbConfig::CONFIG['bindir']}")
RUBY_PATH = RUBY_BIN + RbConfig::CONFIG['ruby_install_name'] + RbConfig::CONFIG['EXEEXT']

MACOS = true
MACOS_FULL_VERSION = `/usr/bin/sw_vers -productVersion`.chomp
MACOS_VERSION = ENV.fetch('MACOS_VERSION') { MACOS_FULL_VERSION[/10\.\d+/] }.to_f

ORIGINAL_PATHS = ENV['PATH'].split(':').map{ |p| Pathname.new(p).expand_path rescue nil }.compact.freeze

module Homebrew extend self
  include FileUtils
end

# Test environment setup
%w{Library/Formula Library/ENV}.each do |d|
  HOMEBREW_REPOSITORY.join(d).mkpath
end

at_exit { HOMEBREW_PREFIX.parent.rmtree }

# Test fixtures and files can be found relative to this path
TEST_FOLDER = Pathname.new(ABS__FILE__).parent.realpath

def shutup
  if ARGV.verbose?
    yield
  else
    begin
      tmperr = $stderr.clone
      tmpout = $stdout.clone
      $stderr.reopen '/dev/null', 'w'
      $stdout.reopen '/dev/null', 'w'
      yield
    ensure
      $stderr.reopen tmperr
      $stdout.reopen tmpout
    end
  end
end

require 'compat' unless ARGV.include? "--no-compat" or ENV['HOMEBREW_NO_COMPAT']

require 'test/unit' # must be after at_exit
require 'extend/ARGV' # needs to be after test/unit to avoid conflict with OptionsParser
require 'extend/ENV'
ARGV.extend(HomebrewArgvExtension)
ENV.extend(HomebrewEnvExtension)

begin
  require 'rubygems'
  require 'mocha/setup'
rescue LoadError
  warn 'The mocha gem is required to run some tests, expect failures'
end

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
end

module Test::Unit::Assertions
  def assert_empty(obj, msg=nil)
    assert_respond_to(obj, :empty?, msg)
    assert(obj.empty?, msg)
  end unless method_defined?(:assert_empty)
end

class Test::Unit::TestCase
  def formula(*args, &block)
    @_f = Class.new(Formula, &block).new(*args)
  end
end
