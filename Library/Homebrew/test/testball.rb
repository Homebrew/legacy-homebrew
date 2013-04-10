require 'formula'

class TestBall < Formula
  def initialize(*)
    @homepage = 'http://example.com/'
    self.class.instance_eval do
      @stable ||= SoftwareSpec.new
      @stable.url "file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
      @stable.sha1 "482e737739d946b7c8cbaf127d9ee9c148b999f5"
    end
    super "testball"
  end
  def install
    prefix.install "bin"
    prefix.install "libexec"
  end
end

class ConfigureFails < Formula
  url "file:///#{TEST_FOLDER}/tarballs/configure_fails.tar.gz"
  version '1.0.0'
  sha1 'b36c65e5de86efef1b3a7e9cf78a98c186b400b3'

  def initialize(*)
    super "configurefails"
  end

  def install
    system "./configure"
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

  def initialize(*)
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

  def initialize(*)
    super "explicitversionspectestball"
  end
end

class HeadOnlySpecTestBall < Formula
  homepage 'http://example.com'
  head 'https://github.com/mxcl/homebrew.git'

  def initialize(*)
    super "headyonlyspectestball"
  end
end

class IncompleteStableSpecTestBall < Formula
  homepage 'http://example.com'
  head 'https://github.com/mxcl/homebrew.git'
  sha1 '482e737739d946b7c8cbaf127d9ee9c148b999f5'

  def initialize(*)
    super "incompletestablespectestball"
  end
end

class HeadOnlyWithVersionSpecTestBall < Formula
  homepage 'http://example.com'
  head 'https://github.com/mxcl/homebrew.git'
  version '0.3'

  def initialize(*)
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

  def initialize(*)
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

  def initialize(*)
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

  def initialize(*)
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

  def initialize(*)
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

  def initialize(*)
    super "revisedbottlespectestball"
  end
end
