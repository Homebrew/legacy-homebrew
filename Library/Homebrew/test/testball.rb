require 'formula'

class TestBall < Formula
  # name parameter required for some Formula::factory
  def initialize name=nil
    @homepage = 'http://example.com/'
    @stable ||= SoftwareSpec.new
    @stable.url "file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
    super "testball"
  end
  def install
    prefix.install "bin"
    prefix.install "libexec"
  end
end

class TestBallWithRealPath < TestBall
  def initialize name=nil
    super "testballwithrealpath"
    @path = Pathname.new(__FILE__)
  end
end

class TestBallWithMirror < Formula
  url "file:///#{TEST_FOLDER}/bad_url/testball-0.1.tbz"
  mirror "file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"

  def initialize name=nil
    super "testballwithmirror"
  end
end

class ConfigureFails < Formula
  # name parameter required for some Formula::factory
  url "file:///#{TEST_FOLDER}/tarballs/configure_fails.tar.gz"
  version '1.0.0'
  sha1 'b36c65e5de86efef1b3a7e9cf78a98c186b400b3'

  def initialize name=nil
    super "configurefails"
  end

  def install
    system "./configure"
  end
end

class TestCompilerFailures < Formula
  def initialize name=nil
    @stable = SoftwareSpec.new "file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
    super "compilerfailures"
  end
end

class TestAllCompilerFailures < TestCompilerFailures
  fails_with :clang
  fails_with :llvm
  fails_with :gcc
end

class TestNoCompilerFailures < TestCompilerFailures
  fails_with(:clang) { build 42 }
  fails_with(:llvm) { build 42 }
  fails_with(:gcc) { build 42 }
end

class TestLLVMFailure < TestCompilerFailures
  fails_with :llvm
end

class TestMixedCompilerFailures < TestCompilerFailures
  fails_with(:clang) { build MacOS.clang_build_version }
  fails_with(:llvm) { build 42 }
  fails_with(:gcc) { build 5666 }
end

class TestMoreMixedCompilerFailures < TestCompilerFailures
  fails_with(:clang) { build 42 }
  fails_with(:llvm) { build 2336 }
  fails_with(:gcc) { build 5666 }
end

class TestEvenMoreMixedCompilerFailures < TestCompilerFailures
  fails_with :clang
  fails_with(:llvm) { build 2336 }
  fails_with(:gcc) { build 5648 }
end

class TestBlockWithoutBuildCompilerFailure < TestCompilerFailures
  fails_with :clang do
    cause "failure"
  end
end

class SpecTestBall < Formula
  homepage 'http://example.com'
  url 'file:///foo.com/testball-0.1.tbz'
  mirror 'file:///foo.org/testball-0.1.tbz'
  sha1 '482e737739d946b7c8cbaf127d9ee9c148b999f5'

  head 'https://github.com/mxcl/homebrew.git', :tag => 'foo'

  devel do
    url 'file:///foo.com/testball-0.2.tbz'
    mirror 'file:///foo.org/testball-0.2.tbz'
    sha256 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
  end

  bottle do
    sha1 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef' => :snow_leopard_32
    sha1 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef' => :snow_leopard
    sha1 'baadf00dbaadf00dbaadf00dbaadf00dbaadf00d' => :lion
    sha1 '8badf00d8badf00d8badf00d8badf00d8badf00d' => :mountain_lion
  end

  def initialize name=nil
    super "spectestball"
  end
end

class ExplicitVersionSpecTestBall < Formula
  homepage 'http://example.com'
  url 'file:///foo.com/testball-stable.tbz'
  sha1 '482e737739d946b7c8cbaf127d9ee9c148b999f5'
  version '0.3'

  devel do
    url 'file:///foo.com/testball-devel.tbz'
    sha1 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
    version '0.4'
  end

  bottle do
    version '1'
    sha1 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef' => :snow_leopard
    sha1 'baadf00dbaadf00dbaadf00dbaadf00dbaadf00d' => :lion
    sha1 '8badf00d8badf00d8badf00d8badf00d8badf00d' => :mountain_lion
  end

  def initialize name=nil
    super "explicitversionspectestball"
  end
end

class HeadOnlySpecTestBall < Formula
  homepage 'http://example.com'
  head 'https://github.com/mxcl/homebrew.git'

  def initialize name=nil
    super "headyonlyspectestball"
  end
end

class IncompleteStableSpecTestBall < Formula
  homepage 'http://example.com'
  head 'https://github.com/mxcl/homebrew.git'
  sha1 '482e737739d946b7c8cbaf127d9ee9c148b999f5'

  def initialize name=nil
    super "incompletestablespectestball"
  end
end

class HeadOnlyWithVersionSpecTestBall < Formula
  homepage 'http://example.com'
  head 'https://github.com/mxcl/homebrew.git'
  version '0.3'

  def initialize name=nil
    super "headonlywithversionspectestball"
  end
end

class ExplicitStrategySpecTestBall < Formula
  homepage 'http://example.com'
  url 'file:///foo.com/testball-stable', :using => :hg, :tag => '0.2'
  head 'file:///foo.com/testball-head', :using => :svn

  devel do
    url 'file:///foo.com/testball-devel', :using => :bzr, :tag => '0.3'
  end

  def initialize name=nil
    super "explicitstrategyspectestball"
  end
end

class SnowLeopardBottleSpecTestBall < Formula
  homepage 'http://example.com'
  url 'file:///foo.com/testball-0.1.tbz'
  sha1 '482e737739d946b7c8cbaf127d9ee9c148b999f5'

  bottle do
    cellar :any
    sha1 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef' => :snow_leopard
  end

  def initialize name=nil
    super "snowleopardbottlespectestball"
  end
end

class LionBottleSpecTestBall < Formula
  homepage 'http://example.com'
  url 'file:///foo.com/testball-0.1.tbz'
  sha1 '482e737739d946b7c8cbaf127d9ee9c148b999f5'

  bottle do
    cellar :any
    sha1 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef' => :lion
  end

  def initialize name=nil
    super "lionbottlespectestball"
  end
end

class AllCatsBottleSpecTestBall < Formula
  homepage 'http://example.com'
  url 'file:///foo.com/testball-0.1.tbz'
  sha1 '482e737739d946b7c8cbaf127d9ee9c148b999f5'

  bottle do
    prefix '/private/tmp/testbrew/prefix'
    cellar '/private/tmp/testbrew/cellar'
    sha1 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef' => :snow_leopard_32
    sha1 'faceb00cfaceb00cfaceb00cfaceb00cfaceb00c' => :snow_leopard
    sha1 'baadf00dbaadf00dbaadf00dbaadf00dbaadf00d' => :lion
    sha1 '8badf00d8badf00d8badf00d8badf00d8badf00d' => :mountain_lion
  end

  def initialize name=nil
    super "allcatsbottlespectestball"
  end
end

class RevisedBottleSpecTestBall < Formula
  homepage 'http://example.com'
  url 'file:///foo.com/testball-0.1.tbz'
  sha1 '482e737739d946b7c8cbaf127d9ee9c148b999f5'

  bottle do
    revision 1
    sha1 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef' => :snow_leopard_32
    sha1 'faceb00cfaceb00cfaceb00cfaceb00cfaceb00c' => :snow_leopard
    sha1 'baadf00dbaadf00dbaadf00dbaadf00dbaadf00d' => :lion
    sha1 '8badf00d8badf00d8badf00d8badf00d8badf00d' => :mountain_lion
  end

  def initialize name=nil
    super "revisedbottlespectestball"
  end
end

class CustomVersionScheme < Version
end

class CustomVersionSchemeTestBall < Formula
  homepage 'http://example.com'
  url 'file:///foo.com/testball-0.1.tbz'
  sha1 '482e737739d946b7c8cbaf127d9ee9c148b999f5'
  version '1.0' => CustomVersionScheme

  def initialize name=nil
    super "customversionschemetestball"
  end
end
