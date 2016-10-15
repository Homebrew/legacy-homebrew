require 'formula'

class Rcsslogplayer < Formula
  homepage 'http://sserver.sourceforge.net/'
  url 'https://downloads.sourceforge.net/sserver/rcsslogplayer/15.1.0/rcsslogplayer-15.1.0.tar.gz'
  sha1 'f1a4140ca98a642e87ea8862c9dcfc6b335df008'

  depends_on 'pkg-config' => :build
  depends_on 'qt'
  depends_on 'boost'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rcsslogplayer --version | tail -1 | grep 'rcsslogplayer Version 15.1.0'"
  end
end
