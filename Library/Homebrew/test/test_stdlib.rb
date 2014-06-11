require 'testing_env'
require 'test/testball'
require 'formula'
require 'cxxstdlib'
require 'tab'

class CxxStdlibTests < Homebrew::TestCase
  def setup
    @clang = CxxStdlib.new(:libstdcxx, :clang)
    @gcc   = CxxStdlib.new(:libstdcxx, :gcc)
    @llvm  = CxxStdlib.new(:libstdcxx, :llvm)
    @gcc4  = CxxStdlib.new(:libstdcxx, :gcc_4_0)
    @gcc48 = CxxStdlib.new(:libstdcxx, 'gcc-4.8')
    @gcc49 = CxxStdlib.new(:libstdcxx, 'gcc-4.9')
    @lcxx  = CxxStdlib.new(:libcxx, :clang)
    @purec = CxxStdlib.new(nil, :clang)
  end

  def test_apple_libstdcxx_intercompatibility
    assert @clang.compatible_with?(@gcc)
    assert @clang.compatible_with?(@llvm)
    assert @clang.compatible_with?(@gcc4)
  end

  def test_compatibility_same_compilers_and_type
    assert @gcc.compatible_with?(@gcc)
    assert @gcc48.compatible_with?(@gcc48)
    assert @clang.compatible_with?(@clang)
  end

  def test_apple_gnu_libstdcxx_incompatibility
    assert !@clang.compatible_with?(@gcc48)
    assert !@gcc48.compatible_with?(@clang)
  end

  def test_gnu_cross_version_incompatibility
    assert !@gcc48.compatible_with?(@gcc49)
    assert !@gcc49.compatible_with?(@gcc48)
  end

  def test_libstdcxx_libcxx_incompatibility
    assert !@clang.compatible_with?(@lcxx)
    assert !@lcxx.compatible_with?(@clang)
  end

  def test_apple_compiler_reporting
    assert_predicate @clang, :apple_compiler?
    assert_predicate @gcc, :apple_compiler?
    assert_predicate @llvm, :apple_compiler?
    assert_predicate @gcc4, :apple_compiler?
    refute_predicate @gcc48, :apple_compiler?
  end

  def test_type_string_formatting
    assert_equal "libstdc++", @clang.type_string
    assert_equal "libc++", @lcxx.type_string
  end

  def test_constructing_from_tab
    stdlib = Tab.dummy_tab.cxxstdlib
    assert_equal :clang, stdlib.compiler
    assert_nil stdlib.type
  end

  def test_compatibility_for_non_cxx_software
    assert @purec.compatible_with?(@clang)
  end
end
