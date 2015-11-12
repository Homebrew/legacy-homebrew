require "testing_env"
require "formula"
require "cxxstdlib"

class CxxStdlibTests < Homebrew::TestCase
  def setup
    @clang = CxxStdlib.create(:libstdcxx, :clang)
    @gcc   = CxxStdlib.create(:libstdcxx, :gcc)
    @llvm  = CxxStdlib.create(:libstdcxx, :llvm)
    @gcc4  = CxxStdlib.create(:libstdcxx, :gcc_4_0)
    @gcc48 = CxxStdlib.create(:libstdcxx, "gcc-4.8")
    @gcc49 = CxxStdlib.create(:libstdcxx, "gcc-4.9")
    @lcxx  = CxxStdlib.create(:libcxx, :clang)
    @purec = CxxStdlib.create(nil, :clang)
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

  def test_compatibility_for_non_cxx_software
    assert @purec.compatible_with?(@clang)
    assert @clang.compatible_with?(@purec)
    assert @purec.compatible_with?(@purec)
    assert @purec.compatible_with?(@gcc48)
    assert @gcc48.compatible_with?(@purec)
  end
end
