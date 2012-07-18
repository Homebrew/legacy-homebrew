require 'formula'

class Links < Formula
  homepage 'http://links.twibright.com/'
  url 'http://links.twibright.com/download/links-2.7.tar.gz'
  sha1 'e0773f2b23397bcbd08d5a3145d94e446dfb4969'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
