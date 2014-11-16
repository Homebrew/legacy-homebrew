require 'formula'

class Torrentcheck < Formula
  homepage 'http://torrentcheck.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/torrentcheck/torrentcheck-1.00.zip'
  sha256 'a839f9ac9669d942f83af33db96ce9902d84f85592c99b568ef0f5232ff318c5'

  def install
    inreplace "torrentcheck.c", "#include <malloc.h>", ""
    system ENV.cc, ENV.cflags, "torrentcheck.c", "sha1.c", "-o", "torrentcheck"
    bin.install 'torrentcheck'
  end

  test do
    system "#{bin}/torrentcheck"
  end
end
