require 'testing_env'

require 'extend/ARGV' # needs to be after test/unit to avoid conflict with OptionsParser
ARGV.extend(HomebrewArgvExtension)

require 'extend/ENV'
ENV.extend(HomebrewEnvExtension)

require 'test/testball'

module CompilerTestsEnvExtension
  def unset_use_cc
    vars = %w{HOMEBREW_USE_CLANG HOMEBREW_USE_LLVM HOMEBREW_USE_GCC}
    vars.each { |v| ENV.delete(v) }
  end
end
ENV.extend(CompilerTestsEnvExtension)

class CompilerTests < Test::Unit::TestCase
  def test_llvm_failure
    ENV.unset_use_cc
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

    ENV.send MacOS.default_compiler
  end

  def test_all_compiler_failures
    ENV.unset_use_cc
    f = TestAllCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert f.fails_with? :clang
    assert f.fails_with? :llvm
    assert f.fails_with? :gcc

    cs.select_compiler

    assert_equal MacOS.default_compiler, ENV.compiler

    ENV.send MacOS.default_compiler
  end

  def test_no_compiler_failures
    ENV.unset_use_cc
    f = TestNoCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert !(f.fails_with? :clang)
    assert !(f.fails_with? :llvm)
    assert case MacOS.gcc_42_build_version
      when 0 then f.fails_with? :gcc
      else !(f.fails_with? :gcc)
      end

    cs.select_compiler

    assert_equal MacOS.default_compiler, ENV.compiler

    ENV.send MacOS.default_compiler
  end

  def test_mixed_compiler_failures
    ENV.unset_use_cc
    f = TestMixedCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert f.fails_with? :clang
    assert !(f.fails_with? :llvm)
    assert f.fails_with? :gcc

    cs.select_compiler

    assert_equal :llvm, ENV.compiler

    ENV.send MacOS.default_compiler
  end

  def test_more_mixed_compiler_failures
    ENV.unset_use_cc
    f = TestMoreMixedCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert !(f.fails_with? :clang)
    assert f.fails_with? :llvm
    assert f.fails_with? :gcc

    cs.select_compiler

    assert_equal :clang, ENV.compiler

    ENV.send MacOS.default_compiler
  end

  def test_even_more_mixed_compiler_failures
    ENV.unset_use_cc
    f = TestEvenMoreMixedCompilerFailures.new
    cs = CompilerSelector.new(f)

    assert f.fails_with? :clang
    assert f.fails_with? :llvm
    assert case MacOS.gcc_42_build_version
      when 0 then f.fails_with? :gcc
      else !(f.fails_with? :gcc)
      end

    cs.select_compiler

    assert_equal case MacOS.clang_build_version
      when 0..210 then :gcc
      else :clang
      end, ENV.compiler

    ENV.send MacOS.default_compiler
  end

  def test_block_with_no_build_compiler_failures
    ENV.unset_use_cc
    f = TestBlockWithoutBuildCompilerFailure.new
    cs = CompilerSelector.new(f)

    assert f.fails_with? :clang
    assert !(f.fails_with? :llvm)
    assert !(f.fails_with? :gcc)

    cs.select_compiler

    assert_equal MacOS.default_compiler, ENV.compiler

    ENV.send MacOS.default_compiler
  end
end
