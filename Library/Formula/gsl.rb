require 'formula'

class Gsl < Formula
  url 'http://ftpmirror.gnu.org/gsl/gsl-1.15.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gsl/gsl-1.15.tar.gz'
  homepage 'http://www.gnu.org/software/gsl/'
  md5 '494ffefd90eef4ada678c306bab4030b'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make install"
  end
end
