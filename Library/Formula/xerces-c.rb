require 'formula'

class XercesC < Formula
  homepage 'http://xerces.apache.org/xerces-c/'
  url 'http://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.1.1.tar.gz'
  sha1 '177ec838c5119df57ec77eddec9a29f7e754c8b2'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
