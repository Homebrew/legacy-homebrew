require 'formula'

class Bonniexx < Formula
  homepage 'http://www.coker.com.au/bonnie++/'
  url 'http://www.coker.com.au/bonnie++/experimental/bonnie++-1.97.tgz'
  sha1 '7b0ed205725a6526d34894412edb7e29bb9df7b4'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
