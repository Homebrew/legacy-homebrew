require 'formula'

class OpenSp < Formula
  url 'http://downloads.sourceforge.net/project/openjade/opensp/1.5.2/OpenSP-1.5.2.tar.gz'
  homepage 'http://openjade.sourceforge.net'
  md5 '670b223c5d12cee40c9137be86b6c39b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}",
                          "--disable-doc-build"
    system "make install"
  end
end
