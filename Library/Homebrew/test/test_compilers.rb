require 'testing_env'
require 'test/testball'

class CompilerTests < Test::Unit::TestCase
  def test_llvm_failure
    f = TestLLVMFailure.new
    cs = CompilerSelector.new(f)

    assert !(f.fails_with? :clang)
    assert f.fails_with? :llvm
    assert !(f.fails_with? :gcc)
    assert_equal case MacOS.clang_build_version
      when 0..210 then :gcc
      else :clang
      end, cs.compiler
  end

  def test_all_compiler_failures
    f = TestAllCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert f.fails_with? :clang
    assert f.fails_with? :llvm
    assert f.fails_with? :gcc
    assert_equal MacOS.default_compiler, cs.compiler
  end

  def test_no_compiler_failures
    f = TestNoCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert !(f.fails_with? :clang)
    assert !(f.fails_with? :llvm)
    assert case MacOS.gcc_42_build_version
      when nil then f.fails_with? :gcc
      else !(f.fails_with? :gcc)
      end
    assert_equal MacOS.default_compiler, cs.compiler
  end

  def test_mixed_compiler_failures
    f = TestMixedCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert f.fails_with? :clang
    assert !(f.fails_with? :llvm)
    assert f.fails_with? :gcc
    assert_equal :llvm, cs.compiler
  end

  def test_more_mixed_compiler_failures
    f = TestMoreMixedCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert !(f.fails_with? :clang)
    assert f.fails_with? :llvm
    assert f.fails_with? :gcc
    assert_equal :clang, cs.compiler
  end

  def test_even_more_mixed_compiler_failures
    f = TestEvenMoreMixedCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert f.fails_with? :clang
    assert f.fails_with? :llvm
    assert case MacOS.gcc_42_build_version
      when nil then f.fails_with? :gcc
      else !(f.fails_with? :gcc)
      end
    assert_equal case MacOS.gcc_42_build_version
      when nil then :llvm
      else :gcc
      end, cs.compiler
  end

  def test_block_with_no_build_compiler_failures
    f = TestBlockWithoutBuildCompilerFailure.new
    cs = CompilerSelector.new(f)

    assert f.fails_with? :clang
    assert !(f.fails_with? :llvm)
    assert !(f.fails_with? :gcc)
    assert_not_equal :clang, cs.compiler
  end
end
