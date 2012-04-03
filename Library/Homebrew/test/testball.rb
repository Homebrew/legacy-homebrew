require 'formula'

class TestBall <Formula
  # name parameter required for some Formula::factory
  def initialize name=nil
    @url="file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
    @homepage = 'http://example.com/'
    super "testball"
  end
  def install
    prefix.install "bin"
    prefix.install "libexec"
  end
end

class TestBallWithMirror < Formula
  # `url` is bogus---curl should fail to download it. The mirror is fine
  # though.
  url "file:///#{TEST_FOLDER}/bad_url/testball-0.1.tbz"
  mirror "file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"

  def initialize name=nil
    @homepage = 'http://example.com/'
    super "testballwithmirror"
  end
end

class ConfigureFails <Formula
  # name parameter required for some Formula::factory
  def initialize name=nil
    @url="file:///#{TEST_FOLDER}/tarballs/configure_fails.tar.gz"
    @homepage = 'http://example.com/'
    @version = '1.0.0'
    @md5 = '9385e1b68ab8af68ac2c35423443159b'
    super "configurefails"
  end

  def install
    system "./configure"
  end
end

class TestAllCompilerFailures < Formula
  def initialize name=nil
    @url="file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
    @homepage = 'http://example.com/'
    super "compilerfailures"
  end

  fails_with :clang
  fails_with :llvm
  fails_with :gcc
end

class TestNoCompilerFailures < Formula
  def initialize name=nil
    @url="file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
    @homepage = 'http://example.com/'
    super "nocompilerfailures"
  end

  fails_with(:clang) { build 42 }
  fails_with(:llvm) { build 42 }
  fails_with(:gcc) { build 42 }
end

class TestLLVMFailure < Formula
  def initialize name=nil
    @url="file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
    @homepage = 'http://example.com/'
    super "llvmfailure"
  end

  fails_with :llvm
end

class TestMixedCompilerFailures < Formula
  def initialize name=nil
    @url="file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
    @homepage = 'http://example.com/'
    super "mixedcompilerfailures"
  end

  fails_with(:clang) { build MacOS.clang_build_version }
  fails_with(:llvm) { build 42 }
  fails_with(:gcc) { build 5666 }
end

class TestMoreMixedCompilerFailures < Formula
  def initialize name=nil
    @url="file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
    @homepage = 'http://example.com/'
    super "moremixedcompilerfailures"
  end

  fails_with(:clang) { build 42 }
  fails_with(:llvm) { build 2336 }
  fails_with(:gcc) { build 5666 }
end

class TestEvenMoreMixedCompilerFailures < Formula
  def initialize name=nil
    @url="file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
    @homepage = 'http://example.com/'
    super "evenmoremixedcompilerfailures"
  end

  fails_with :clang
  fails_with(:llvm) { build 2336 }
  fails_with(:gcc) { build 5648 }
end

class TestBlockWithoutBuildCompilerFailure < Formula
  def initialize name=nil
    @url="file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
    @homepage = 'http://example.com/'
    super "blockwithoutbuildcompilerfailure"
  end

  fails_with :clang do
    cause "failure"
  end
end
