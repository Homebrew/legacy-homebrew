require 'formula'

class Arping < Formula
  homepage 'https://github.com/ThomasHabets/arping'
  url 'https://github.com/ThomasHabets/arping/archive/arping-2.13.tar.gz'
  sha1 'a253cdfcb83360d4acd5e4fe1d84ed8105a94829'

  depends_on 'libnet'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
