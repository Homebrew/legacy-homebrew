require 'formula'

class Pbc <Formula
  url 'http://crypto.stanford.edu/pbc/files/pbc-0.5.7.tar.gz'
  homepage 'http://crypto.stanford.edu/pbc/'
  md5 '5b188ab05a65969118427813872dc8ef'

  depends_on 'gmp'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
