require 'formula'

class Gputils < Formula
  homepage 'http://gputils.sourceforge.net/'
  url 'http://sourceforge.net/projects/gputils/files/gputils/0.14.2/gputils-0.14.2.tar.gz'
  sha1 '65253319f2e105eb17a8d5b9a77454f213ca5efe'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
