require 'testing_env'
require 'test/testball'

class FailsWithTests < Test::Unit::TestCase
  class Double < Compiler
    attr_accessor :name, :build, :version
  end

  def assert_fails_with(cc)
    assert @f.new.fails_with?(cc)
  end

  def assert_does_not_fail_with(cc)
    assert !@f.new.fails_with?(cc)
  end

  def fails_with(*args, &block)
    @f.send(:fails_with, *args, &block)
  end

  def build_cc(sym, build, version=nil)
    cc = Double.new
    cc.name = sym
    cc.build = build
    cc.version = version
    cc
  end

  def setup
    @f = Class.new(TestBall)
  end

  def test_fails_with_symbol
    fails_with :clang
    cc = build_cc(:clang, 425)
    assert_fails_with cc
  end

  def test_fails_with_build
    fails_with(:clang) { build 211 }
    cc = build_cc(:clang, 318)
    assert_does_not_fail_with cc
  end

  def test_fails_with_block_without_build
    fails_with(:clang) { }
    cc = build_cc(:clang, 425)
    assert_fails_with cc
  end

  def test_non_apple_gcc_version
    fails_with(:gcc => '4.8.2')
    cc = build_cc("gcc-4.8", nil, "4.8.1")
    assert_fails_with cc
  end

  def test_multiple_failures
    fails_with(:llvm)
    fails_with(:clang)
    gcc = build_cc(:gcc, 5666)
    llvm = build_cc(:llvm, 2336)
    clang = build_cc(:clang, 425)
    assert_fails_with llvm
    assert_fails_with clang
    assert_does_not_fail_with gcc
  end
end
