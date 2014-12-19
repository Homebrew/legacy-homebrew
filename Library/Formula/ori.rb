require "formula"

class Ori < Formula
  homepage "http://ori.scs.stanford.edu/"
  url "https://bitbucket.org/orifs/ori/downloads/ori-0.8.1.tgz"
  sha1 "3ad31ab14bdb9305423f66cb919fdc445215f3c9"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "d2c83bbfdd11528b16ff74b933181ec32d8f37d2" => :mavericks
    sha1 "cce9adc1c8c8f59be72ef65b4642fff74cbe8cb3" => :mountain_lion
    sha1 "7cbe224571134ff554cb323ebc2ab13a8dd0cf4d" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "boost"
  depends_on :osxfuse
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
