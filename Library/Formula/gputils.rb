require 'formula'

class Gputils < Formula
  homepage 'http://gputils.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/gputils/gputils/1.2.0/gputils-1.2.0.tar.gz'
  sha1 '9f3a5d9ee7e2f4f897cd5f8ac56d6679b7c4faba'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
