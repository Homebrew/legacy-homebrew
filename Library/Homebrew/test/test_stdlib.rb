require 'testing_env'
require 'test/testball'
require 'formula'
require 'cxxstdlib'
require 'tab'

class CxxStdlibTests < Test::Unit::TestCase
  def setup
    @clang = CxxStdlib.new(:libstdcxx, :clang)
    @gcc   = CxxStdlib.new(:libstdcxx, :gcc)
    @llvm  = CxxStdlib.new(:libstdcxx, :llvm)
    @gcc4  = CxxStdlib.new(:libstdcxx, :gcc_4_0)
    @gcc48 = CxxStdlib.new(:libstdcxx, 'gcc-4.8')
    @gcc49 = CxxStdlib.new(:libstdcxx, 'gcc-4.9')
    @lcxx  = CxxStdlib.new(:libcxx, :clang)
  end

  def test_apple_libstdcxx_intercompatibility
    assert @clang.compatible_with?(@gcc)
    assert @clang.compatible_with?(@llvm)
    assert @clang.compatible_with?(@gcc4)
  end

  def test_compatibility_same_compilers_and_type
    assert @gcc48.compatible_with?(@gcc48)
    assert @clang.compatible_with?(@clang)
  end

  def test_apple_gnu_libstdcxx_incompatibility
    assert !@clang.compatible_with?(@gcc48)
    assert !@gcc48.compatible_with?(@clang)
  end

  def test_gnu_cross_version_incompatibility
    assert !@clang.compatible_with?(@gcc48)
    assert !@gcc48.compatible_with?(@clang)
  end

  def test_libstdcxx_libcxx_incompatibility
    assert !@clang.compatible_with?(@lcxx)
    assert !@lcxx.compatible_with?(@clang)
  end

  def test_apple_compiler_reporting
    assert @clang.apple_compiler?
    assert @gcc.apple_compiler?
    assert @llvm.apple_compiler?
    assert @gcc4.apple_compiler?
    assert !@gcc48.apple_compiler?
  end

  def test_type_string_formatting
    assert_equal @clang.type_string, 'libstdc++'
    assert_equal @lcxx.type_string, 'libc++'
  end

  def test_constructing_from_tab
    stdlib = Tab.dummy_tab.cxxstdlib
    assert_equal stdlib.compiler, :clang
    assert_equal stdlib.type, :libstdcxx
  end
end
