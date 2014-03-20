require 'formula'

class Ori < Formula
  homepage 'http://ori.scs.stanford.edu/'
  url 'https://bitbucket.org/orifs/ori/downloads/ori-0.8.1.tgz'
  sha1 '3ad31ab14bdb9305423f66cb919fdc445215f3c9'

  depends_on 'pkg-config' => :build
  depends_on 'scons' => :build
  depends_on 'boost'
  depends_on 'osxfuse'
  depends_on 'libevent'
  depends_on 'openssl'

  def install
    scons "BUILDTYPE=RELEASE"
    scons "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ori"
  end
end
