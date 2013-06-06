require 'formula'

class Watch < Formula
  homepage 'http://procps.sourceforge.net/'
  url 'http://procps.sourceforge.net/procps-3.2.8.tar.gz'
  sha1 'a0c86790569dec26b5d9037e8868ca907acc9829'

  def install
    system "make", "watch", "PKG_LDFLAGS=-Wl"
    bin.install "watch"
    man1.install "watch.1"
  end
end
