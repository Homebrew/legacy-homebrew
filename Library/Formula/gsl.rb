require 'formula'

class Gsl < Formula
  homepage 'http://www.gnu.org/software/gsl/'
  url 'http://ftpmirror.gnu.org/gsl/gsl-1.15.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gsl/gsl-1.15.tar.gz'
  sha1 'd914f84b39a5274b0a589d9b83a66f44cd17ca8e'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make install"
  end
end
