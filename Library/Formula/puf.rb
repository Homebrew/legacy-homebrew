require 'formula'

class Puf < Formula
  homepage 'http://puf.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/puf/puf/1.0.0/puf-1.0.0.tar.gz'
  sha1 '2e804cf249faf29c58aac26933cfa10b437710c3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
