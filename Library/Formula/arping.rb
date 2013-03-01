require 'formula'

class Arping < Formula
  homepage 'https://github.com/ThomasHabets/arping'
  url 'https://github.com/ThomasHabets/arping/tarball/arping-2.12'
  sha1 'b8c7469cfbcc021971d664381f545fb10460e0de'

  depends_on 'libnet'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
