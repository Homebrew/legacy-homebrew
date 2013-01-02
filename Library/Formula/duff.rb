require 'formula'

class Duff < Formula
  url 'http://downloads.sourceforge.net/project/duff/duff/0.5.2/duff-0.5.2.tar.gz'
  homepage 'http://duff.sourceforge.net/'
  sha1 '23c4dd36f9829f52e436ca53c62d9f01007c7df6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
