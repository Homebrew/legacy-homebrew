require 'testing_env'
require 'compilers'

class CompilerSelectorTests < Homebrew::TestCase
  class Double
    attr_reader :name

    def initialize
      @failures = []
      @name = "double"
    end

    def <<(cc)
      @failures << cc
    end

    def fails_with?(cc)
      return false if cc.nil?
      @failures.include?(cc.name)
    end
  end

  class CompilerVersions
    attr_accessor :gcc_4_0_build_version, :gcc_build_version,
      :llvm_build_version, :clang_build_version

    def initialize(versions={})
      {
        :gcc_4_0_build_version => nil,
        :gcc_build_version     => 5666,
        :llvm_build_version    => 2336,
        :clang_build_version   => 425,
      }.merge(versions).each { |k, v| instance_variable_set("@#{k}", v) }
    end

    def non_apple_gcc_version(name)
      name == "gcc-4.8" ? "4.8.1" : nil
    end
  end

  def setup
    @f  = Double.new
    @cc = :clang
    @versions = CompilerVersions.new
  end

  def actual_cc
    CompilerSelector.new(@f, @versions).compiler
  end

  def test_all_compiler_failures
    @f << :clang << :llvm << :gcc << 'gcc-4.8'
    assert_raises(CompilerSelectionError) { actual_cc }
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
    @versions = CompilerVersions.new(:clang_build_version => 211)
    @f << :gcc << 'gcc-4.8'
    assert_equal :llvm, actual_cc
  end

  def test_llvm_precedence
    @f << :clang << :gcc
    assert_equal :llvm, actual_cc
  end

  def test_missing_gcc
    @versions = CompilerVersions.new( :gcc_build_version => nil)
    @f << :clang << :llvm << 'gcc-4.8'
    assert_raises(CompilerSelectionError) { actual_cc }
  end

  def test_missing_llvm_and_gcc
    @versions = CompilerVersions.new(
      :gcc_build_version => nil,
      :llvm_build_version => nil
    )
    @f << :clang << 'gcc-4.8'
    assert_raises(CompilerSelectionError) { actual_cc }
  end
end
