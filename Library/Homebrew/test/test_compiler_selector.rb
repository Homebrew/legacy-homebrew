require 'testing_env'
require 'compilers'

class CompilerSelectorTests < Test::Unit::TestCase
  class Double
    def initialize
      @failures = []
    end

    def <<(cc)
      @failures << cc
    end

    def fails_with?(cc)
      return false if cc.nil?
      @failures.include?(cc.name)
    end
  end

  def setup
    MacOS.stubs(:gcc_4_0_build_version).returns(nil)
    MacOS.stubs(:gcc_build_version).returns(5666)
    MacOS.stubs(:llvm_build_version).returns(2336)
    MacOS.stubs(:clang_build_version).returns(425)
    @f  = Double.new
    @cc = :clang
  end

  def actual_cc
    CompilerSelector.new(@f).compiler
  end

  def test_all_compiler_failures
    @f << :clang << :llvm << :gcc
    assert_raise(CompilerSelectionError) { actual_cc }
  end

  def test_no_compiler_failures
    assert_equal @cc, actual_cc
  end

  def test_fails_with_clang
    @f << :clang
    assert_equal :llvm, actual_cc
  end

  def test_fails_with_llvm
    @f << :llvm
    assert_equal :clang, actual_cc
  end

  def test_fails_with_gcc
    @f << :gcc
    assert_equal :clang, actual_cc
  end

  def test_mixed_failures_1
    @f << :clang << :llvm
    assert_equal :gcc, actual_cc
  end

  def test_mixed_failures_2
    @f << :gcc << :clang
    assert_equal :llvm, actual_cc
  end

  def test_mixed_failures_3
    @f << :llvm << :gcc
    assert_equal :clang, actual_cc
  end

  def test_older_clang_precedence
    MacOS.stubs(:clang_build_version).returns(211)
    @f << :gcc
    assert_equal :llvm, actual_cc
  end

  def test_missing_gcc
    MacOS.stubs(:gcc_build_version).returns(nil)
    @f << :clang << :llvm
    assert_raise(CompilerSelectionError) { actual_cc }
  end

  def test_missing_llvm_and_gcc
    MacOS.stubs(:gcc_build_version).returns(nil)
    MacOS.stubs(:llvm_build_version).returns(nil)
    @f << :clang
    assert_raise(CompilerSelectionError) { actual_cc }
  end
end
