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
    # Yes, this is ugly - we only want one GCC version to be available.
    MacOS.send(:alias_method, :old_non_apple_gcc_version, :non_apple_gcc_version)
    MacOS.send(:define_method, :non_apple_gcc_version) do |name|
      if name == 'gcc-4.8'
        '4.8.1'
      else
        nil
      end
    end
    @f  = Double.new
    @cc = :clang
  end

  def teardown
    MacOS.send(:alias_method, :non_apple_gcc_version, :old_non_apple_gcc_version)
  end

  def actual_cc
    CompilerSelector.new(@f).compiler
  end

  def test_all_compiler_failures
    @f << :clang << :llvm << :gcc << 'gcc-4.8'
    assert_raise(CompilerSelectionError) { actual_cc }
  end

  def test_no_compiler_failures
    assert_equal @cc, actual_cc
  end

  def test_fails_with_clang
    @f << :clang
    assert_equal :gcc, actual_cc
  end

  def test_fails_with_llvm
    @f << :llvm
    assert_equal :clang, actual_cc
  end

  def test_fails_with_gcc
    @f << :gcc
    assert_equal :clang, actual_cc
  end

  def test_fails_with_non_apple_gcc
    @f << "gcc-4.8"
    assert_equal :clang, actual_cc
  end

  def test_mixed_failures_1
    @f << :clang << :llvm
    assert_equal :gcc, actual_cc
  end

  def test_mixed_failures_2
    @f << :gcc << :clang << 'gcc-4.8'
    assert_equal :llvm, actual_cc
  end

  def test_mixed_failures_3
    @f << :llvm << :gcc
    assert_equal :clang, actual_cc
  end

  def test_mixed_failures_4
    @f << :clang << "gcc-4.8"
    assert_equal :gcc, actual_cc
  end

  def test_older_clang_precedence
    MacOS.stubs(:clang_build_version).returns(211)
    @f << :gcc << 'gcc-4.8'
    assert_equal :llvm, actual_cc
  end

  def test_non_apple_gcc_precedence
    @f << :clang << :gcc
    assert_equal 'gcc-4.8', actual_cc
  end

  def test_missing_gcc
    MacOS.stubs(:gcc_build_version).returns(nil)
    @f << :clang << :llvm << 'gcc-4.8'
    assert_raise(CompilerSelectionError) { actual_cc }
  end

  def test_missing_llvm_and_gcc
    MacOS.stubs(:gcc_build_version).returns(nil)
    MacOS.stubs(:llvm_build_version).returns(nil)
    @f << :clang << 'gcc-4.8'
    assert_raise(CompilerSelectionError) { actual_cc }
  end
end
