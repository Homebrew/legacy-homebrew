require 'testing_env'

require 'extend/ARGV' # needs to be after test/unit to avoid conflict with OptionsParser
ARGV.extend(HomebrewArgvExtension)

require 'extend/ENV'
ENV.extend(HomebrewEnvExtension)

require 'test/testball'

class CompilerTests < Test::Unit::TestCase
  def setup
    %w{HOMEBREW_USE_CLANG HOMEBREW_USE_LLVM HOMEBREW_USE_GCC}.each { |v| ENV.delete(v) }
  end

  def teardown
    ENV.send MacOS.default_compiler
  end

  def test_llvm_failure
    f = TestLLVMFailure.new
    cs = CompilerSelector.new(f)

    assert !(f.fails_with? :clang)
    assert f.fails_with? :llvm
    assert !(f.fails_with? :gcc)

    cs.select_compiler

    assert_equal case MacOS.clang_build_version
      when 0..210 then :gcc
      else :clang
      end, ENV.compiler
  end

  def test_all_compiler_failures
    f = TestAllCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert f.fails_with? :clang
    assert f.fails_with? :llvm
    assert f.fails_with? :gcc

    cs.select_compiler

    assert_equal MacOS.default_compiler, ENV.compiler
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

    cs.select_compiler

    assert_equal MacOS.default_compiler, ENV.compiler
  end

  def test_mixed_compiler_failures
    f = TestMixedCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert f.fails_with? :clang
    assert !(f.fails_with? :llvm)
    assert f.fails_with? :gcc

    cs.select_compiler

    assert_equal :llvm, ENV.compiler
  end

  def test_more_mixed_compiler_failures
    f = TestMoreMixedCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert !(f.fails_with? :clang)
    assert f.fails_with? :llvm
    assert f.fails_with? :gcc

    cs.select_compiler

    assert_equal :clang, ENV.compiler
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

    cs.select_compiler

    assert_equal case MacOS.clang_build_version
      when 0..210 then :gcc
      else :clang
      end, ENV.compiler
  end

  def test_block_with_no_build_compiler_failures
    f = TestBlockWithoutBuildCompilerFailure.new
    cs = CompilerSelector.new(f)

    assert f.fails_with? :clang
    assert !(f.fails_with? :llvm)
    assert !(f.fails_with? :gcc)

    cs.select_compiler

    assert_equal MacOS.default_compiler, ENV.compiler
  end
end
