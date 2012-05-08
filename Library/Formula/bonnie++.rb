require 'formula'

class Bonniexx < Formula
  url 'http://www.coker.com.au/bonnie++/experimental/bonnie++-1.96.tgz'
  homepage 'http://www.coker.com.au/bonnie++/'
  md5 '7b8594559f00887d2865de1838328b35'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
