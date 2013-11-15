require 'formula'

class Ori < Formula
  homepage 'http://ori.scs.stanford.edu/'
  url 'https://bitbucket.org/orifs/ori/downloads/ori-0.8.0.tgz'
  sha1 'd8443b5792862c5250e60856702e1c7073047b7e'

  depends_on 'pkg-config' => :build
  depends_on 'scons' => :build
  depends_on 'boost'
  depends_on 'fuse4x'
  depends_on 'libevent'
  depends_on 'openssl'

  def install
    system "scons", "BUILDTYPE=RELEASE"
    system "scons", "install", "PREFIX=#{prefix}"
  end

  def test
    system "#{bin}/ori"
  end
end
