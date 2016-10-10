require 'formula'

class AprUtil < Formula
  url 'http://apache.cs.utah.edu//apr/apr-util-1.3.10.tar.gz'
  homepage ''
  md5 '82acd25cf3df8c72eba44eaee8b80c19'

  depends_on 'apr'

  def install
    system "./configure", "--with-apr=/usr/local", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
