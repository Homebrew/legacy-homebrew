require 'formula'

class Pbc <Formula
  url 'http://crypto.stanford.edu/pbc/files/pbc-0.5.11.tar.gz'
  homepage 'http://crypto.stanford.edu/pbc/'
  md5 '93101db31c41dffcce9f4b87edbd8d96'

  depends_on 'gmp'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
