require 'formula'

class Gputils < Formula
  url 'http://downloads.sourceforge.net/project/gputils/gputils/0.13.7/gputils-0.13.7.tar.gz'
  homepage 'http://gputils.sourceforge.net/'
  sha1 '79fe71a9d6d4d16a5488386aceba309719d8d7fb'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
