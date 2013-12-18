require 'formula'

class Id3tool < Formula
  homepage 'http://nekohako.xware.cx/id3tool/'
  url 'http://nekohako.xware.cx/id3tool/id3tool-1.2a.tar.gz'
  sha1 '23ce1b33c44290e72a0520c07bc43d1dd4cc7886'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
