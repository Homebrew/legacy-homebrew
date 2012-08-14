require 'formula'

class Id3tool < Formula
  homepage 'http://nekohako.xware.cx/id3tool/'
  url 'http://nekohako.xware.cx/id3tool/id3tool-1.2a.tar.gz'
  md5 '061185562c0d0e6327406d9fc2f194b2'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
