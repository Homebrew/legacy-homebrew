require 'formula'

class Camellia < Formula
  homepage 'http://camellia.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/camellia/Unix_Linux%20Distribution/v2.7.0/CamelliaLib-2.7.0.tar.gz'
  sha1 'f7f5004733787731e0c2252d0b5fe2e61622cc9e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
