require 'formula'

class Gputils < Formula
  homepage 'http://gputils.sourceforge.net/'
  url 'http://sourceforge.net/projects/gputils/files/gputils/0.14.3/gputils-0.14.3.tar.gz'
  sha1 '182da2eed6671cef4f2120a06913fe42e2e85110'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
