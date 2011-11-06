require 'formula'

class Btparse < Formula
  url 'http://www.gerg.ca/software/btOOL/btparse-0.34.tar.gz'
  homepage 'http://www.gerg.ca/software/btOOL/'
  md5 '87d09ce6331c57cc2da30b5c83f545e0'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
