require 'brewkit'

class Watch <Formula
  homepage 'http://procps.sourceforge.net/'
  url 'http://procps.sourceforge.net/procps-3.2.8.tar.gz'
  md5 '9532714b6846013ca9898984ba4cd7e0'

  def install
    system "make", "watch", "PKG_LDFLAGS=-Wl"
    bin.install "watch"
    man1.install "watch.1"
  end
end
