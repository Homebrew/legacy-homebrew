require 'formula'

class Watch < Formula
  homepage 'http://procps.sourceforge.net/'
  url 'http://procps.sourceforge.net/procps-3.2.8.tar.gz'
  version '0.2.0' # watch command itself is version 0.2.0
  sha1 'a0c86790569dec26b5d9037e8868ca907acc9829'

  conflicts_with 'visionmedia-watch'

  def install
    system "make", "watch", "PKG_LDFLAGS="
    bin.install "watch"
    man1.install "watch.1"
  end
end
