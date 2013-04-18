require 'formula'

class Pbc < Formula
  homepage 'http://crypto.stanford.edu/pbc/'
  url 'http://crypto.stanford.edu/pbc/files/pbc-0.5.13.tar.gz'
  sha256 '6207b7aea96e61df991c59a27ff9a954922954bc4b3cb9db325a37806b41dc89'

  depends_on 'gmp'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
