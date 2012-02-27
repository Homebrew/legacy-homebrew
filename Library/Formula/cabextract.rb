require 'formula'

class Cabextract < Formula
  url 'http://www.cabextract.org.uk/cabextract-1.4.tar.gz'
  homepage 'http://www.cabextract.org.uk/'
  md5 '79f41f568cf1a3ac105e0687e8bfb7c0'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
