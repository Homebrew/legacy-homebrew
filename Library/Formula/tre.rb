require 'formula'

class Tre < Formula
  url 'http://laurikari.net/tre/tre-0.8.0.tar.bz2'
  homepage 'http://laurikari.net/tre/'
  md5 'b4d3232593dadf6746f4727bdda20b41'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
