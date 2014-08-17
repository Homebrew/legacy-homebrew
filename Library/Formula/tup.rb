require 'formula'

class Tup < Formula
  homepage 'http://gittup.org/tup/'
  url 'https://github.com/gittup/tup/archive/v0.7.2.tar.gz'
  sha1 'c0b14a9b7a59c6295ed7339883b21d0f1a8163b3'
  head 'https://github.com/gittup/tup.git'

  bottle do
    cellar :any
    sha1 "ea07e07027a25f92959c07844a34e24a62c1929e" => :mavericks
    sha1 "c7ff37eec01fc7e5049cd5da450b88554f46f2b1" => :mountain_lion
    sha1 "98255d59e38f854319a60091037fa0f605bcde1f" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'

  def install
    ENV['TUP_LABEL'] = version
    system "./build.sh"
    bin.install 'build/tup'
    man1.install 'tup.1'
  end

  test do
    system "#{bin}/tup", "-v"
  end
end
