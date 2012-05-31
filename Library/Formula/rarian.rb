require 'formula'

class Rarian < Formula
  homepage 'http://rarian.freedesktop.org/'
  url 'http://rarian.freedesktop.org/Releases/rarian-0.8.1.tar.bz2'
  md5 '75091185e13da67a0ff4279de1757b94'

  def install
    if Formula.factory('scrollkeeper').installed?
      opoo "rarian conflicts with scrollkeeper. Your scrollkeeper binaries will be overwritten.
         If this bothers you, you can restore scrollkeeper with `brew link scrollkeeper`."
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
