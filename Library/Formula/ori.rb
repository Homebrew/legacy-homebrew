require "formula"

class Ori < Formula
  homepage "http://ori.scs.stanford.edu/"
  url "https://bitbucket.org/orifs/ori/downloads/ori-0.8.1.tgz"
  sha1 "3ad31ab14bdb9305423f66cb919fdc445215f3c9"
  revision 1

  bottle do
    cellar :any
    sha1 "90e973e4f8921e697668121024fe0417148fe385" => :mavericks
    sha1 "a49ee6a14036e47cfe41c412377e17b6e49e7abd" => :mountain_lion
    sha1 "2f653f4b5c98850aef526c724b1005520c562189" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "boost"
  depends_on "osxfuse"
  depends_on "libevent"
  depends_on "openssl"

  def install
    scons "BUILDTYPE=RELEASE"
    scons "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ori"
  end
end
