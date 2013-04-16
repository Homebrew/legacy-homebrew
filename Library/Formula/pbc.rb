require 'formula'

class Pbc < Formula
  homepage 'http://crypto.stanford.edu/pbc/'
  url 'http://crypto.stanford.edu/pbc/files/pbc-0.5.13.tar.gz'
  sha1 'f3e040a7f6648444feb77adffad514b5616aa2c9'

  depends_on 'gmp'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
