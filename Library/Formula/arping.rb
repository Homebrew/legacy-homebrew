require 'formula'

class Arping < Formula
  homepage 'https://github.com/ThomasHabets/arping'
  url 'https://github.com/ThomasHabets/arping/archive/arping-2.12.tar.gz'
  sha1 '9109330968cc058f735d59d1a81e8cef760969b5'

  depends_on 'libnet'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
