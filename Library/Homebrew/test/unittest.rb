#!/usr/bin/ruby
# This software is in the public domain, furnished "as is", without technical
# support, and with no warranty, express or implied, as to its usefulness for
# any purpose.

ABS__FILE__=File.expand_path(__FILE__)

$:.push(File.expand_path(__FILE__+'/../..'))
require 'extend/pathname'

# these are defined in global.rb, but we don't want to break our actual
# homebrew tree, and we do want to test everything :)
HOMEBREW_PREFIX=Pathname.new '/private/tmp/testbrew/prefix'
HOMEBREW_REPOSITORY=HOMEBREW_PREFIX
HOMEBREW_CACHE=HOMEBREW_PREFIX.parent+"cache"
HOMEBREW_CELLAR=HOMEBREW_PREFIX.parent+"cellar"
HOMEBREW_USER_AGENT="Homebrew"
HOMEBREW_WWW='http://example.com'
MACOS_VERSION=10.6

(HOMEBREW_PREFIX+'Library'+'Formula').mkpath
Dir.chdir HOMEBREW_PREFIX
at_exit { HOMEBREW_PREFIX.parent.rmtree }

require 'utils'
require 'hardware'
require 'formula'
require 'download_strategy'
require 'keg'
require 'utils'
require 'brew.h'
require 'hardware'
require 'update'

# for some reason our utils.rb safe_system behaves completely differently 
# during these tests. This is worrying for sure.
def safe_system *args
  Kernel.system *args
end

class ExecutionError <RuntimeError
  attr :status

  def initialize cmd, args=[], status=nil
    super "Failure while executing: #{cmd} #{args*' '}"
    @status = status
  end
end

class BuildError <ExecutionError; end

require 'test/unit' # must be after at_exit
require 'extend/ARGV' # needs to be after test/unit to avoid conflict with OptionsParser
ARGV.extend(HomebrewArgvExtension)


class MockFormula <Formula
  def initialize url
    @url=url
    @homepage = 'http://example.com/'
    super 'test'
  end
end

class MostlyAbstractFormula <Formula
  @url=''
  @homepage = 'http://example.com/'
end

class TestBall <Formula
  # name parameter required for some Formula::factory
  def initialize name=nil
    @url="file:///#{Pathname.new(ABS__FILE__).parent.realpath}/testball-0.1.tbz"
    @homepage = 'http://example.com/'
    super "testball"
  end
  def install
    prefix.install "bin"
    prefix.install "libexec"
  end
end

class TestZip <Formula
  def initialize
    zip=HOMEBREW_CACHE.parent+'test-0.1.zip'
    Kernel.system '/usr/bin/zip', '-0', zip, ABS__FILE__
    @url="file://#{zip}"
    @homepage = 'http://example.com/'
    super 'testzip'
  end
end

class TestBadVersion <TestBall
  @version="versions can't have spaces"
end

class TestBallOverrideBrew <Formula
  def initialize
    super "foo"
  end
  def brew
  end
end

class TestScriptFileFormula <ScriptFileFormula
  url "file:///#{Pathname.new(ABS__FILE__).realpath}"
  version "1"
  
  def initialize
    @name='test-script-formula'
    @homepage = 'http://example.com/'
    super
  end
end

class RefreshBrewMock < RefreshBrew
  def in_prefix_expect(expect, returns = '')
    @expect ||= {}
    @expect[expect] = returns
  end
  
  def `(cmd)
    if Dir.pwd == HOMEBREW_PREFIX.to_s and @expect.has_key?(cmd)
      (@called ||= []) << cmd
      @expect[cmd]
    else
      raise "#{inspect} Unexpectedly called backticks in pwd `#{HOMEBREW_PREFIX}' and command `#{cmd}'"
    end
  end
  
  def expectations_met?
    @expect.keys.sort == @called.sort
  end
  
  def inspect
    "#<#{self.class.name} #{object_id}>"
  end
end

module ExtendArgvPlusYeast
  def reset
    @named = nil
    @downcased_unique_named = nil
    @formulae = nil
    @kegs = nil
    ARGV.shift while ARGV.length > 0
  end
end
ARGV.extend ExtendArgvPlusYeast

require 'test/test_versions'
require 'test/test_checksums'
require 'test/test_updater' unless ARGV.include? "--skip-update"
require 'test/test_bucket'
require 'test/test_inreplace'
