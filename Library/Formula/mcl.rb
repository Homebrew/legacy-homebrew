require 'formula'

class Mcl < Formula
  version '12-135'
  url 'http://micans.org/mcl/src/mcl-12-135.tar.gz'
  homepage 'http://micans.org/mcl'
  md5 '99bb9a5ef5f54749d695a7319c1cb40c'

  def install
    # Force the compiler to run in C89 mode because one of the source
    # files uses "restrict" as a variable name and this is a restricted
    # keyword in C99
    ENV.append_to_cflags '-std=c89'

    bin.mkpath
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-blast"
    system "make install"
  end
end
