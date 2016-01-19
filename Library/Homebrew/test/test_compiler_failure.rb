require "testing_env"
require "compilers"

class CompilerFailureTests < Homebrew::TestCase
  Compiler = Struct.new(:name, :version)

  def assert_fails_with(compiler, failure)
    assert_operator failure, :===, compiler
  end

  def refute_fails_with(compiler, failure)
    refute_operator failure, :===, compiler
  end

  def compiler(name, version)
    Compiler.new(name, version)
  end

  def create(spec, &block)
    CompilerFailure.create(spec, &block)
  end

  def test_create_with_symbol
    failure = create(:clang)
    assert_fails_with compiler(:clang, 425), failure
  end

  def test_create_with_block
    failure = create(:clang) { build 211 }
    assert_fails_with compiler(:clang, 210), failure
    refute_fails_with compiler(:clang, 318), failure
  end

  def test_create_with_block_without_build
    failure = create(:clang) {}
    assert_fails_with compiler(:clang, 425), failure
  end

  def test_create_with_hash
    failure = create(:gcc => "4.8")
    assert_fails_with compiler("gcc-4.8", "4.8"), failure
    assert_fails_with compiler("gcc-4.8", "4.8.1"), failure
    refute_fails_with compiler("gcc-4.7", "4.7"), failure
  end

  def test_create_with_hash_and_version
    failure = create(:gcc => "4.8") { version "4.8.1" }
    assert_fails_with compiler("gcc-4.8", "4.8"), failure
    assert_fails_with compiler("gcc-4.8", "4.8.1"), failure
    refute_fails_with compiler("gcc-4.8", "4.8.2"), failure
  end
end
