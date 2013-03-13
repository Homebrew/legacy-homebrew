require 'formula'

class Pbc < Formula
  homepage 'http://crypto.stanford.edu/pbc/'
  url 'http://crypto.stanford.edu/pbc/files/pbc-0.5.12.tar.gz'
  sha1 '6fc0815a3e7766958365df4495247049d1bf968c'

  depends_on 'gmp'

  fails_with :clang do
    build 421
    cause "Clang does not support nested functions"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
