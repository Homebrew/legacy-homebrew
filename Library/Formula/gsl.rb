require 'formula'

class Gsl < Formula
  homepage 'http://www.gnu.org/software/gsl/'
  url 'http://ftpmirror.gnu.org/gsl/gsl-1.15.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gsl/gsl-1.15.tar.gz'
  md5 '494ffefd90eef4ada678c306bab4030b'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make install"
  end
end
