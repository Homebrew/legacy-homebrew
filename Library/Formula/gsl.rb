require 'formula'

class Gsl < Formula
  url 'ftp://ftp.gnu.org/gnu/gsl/gsl-1.14.tar.gz'
  homepage 'http://www.gnu.org/software/gsl/'
  md5 'd55e7b141815412a072a3f0e12442042'

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
