require 'formula'

class Libbs2b < Formula
  homepage 'http://bs2b.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/bs2b/libbs2b/3.1.0/libbs2b-3.1.0.tar.gz'
  sha1 'a71318211611a00bd3d595b0830d2188938ff89d'

  depends_on 'pkg-config' => :build
  depends_on 'libsndfile'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-static",
                          "--enable-shared"
    system "make install"
  end
end
