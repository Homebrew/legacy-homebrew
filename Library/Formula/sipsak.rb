require 'formula'

class Sipsak < Formula
  url 'http://download.berlios.de/sipsak/sipsak-0.9.6-1.tar.gz'
  homepage 'http://sipsak.org/'
  md5 'c4eb8e282902e75f4f040f09ea9d99d5'
  version '0.9.6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
