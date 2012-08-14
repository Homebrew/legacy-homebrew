require 'formula'

class Arping < Formula
  homepage 'https://github.com/ThomasHabets/arping'
  url 'https://github.com/ThomasHabets/arping/tarball/arping-2.11'
  sha1 '8a02193f3f1d2faaf717c0ea31c42d5c1aeb826e'

  depends_on 'libnet'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
