require 'formula'

class Libofx < Formula
  homepage 'http://libofx.sourceforge.net'
  url 'http://sourceforge.net/projects/libofx/files/libofx/0.9.8/libofx-0.9.8.tar.gz'
  sha1 'e0159d77c4458eb937871373db85c9f392e86554'

  depends_on 'open-sp'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
