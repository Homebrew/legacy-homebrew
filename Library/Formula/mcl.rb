require 'formula'

class Mcl < Formula
  homepage 'http://micans.org/mcl'
  url 'http://micans.org/mcl/src/mcl-12-135.tar.gz'
  version '12-135'
  sha1 '27e7bc08fe5f0d3361bbc98d343c9d045712e406'

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
