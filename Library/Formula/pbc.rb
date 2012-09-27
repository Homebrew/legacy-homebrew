require 'formula'

class Pbc < Formula
  url 'http://crypto.stanford.edu/pbc/files/pbc-0.5.12.tar.gz'
  homepage 'http://crypto.stanford.edu/pbc/'
  sha1 '6fc0815a3e7766958365df4495247049d1bf968c'

  depends_on 'gmp'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
