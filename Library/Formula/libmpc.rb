require 'formula'

class Libmpc < Formula
  homepage 'http://multiprecision.org'
  url 'http://multiprecision.org/mpc/download/mpc-1.0.1.tar.gz'
  sha1 '8c7e19ad0dd9b3b5cc652273403423d6cf0c5edf'

  bottle do
    cellar :any
    sha1 'c8bbad14fa8314418e07aa7a5cd824452fa6ea1e' => :mountain_lion
    sha1 '21363b47cdc6085b1c09aead7f63918c69a57bed' => :lion
    sha1 '2b2fb525a4e87e7a954e70be13dfde1110329859' => :snow_leopard
  end

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--with-gmp=#{Formula.factory('gmp').opt_prefix}",
      "--with-mpfr=#{Formula.factory('mpfr').opt_prefix}"
    ]

    system "./configure", *args
    system "make"
    system "make check"
    system "make install"
  end
end
