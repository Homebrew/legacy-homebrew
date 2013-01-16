require 'formula'

class Isl < Formula
  homepage 'http://www.kotnet.org/~skimo/isl/'
  url 'http://www.kotnet.org/~skimo/isl/isl-0.11.1.tar.bz2'
  mirror 'ftp://ftp.linux.student.kuleuven.be/pub/people/skimo/isl/isl-0.11.1.tar.bz2'
  sha1 'd7936929c3937e03f09b64c3c54e49422fa8ddb3'

  head 'http://repo.or.cz/w/isl.git'

  depends_on 'gmp'

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]

    system "./configure", *args
    system "make install"
  end
end
