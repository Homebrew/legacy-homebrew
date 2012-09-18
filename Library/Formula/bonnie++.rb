require 'formula'

class Bonniexx < Formula
  url 'http://www.coker.com.au/bonnie++/experimental/bonnie++-1.96.tgz'
  homepage 'http://www.coker.com.au/bonnie++/'
  sha1 '24a0e3de4dc98f905654f51ef6732b1b766e1378'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
