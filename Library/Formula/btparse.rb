require 'formula'

class Btparse < Formula
  url 'http://www.gerg.ca/software/btOOL/btparse-0.34.tar.gz'
  homepage 'http://www.gerg.ca/software/btOOL/'
  sha1 'cfc2a5364b99121843dae4fd4ce1b01326a7a0bb'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
