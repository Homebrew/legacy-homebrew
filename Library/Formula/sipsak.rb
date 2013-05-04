require 'formula'

class Sipsak < Formula
  homepage 'http://sipsak.org/'
  url 'http://download.berlios.de/sipsak/sipsak-0.9.6-1.tar.gz'
  version '0.9.6'
  sha1 '6d2fd2c90ea04be749e48927b3e7fc08c52166b6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
