require 'formula'

class Scheme48 < Formula
  url 'http://www.s48.org/1.8/scheme48-1.8.tgz'
  homepage 'http://www.s48.org/'
  md5 'f1c0a515039d4df4e07721f21940ad6d'

  skip_clean 'lib'
  skip_clean 'bin'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gc=bibop"
    system "make"
    system "make install"
  end
end
